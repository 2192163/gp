<center>

# **COP Time Based Retry Processor** 

</center>

<p style="page-break-after: always;">&nbsp;</p>

## Table of Contents

[1. Introduction](#_Introduction)     
[1.1 Scope](#_Scope)      
[1.2 Out of Scope](#_OutofScope)      
[1.3 Assumption](#_Assumption)      
[2. Design](#_Design)     
[2.1 Class Diagram](#_ClassDiagram)      
[2.2 Interface Details](#_InterfaceDetails)      
[3. Libraries and Dependencies](#_LibrariesandDependencies)     
[4. Database design](#_Databasedesign)     
[5. Application configuration](#_Applicationconfiguration)     
[6. Additional Details](#_AdditionalDetails)     
[7. How to](#_Howto)     

<p style="page-break-after: always;">&nbsp;</p>



### <a id="_Introduction"></a>1. Introduction 



COP Time Based Retry Processor is a project which was developed as part of the retry flow of COP. The processor is scheduled to trigger retry flow for a fixed interval and checks for transactions which are stuck at ‘NONCE_PUBLISHED’ state due to not receiving any response from the device and retry it for fixed number of times. It also checks for timeout transactions which are stuck at retry state and sends onboarding response to device. The features of COP Time Based Retry Processor are listed below:

*	The COP Time Based Retry Processor is scheduled to trigger the retry flow every fixed interval.
*	The COP Time Based Retry Processor retries the message of particular status which are out of the given timeout duration.
*	It fetches records having states ‘NONCE_PUBLISHED’ satisfying the retry condition from ‘t_chipset_onboarding’ table and the original message of that particular record is published to the resilience processor queue for retrying.
*	The transaction states are updated to ‘currentState_RETRY’ after publishing the message to queue for retrying.
*	It fetches records having states ending with ‘_RETRY’ satisfying the timeout condition from ‘t_chipset_onboarding’ table and reports error code back to device. The transaction states are then updated to states ending with ‘_TIMEOUT’ instead of ‘_RETRY’.




### <a id="_Scope"></a>1.1 Scope 

*	The COP Time Based Retry Processor retries a particular message which is out of the given timeout duration.
*	It is scheduled to trigger retry flow for a fixed interval.
*	The retrying of message is done by publishing the original message to resilience processor queue. This publishing to queue module is designed to process as a separate thread.
*	Records having state ‘NONCE_PUBLISHED’ with time difference between current time and onboarding status time greater than nonce expiry duration is fetched from t_chipset_onboarding table. Then original message which is stored in table t_chipset_provision_request is published to the resilience processor queue for retrying. Rest is timeout transactions.
*	Similarly, it fetches records having states ending with ‘_RETRY’ with time difference between current time and created time greater than retry timeout duration from ‘t_chipset_onboarding’ table and reports error code back to device.
*	For the retried messages, the onboarding status are updated to ‘currentState_RETRY’ after publishing the message to queue for retrying. For the timeout transactions, the onboarding status are updated by replacing ‘_RETRY’ with ‘_TIMEOUT’.




### <a id="_OutofScope"></a>1.2 Out of Scope 

COP Time Based Retry Processor uses various modules for its working.

*	COP Time Based Retry Processor makes use of C2DSender to send onboarding response to device.
*	COP Time Based Retry Processor also depends of resilience processor to retry messages


### <a id="_Assumption"></a>1.3 Assumption 

* COP Time Based Retry Processor needs internal dependencies named c2c_base_queue_sqs_impl and c2c_base_common for its working.These wrappers must be running for COP Time Based Retry Processor to work
* COP Time Based Retry Processor depends on other software modules for its working.Modules like resilience processor, c2dsender are essential for COP Time Based Retry Processor to complete its flow.

## <a id="_Design"></a>2. Design

##### ARCHITECTURE:

COP Time Based Retry Processor is a scheduler processor which checks for transactions that must be retried or timeout as part of the retry flow of COP. For retrying, records having ‘NONCE_PUBLISHED’ with time difference between current time and onboarding status time greater than nonce expiry duration is fetched from table. For retrying, the StandardInternalMessage of that particular record is published to resilience processor queue, which then retries it for a fixed number of times.  For the retried records, the onboaridng status is updated to ‘currentState_RETRY’ after publishing the message to queue. 
The processor also checks for timeout transactions. The records that are stuck at ‘_RETRY’ state for more than retry timeout duration value are fetched and reported to device with corresponding error code. The onboarding status of those records are then updated from states ending with ‘_RETRY’ to ‘_TIMEOUT’.

##### High level diagram
 <figure>
    <img src="../../../assets/cop_retry_high_level_v0.1.png" width="700" />
		<figcaption>High Level Architecture Diagram</figcaption>
 </figure>

###### FLOWCHART:

 <figure>
	<img src="../../../assets/cop_retry_flow_3.0.png" width="700" />
		<figcaption>FLOW CHART</figcaption>
 </figure>
		
*	It is scheduled to trigger retry flow for every 5 minute interval.
*	The retrying of message is done by publishing the original message to resilience processor queue. This publishing to queue module is designed to process as a separate thread.
*	Records having state ‘NONCE_PUBLISHED’ with time difference between current time and onboarding status time greater than nonce expiry duration is fetched from t_chipset_onboarding table. Then original message which is stored in table t_chipset_provision_request is published to the resilience processor queue for retrying. Rest is timeout transactions.
*	Similarly, it fetches records having states ending with ‘_RETRY’ with time difference between current time and created time greater than retry timeout duration from ‘t_chipset_onboarding’ table and reports error code back to device.
*	For the retried messages, the onboarding status are updated to ‘currentState_RETRY’ after publishing the message to queue for retrying. For the timeout transactions, the onboarding status are updated by replacing ‘_RETRY’ with ‘_TIMEOUT’.

		
###### SEQUENCE DIAGRAM:

 <figure>
	<img src="../../../assets/cop_retry_sequencev2.png" width="700" />
		<figcaption>Low Level Sequence Diagram</figcaption>
 </figure>



### <a id="_ClassDiagram"></a>2.1 Class Diagram

|Sl No| Class | Functionality and Public Methods |  
| :------------- | :------------- | :------------ |
1|	COPRetryProcessor|	The Class COPRetryProcessor retrieves records which satisfies conditions for retrying and timeout separately from t_chipset_onboarding table and invokes method to send for retry or send to device if its timeout correspondingly. 
|||Methods : process (): It fetched nonce published records and send for retry as a separate thread. Also, it fetches timeout records and send message, corresponding timeout status and error code to queue writer service to send onboarding response to device
2|	COPRetryQueueWriterService	|The Class COPRetryQueueWriterService is a service class to publish retry to the resilience processor queue for retry as a separate thread and also to send onboarding response to device for records which are timeout. 
|||Methods : 1.	writeToRetryQueue: To publish to resilience processor queue and update onboarding status to nonce_publised_retry, 2.	sendResponseToDevice: To send onboarding response to device with errorcode and update onboarding status to timeout. 
3|	COPRetryDatabaseService|	The Class COPRetryDatabaseService used to perform database operation logics. It connects to different repositories and performs insertion and retrieval of data.
|||Methods : 1.	getNoncePublisedRecords (): Gets all the chipset details from t_chipset_onboarding table based on onboarding status=NONCE_PUBLISHED. 2.	getRetryTimeOutRecords ():  Gets all the timeout chipset details from t_chipset_onboarding table based on onboarding status ending with _RETRY. 3.	updateOnboardingState (): Updates the onboarding status in table. 4.	findRetryMessageById (): To find the original message to be retried from t_chipset_provision_request table.
4|	COPRetryJob|	The Class COPRetryJob is the class which implements Job for scheduling the process every fixed interval.
5|	MessagePublisherThread|	The Class MessagePublisherThread class which implements publishing of retry messages to the queue as a thread.
6	|COPRetryUtils	|The class COPRetryUtils contains common method which is used all across project.
|||Methods : enrichMessageWithErrorCode () : Its used to enrich message's propertybag with error code.


 <figure>
	<img src="../../../assets/cop_retry_classdiagram.png" width="700" />
				<figcaption>Class Diagram</figcaption>
 </figure>


### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA

## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

###### Maven Dependencies:

*	org.springframework.boot: spring-boot-starter-web
*	org.springwork.boot: spring-boot-starter-test
*	org.springwork.boot: spring-boot-starter-data-jpa
*	org.springframework.boot: spring-boot-maven-plugin
*	junit : junit
*	org.springframework.cloud: spring-cloud-starter-config
*	org.springframework.cloud: spring-cloud-starter-bootstrap
*	org.mockito: mockito-core
*	org.jacoco:jacoco-maven-plugin
*	org.projectlombok:lombok
*	org.postgresql: postgresql
*	org.quartz-scheduler:quartz


###### Internal Dependencies:

*	com.c2c: c2c_base_common
*	com.c2c.queue.client: c2c_base_queue_sqs_impl





## <a id="_Databasedesign"></a>4. Database design

database : **c2c_device_registration_service_db (schema:public)**

   **t_chipset_onboarding**
   
|Column Name |	Datatype 
| :------------- | :------------ |
id| 	Long 
system_id |	String 
device_id |	String 
chipset_id |	Long 
onboarded_program_id |	Integer 
onboarded_sku_id |	Integer 
ecu_id| 	String 
transaction_id| 	Integer 
name| 	String 
type |	String 
chipset_sp |	String 
sw_version |	String 
hw_version |	String 
license_serial |	String 
state |	String 
onboarding_status |	String 
onboarding_status_time |	String 
created_by |	String 
created_time |	Long 
updated_by |	String 
updated_time |	Long 


**t_chipset_provision_request**

|Column Name |	Datatype 
| :------------- | :------------ |
id|	long
message|	String
created_by|	String
created_time|	Long



    


## <a id="_Applicationconfiguration"></a>5. Application configuration

*	aws.credentials.access-key:Encrypted access key for Amazon Web services
*	aws.credentials.secret-key:Encrypted secret key for Amazon Web services
*	aws.region=Region name to be accessed in Amazon Web services.Datatype is String
*	spring.datasource.url=database url along with database name
*	spring.datasource.username= database username
*	spring.datasource.password=database password
*	spring.jpa.show-sql=to show database entry logs in logs
*	spring.datasource.driver-class-name=postgres driver class name
*	c2dsender-queue= The queue name to which C2DSender listens.Datatype is String.The name of the queue is {env}_cc_sq_c2d_inbound_queue
*	cop-retry-queue=The queue name to which COP retry messages are send.Datatype is String.The name of the queue is {env}_resilience_sqs_chipsetonboardingpro
*	nonce-expiry-duration=Its nonce duration which is used to determine whether nonce is expired , for now its 5 minutes. Datatype is Long
*	retry-interval=Its the retry interval to trigger retry flow, for now its 5 minutes. Datatype is Long
*	retry-timeout-duration=Its retry timeout duration which is used to determine whether state is stuck in _retry status for a long time  , for now its 20 minutes. Datatype is Long
*	spring.application.name=Name of the spring application
 
## <a id="_AdditionalDetails"></a>6. Additional Details

###### Logging:
 All the projects are having a common logging framework which is implemented in the module c2c_base_common by making use of the spring cloud sleuth, MDC context to achieve the logging. Also making use of baggage propagation provided by the sleuth to propagate the trace. Entry and exit log will be logged by this module for every public method using the Spring AOP concept. Trace id and span id are injected into all logs. Along with-it identifiers like message type, message id etc. are also logged in every line. Execution time is logged for every method which uses @LogExecutionTime annotation. 
 
###### Security:
 
* Validates input
* Does not allow dynamic construction of queries using user-supplied data
* Signed to verify the authenticity of its origin
* Does not use predictable session identifiers
* Does not hard-code secrets inline
* Does not cache credentials
* Handles exceptions explicitly
* Does not disclose too much information in its errors
* Does not use weak cryptographic algorithms
* Does not use banned APIs or unsafe functions
   
   
###### Error Handling:

*	Usage of try catch blocks in important methods so that the processor will not get terminated even if one method fails. Exceptions are caught and logged properly
*	Identified scenarios where we can retry, and where we can’t retry. For validation failures we are not retrying but in scenarios where failure is due to network failure or due to some db issues we are retrying the input message by forwarding it to resilience processor


List of all platforms wide error codes and their respective description are listed in the link below. Based on the error code, a consumer can take an action based on the severity of the error.




## <a id="_Howto"></a>7. How to

NA
    

| Acronym or term|   Definition |  
| :------------- | :------------ |
| C2DSender | Cloud to Device Sender |     
| COP |  Chipset Onboarding Processor|   
| LMS |  License Management System | 
| SMP | Service Management Portal |
|SQS|  Simple Queue Service|  
| C2C | Cloud to Cloud |
| AOP | Aspect Oriented Programming|
