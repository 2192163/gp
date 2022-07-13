<center>

# **Chipset Onboarding Processor Document** 

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


NOTE :: Remove all the information blocks after details are added for the section. 

### <a id="_Introduction"></a>1. Introduction 



Chipset Onboarding Processor (COP) is a processor which listens to chipset onboarding queue to which chipset provision message comes. It fetches nonce and application data from QWES and onboard chipset by sending request to SMP endpoint. The features of COP are listed below:

*	Incoming chipset provision message is validated first. It checks whether mandatory fields are present or not.
*	If validation fails it sends chipset onboarding response to device with corresponding error codes.
*	If validation is success, it iterates through each chipset and it stores the details in database if it’s a new message. If it's an existing message it checks whether it’s a duplicate or not and allows only messages which are not duplicate. 
*	Then it calls LMS C Api to get nonce and validates it.
*	It sends chipset nonce to device with nonce details and transaction id
*	If the chipset nonce response from device is valid, it calls LMS Api to get application data and validates it.
*	Now COP changes the chipset state to REG and onboard chipsets via SMP endpoint.
*	Finally, it sends chipset onboarding response to device with chipset id and other details
*	Major onboarding statuses are: “onboarding initiated” when we start processing of chipset, “nonce published” when we send chipset nonce to device and “onboarding completed” when we it successfully onboards chipset via SMP endpoint.



### <a id="_Scope"></a>1.1 Scope 

*	COP will listen to chipset onboarding queue, validates incoming chipsets and adds details to chipset onboarding tables. It sends a nonce to device with details and waits for response. Once response is received it call lms api for application data and onboard via SMP endpoint and finally send chipset onboarding response to device.
*	Chipset Provision message which fails validation (if chipset count or chipsets is blank, mismatch in count and number of chipset) are send back to device with message type chipset onboarding response with corresponding error codes.
*	If same message comes again, it’s checked for whether its duplicate or not. It’s done based on onboarding status. If onboarding status of same message coming again is
a.	ONBOARDING_INITIATED, it means onboarding is still in progress, so it’s considered as duplicate
b.	ONBOARDING_COMPLETED and chipset state is ACTIVE, it means chipset is already onboarded, so it’s considered as duplicate
c.	NONCE_PUBLISHED and its onboarding status time is with nonce timeout duration, again it’s considered as duplicate.
*	If api call to get nonce fails due to any validation failure error response with corresponding error code is send back to device. If failure is not due to validation failure, we will retry the message by forwarding it to retry processor.
*	While sending onboarding nonce or onboarding response to device if any error happens, we will retry the message by forwarding it to retry processor.
*	Transaction id in the nonce response coming back from device is not a valid one, we will log and discard the message.
*	If Api call to get application data which includes chipset id, program id and sku id fails due to any validation failure error response with corresponding error code is send back to device. If failure is not due to validation failure, we will retry the message by forwarding it to retry processor.
*	While onboarding chipset via SMP endpoint if it fails due to any validation failure error response with corresponding error code is send back to device. If failure is not due to validation failure, we will retry the message by forwarding it to retry processor.



### <a id="_OutofScope"></a>1.2 Out of Scope 

COP uses various modules for its working.

*	COP receives incoming chipset provision message from device provisioning processor and receives onboarding nonce response from device which contains attestation report.
*	COP also use LMSC api to get nonce and also additional data which includes chipset hash id and application data(program id and sku id).
*	COP also connects to SMP endpoint to onboard chipsets with the details required.
*	COP makes use of C2DSender to send onboarding response and nonce response to device.
*	COP also depends of cop time based retry processor for handling retry messages


### <a id="_Assumption"></a>1.3 Assumption 

* COP needs internal dependencies named c2c_base_queue_sqs_impl and c2c_base_common for its working.These wrappers must be running for COP to work
* COP depends on other software modules for its working.Modules like provisioning processor, c2dsender, smp, lms c api are essential for COP to complete its flow.

## <a id="_Design"></a>2. Design

##### ARCHITECTURE:

COP receives CHIPSET_PROVISION message from device provisioning processor. COP will listen to chipset onboarding queue, validates incoming chipsets and adds details to chipset onboarding tables. It sends a nonce to device with details and waits for response. Once response is received it call lmsc api for application data and onboard via SMP endpoint and finally send chipset onboarding response to device.
##### High level diagram
 <figure>
    <img src="../../../assets/cop_high_level_v0.1.png" width="700" />
		<figcaption>High Level Architecture Diagram</figcaption>
 </figure>

###### FLOWCHART:

 <figure>
	<img src="../../../assets/cop_flowdiagram_3.0.png" width="700" />
		<figcaption>FLOW CHART</figcaption>
 </figure>
		
*	Incoming chipset provision message is validated first. It checks whether mandatory fields are present or not.
*	If validation fails it sends chipset onboarding response to device with corresponding error codes.
*	Now it checks whether the incoming message is duplicate or not. If duplicate it sends corresponding error code to device
*	If its not duplicate, it iterates through each chipset and it stores the details in database if it’s a new message. If it's an existing message it checks whether it’s a duplicate or not and allows only messages which are not duplicate. 
*	Then it calls LMS C Api to get nonce and validates it.
*	It sends chipset nonce to device with nonce details and transaction id
*	If the chipset nonce response from device is valid, it calls LMS Api to get application data and validates it.
*	Now COP changes the chipset state to REG and onboard chipsets via SMP endpoint.
*	Finally, it sends chipset onboarding response to device with chipset id and other details
*	Major onboarding statuses are: “onboarding initiated” when we start processing of chipset, “nonce published” when we send chipset nonce to device and “onboarding completed” when we it successfully onboards chipset via SMP endpoint.
*	During api failures and queue writing failures corresponding action whether to retry or send error response to device is taken. Basic idea is if its a validation failure we donot retry, otherwise we retry.
		
###### SEQUENCE DIAGRAM:

 <figure>
	<img src="../../../assets/chipset_onboardingv2.png" width="700" />
		<figcaption>Low Level Sequence Diagram</figcaption>
 </figure>



### <a id="_ClassDiagram"></a>2.1 Class Diagram

|Sl No| Class | Functionality and Public Methods |  
| :------------- | :------------- | :------------ |
| 1| ChipsetOnboardingListener|	The class ChipsetOnboardingListener is to listen to chipset onboarding queue in which chipset provision and onboarding nonce response will come. It checks the message type forwards to corresponding processor classes .Also it has multiple catch blocks which captures retryable and non retryable exception scenarios.
|||Methods:	onMessageReceived: process messages from onboarding queue and checks the message type and forward to corresponding processor classes.|
| 2| ChipsetOnboardingProcessor|	The Class ChipsetOnboardingProcessor gets the provision message , validates it , stores copy in db ,gets nonce and send onboarding nonce to device. It also check for duplicate messages and handle scenarios if validation is failed
|||Methods:	process: process chipset provision message forwarded from listener class|
|3|	ChipsetNonceProcessor|	ChipsetNonceProcessor class gets onboarding nonce response class, validates transaction id, gets additional data , onboard chipset via calling SMP and finally sends onboarding response to device.
|||Methods : process: process onboarding nonce response message forwarded from listener class|
|4|	ChipsetOnboardingDriver|	Continuously receives data from the chipset onboarding queue and invokes the listener class.
|||Methods: init: To invoke the listener class
|5|	ChipsetOnboardingDatabaseService|	The Class ChipsetOnboardingDatabaseService perform various database operation by calling repositories for different tables.
|||Methods:	storeChipsetCount:store chipset count details in db, storeChipsets: stores chipset details in db, getChipsetDetails: fetches chipset details from db, updateChipsetOnboardingStatus: update onboarding status of chipset in db, checkTransactionId: checks whether transaction id is valid or not, getDeviceDetails: gets device details from db,	getVehicleDetails: gets vehicle details from db, addAdditionalData: add additional data to db, generateTransactionId: generates unique transaction id, updateChipsetState: update state of chipset, storeChipsetProvisionRequest: store a copy of incoming message, getRetryStandardInternalMessage: fetch the message which should be retried, updateOnboardingStatusAndErrorCode : update onboarding status along with error codes.
|6|	ChipsetAPIService	|This class performs various API operations by calling corresponding endpoints and returning responses.
|||Methods :	getNonce: gets nonce by calling lmsc api, onboardChipsets: onboard chipsets by sending request to SMP, getAdditionalData: gets additional data like chipset id, prog id, sku id from lmsc api
|7|	ChipsetQueueWriterService|	This class perform various operations related to sending responses via queues to different components.
|||Methods : onboardingResponseToDevice: send onboarding response to device, chipsetNonceToDevice: send onboarding nonce to device,onboardingResponseToDevice: same purpose but dedicatedly used to send error responses.
|8|	RetryQueueWriterService|	Specifically used to send retry messages to resilience processor
|||Methods: writeToRetryQueue: forward message to retry queue
|9|	C2CObjectBase64Util	|Util class for performing base64 encoding and decoding
|||1. convertObjectToBase64: Decodes base 64 to string, 2. convertBase64ToString: Decodes base 64 to string
|10|	ChipsetOnboardingUtils	|Util class to perform common operations used in project
|||1.	generateEcuType: converts tcu to telematics for smp,2.	enrichMessageWithErrorCode: Enriches message's propertybag with error code, 3.parseErrorCodeFromLMSCResponse: Parses the error code from LMS response,
|11|	ValidationUtils|	Performs validations done in the processor
|||1.	validateChipsetDetails: validates chipset details, 2.	validateApplicationData: validates additional data response, 3.	validateNonceResponse: validates nonce response.



 <figure>
	<img src="../../../assets/COP_Class_Diagram.png" width="700" />
				<figcaption>Class Diagram</figcaption>
 </figure>


### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA

## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

###### Maven Dependencies:

*	org.springframework.boot: spring-boot-starter-web
*	org.springframework.boot: spring-boot-devtools
*	org.springframework.boot: spring-boot-starter-data-jpay
*	org.projectlombok: Lombok
*	org.postgresql: postgresql
*	org.springframework.boot: spring-boot-starter-test
*	junit: junit
*	org.springframework.cloud: spring-cloud-starter-config
*	org.springframework.cloud: spring-cloud-starter- actuator
*	org.springframework.cloud: spring-cloud-starter-bootstrap
*	org.mockito: mockito-core
*	org.springframework.boot: spring-boot-maven-plugin
*	org.jacoco:jacoco-maven-plugin

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


 **t_chipset_count**
 
|Column Name |	Datatype 
| :------------- | :------------ |
deviceid|	String
system_id|	String
ecu_type|	String
chipset_count|	int
created_by|	String
created_time|	Long
updated_by|	String
updated_time|	Long

    


## <a id="_Applicationconfiguration"></a>5. Application configuration

*	aws.credentials.access-key:Encrypted access key for Amazon Web services
*	aws.credentials.secret-key:Encrypted secret key for Amazon Web services
*	aws.region=Region name to be accessed in Amazon Web services.Datatype is String
*	spring.datasource.url=database url along with database name
*	spring.datasource.username= database username
*	spring.datasource.password=database password
*	spring.jpa.show-sql=to show database entry logs in logs
*	spring.datasource.driver-class-name=postgres driver class name
*	chipset-onboarding-queue=The queue name to which COP listens.Datatype is String.The name of the queue is {env}_dm_sq_chipset_onboarding_queue
*	c2dsender-queue= The queue name to which C2DSender listens.Datatype is String.The name of the queue is {env}_cc_sq_c2d_inbound_queue
*	retry-queue=The queue name to which COP retry messages are send.Datatype is String.The name of the queue is {env}_resilience_sqs_chipsetonboardingpro
*	SMP-endpoint=API endpoint to onboard chipsets via smp endpoint. Datatype is String
*	nonce-endpoint=API endpoint to get nonce via lmsc api.Datatype is String
*	additional-data-endpoint=API endpoint to get additional data via lmsc api. Datatype is String
*	enable-platform-license-onboarding=Its flag used to decide whether to onboard using plaform license or not. If its true we go for plaform license else onboard using progskuid.Datatype is boolean
*	create_unique_chipset_id=Flag used to decide whether to reuse device or not , because we have only few devices and so it generates same hashid everytime, which is difficult for testing, so to create unique chipset id we depend on this flag for testing.Datatype is boolean
*	nonce_duration=Its nonce duration which is used to determine whether nonce is expired or not to check for duplicates. Datatype is Long
*	spring.application.name=Name of the spring application
*	lms-api-key=LMS C api key as header for authorization .Datatype is String
*	smp-lms-api-url=API endpoint of smp adaptor api which is to be passed to smp as part of partition info.Datatype is String
*	smp-lms-api-key=Encoded smp adaptor api key as header for authorization .Datatype is String
*	smp-lms-api-queue-name=The queue needed for SMP as part of partition info.Datatype is String.The name of the queue is {env}_lms_sq_smplms_queue


 
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
    

**NOTE** :: Acronyms and terms or concepts can be added in below section and it will be rendered as a tooltip in the document. 

| Acronym or term|   Definition |  
| :------------- | :------------ |
| C2DSender | Cloud to Device Sender |     
| COP |  Chipset Onboarding Processor|   
| LMS |  License Management System | 
| SMP | Service Management Portal |
| S3 | Simple Storage Service | 
|SQS|  Simple Queue Service|  
| C2C | Cloud to Cloud |
| AOP | Aspect Oriented Programming|
