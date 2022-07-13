<center>

# **License Management Processor Document** 

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



License Management Processor (LMS) is a processor which listens to smp-lms inbound queue to which SMP sends the Standard Internal Message. It fetches nonce from QWES and install or delete license by sending request to device. The features of LMS are listed below:

*	The incoming messages from SMP queue are validated first. If the mandatory fields are empty or null, LMS sets the error code and sends it back to SMP.
*	Based on the valid message’s transaction type field, the message will be processed either for Install or for delete.
*	If transaction type is Install, the data will be stored to license transaction table and the status will be set to REQUEST_RECIEVED.
*	LMSC will be invoked then for getting Nonce. After nonce validation it will be published to C2D sender queue with setting status as NONCE_PUBLISHED. Or if any exception occurs, message will be sent to resilience processor for retry mechanism.
*	LMS processor will be expecting an attestation report from the device end and it will be validated. Status will be set as ATTESTATION_RECIEVED this time.
*	Again, LMSC will be invoked for getting License and it will be published to C2D sender queue with status as LICENSE_PUBLISHED. Now LMS processor will waits for the response from Device end, and it will be validated so that the final result can be sent to SMP based on that.
*	After successful license install, chipset state will be set to ACTIVE and license update Api will be invoked.
*	If the transaction type is Delete, data will be stored in license transaction table and the status will be set to REQUEST_RECIEVED.
*	After publishing this delete request to C2D sender queue with status as DELETE_PUBLISHED, LMS processor will receive response back from device.
*	After verifying the response from device, LMS will report to SMP about the status of delete license.



### <a id="_Scope"></a>1.1 Scope 

*	LMS will listen to SMP-LMS inbound queue, validates incoming message and adds details to lms transaction table. It sends a nonce to device with details and waits for response. Once response is received it call lms api for license data and sends to device again.
*	Incoming satndard internal message which fails validation are send back to smp with corresponding error codes.
*	If same message comes again, it’s checked for whether its duplicate or not. It’s done based on status and the data avilable in the database. 
*	If api call to get nonce fails due to any validation failure error response with corresponding error code is send back to smp. If failure is not due to validation failure, we will retry the message by forwarding it to retry processor.
*	While sending onboarding nonce or license response to device if any error happens, we will retry the message by forwarding it to retry processor.
*	Transaction id in the nonce response coming back from device is not a valid one, we will log and discard the message.
*	If Api call to get license data fails due to any validation failure error response with corresponding error code is send back to smp. If failure is not due to validation failure, we will retry the message by forwarding it to retry processor.




### <a id="_OutofScope"></a>1.2 Out of Scope 

LMS uses various modules for its working.

*	LMS receives incoming license request message from SMP and receives chipset nonce response and chipset license resopnse from device which contains attestation report.
*	LMS also use LMSC api to get nonce and also License details which includes license certificate
*	LMS makes use of C2DSender to send nonce response and license response to device.
*	LMS also connects to SMP endpoint to update license status.
*	LMS also depends of lms time based retry processor and resillience processor for handling retry messages



### <a id="_Assumption"></a>1.3 Assumption 

* LMS needs internal dependencies named c2c_base_queue_sqs_impl and c2c_base_common for its working.These wrappers must be running for LMS to work
* LMS depends on other software modules for its working.Modules like c2dsender, smp, lms c api are essential for LMS to complete its flow.

## <a id="_Design"></a>2. Design

##### ARCHITECTURE:

LMS receives install license or delete license request message from SMP. LMS then validates incoming request and saves details to license transaction table. It sends a nonce to device with details and waits for response. Once response is received it call lmsc api for license details and update chipset state and smp via SMP endpoint.
##### High level diagram
 <figure>
    <img src="../../../assets/LMS_HighLevelDiagram.PNG" width="700" />
		<figcaption>High Level Architecture Diagram</figcaption>
 </figure>

###### FLOWCHART:

 ### LMS INSTALL LICENSE

<figure>
<img src="../../../assets/LMS_INSTALL_LICENSE_FLOW.png" width="800" />
<figcaption>Install License Flow Chart</figcaption>
</figure>

 ### LMS DELETE LICENSE

<figure>
<img src="../../../assets/LMS_DELETE_LICENSE_FLOW.png" width="800" />
<figcaption>Delete License Flow Chart</figcaption>
</figure>
		
*	The incoming messages from SMP queue are validated first. If the mandatory fields are empty or null, LMS sets the error code and sends it back to SMP
*	Based on the valid message’s transaction type field, the message will be processed either for Install or for delete
*	If transaction type is Install, the data will be stored to license transaction table and the status will be set to REQUEST_RECIEVED
*   License transaction table will be updated if the incoming message is already available and it is coming as part of retry mechanism
*	LMS-C will be invoked then for getting Nonce. After nonce validation it will be published to C2D sender queue with setting status as NONCE_PUBLISHED. Or if any exception occurs, message will be sent to resilience processor for retry mechanism. 
*   LMS processor will be expecting an attestation report from the device end and it will be validated. Status will be set as ATTESTATION_RECIEVED this time.
*	Again, LMSC will be invoked for getting License and it will be published to C2D sender queue with status as LICENSE_PUBLISHED. Now LMS processor will waits for the response from Device end, and it will be validated so that the final result can be sent to SMP based on that.
*	After successful license install, chipset state will be set to ACTIVE and license update Api will be invoked.
*	If the transaction type is Delete, data will be stored in license transaction table and the status will be set to REQUEST_RECIEVED
*	After publishing this delete request to C2D sender queue with status as DELETE_PUBLISHED, LMS processor will receive response back from device
*	After verifying the response from device, LMS will report to SMP about the status of delete license
*	During api failures and queue writing failures corresponding action whether to retry or send error response to device is taken. Basic idea is if its a validation failure we donot retry, otherwise we retry.
		
###### SEQUENCE DIAGRAM:

 <figure>
	<img src="../../../assets/LMSProcessorSequenceDiagram.png" width="700" />
		<figcaption>Low Level Sequence Diagram</figcaption>
 </figure>



### <a id="_ClassDiagram"></a>2.1 Class Diagram

|Sl No| Class | Functionality and Public Methods |  
| :------------- | :------------- | :------------ |
| 1| SmpRequestQueueListener|	Processes Standard internal message from the smp-lms queue and does the validation and calls the method for processing install license or delete license.
|||Methods:	onMessageReceived: Receive message from smp-lms queue, processInstallLicenseRequest: validates the install request and report to smp if there is any error, processDeleteLicenseRequest: validates the delete request and report to smp if there is any error, reportFailureToSMP: invoke SMP api to report errors in the message recieved|
| 2| LmsInboundQueueListener|	The Class LmsInboundQueueListener is to listen messages from device end and invoke methods based on messageType
|||Methods:	onMessageReceived: recieve messages from device queue and route to different methods,|
|3|	SmpRequestProcessor|	This class gets messages from SMPRequestQueueListner class and process it.
|||Methods : processSmpInstallLicenseRequest: save the data in data store and invoke getNonce API, processSmpDeleteLicenseRequest: save data in datastore and publish delete request to C2D sender queue|
|4|	DeviceResponseProcessor|	DeviceResponseProcessor receives data from LMSInboundQueListener Class and process itbased on nonce/install/ delete response
|||Methods: processNonceResponse: validate nonce response coming from device and invoke getLicense API . report back to smp if nonce received is invalid, processInstallLicenseResponse: validate the license response received from device and report error to smp if fails, processDeleteLicenseResponse: validate delete response from device and update datastore, validateDeleteResponse: validates delete response and adds error code property bag if validation fails, validateSMPDeleteRequest: validates the incoming smp delete request and adds error code to the message if validation fails, validateSMPInstallRequest: validates the incoming smp delete request and adds error code to the message if validation fails
|5|	LmsDatabaseService|	This class contains the methods that save or update datastore.
|||Methods:	saveTransaction:Method which saves data in lms_txn_state table, updateRetryTransactionState: update txn state in lms table while retry, getSourceTransactionDetails: fetches transaction details from db, updateTransactionState: update transaction status in db, updateHashedDeviceIdAndQwesLicenseId: update qwes licenseid and hashdevice id in db, saveTransactionForHistory: save transaction details in lms history table
|6|	LmsQueueWriterService	|For writing messages to given queues.
|||Methods :	writeToC2DSenderQueue: publishing messages to C2D sender queue	, writeToChipsetStateProcessorQueue: publishing messages to chipset state processor
|7|	RetryQueueWriterService|	This class writes messages to Retry queue.
|||Methods : writeToRetryQueue: publishing incoming messages to resilience queue for retry.
|8|	LmsCService|	The Class LmsCService is to call apis for retrieving data from QWES, updating chipset state and reporting to SMP.
|||Methods: getNonce: to retrieve the nonce from LMSC using Rest Template, getLicense: to retrieve the license data from LMSC using Rest Template, reportLicenseStatus:to report smp regarding the status of license installation, reportDeleteLicenseStatus: to report smp regarding the status of license deletion, updateChipsetState: to update the chipset state using Rest template, updateLicenseHistory: to update the license history using rest template
|9|	LmsValidationUtils|	TLmsValidationUtils is the class for validating the various request coming to LMS processor
|||Methods : validateNonceReponse: pvalidates nonce response and adds error code to the message if validation fails, validateLicenseResponse:validates license response and adds error code to the message if validation fails
|10| LmsMapper|	LMSMapper class maps various fields.
|||Methods: createInstallTransactionEntity: sets various fields in install request for lms transaction entity, createDeleteTransactionEntity: sets various fields in delete request for lms transaction entity


 <figure>
	<img src="../../../assets/LMSProcessorClassDiagram.png" width="700" />
				<figcaption>Class Diagram</figcaption>
 </figure>


### <a id="_StateDiagram"></a>2.2 State Diagram

###### INSTALL LICENSE STATE DIAGRAM
<figure>
<img src="../../../assets/LMS_statediagram_Install_License.png" width="700" />
<figcaption>Install State Diagram</figcaption>
</figure>

###### DELETE LICENSE STATE DIAGRAM

<figure>
<img src="../../../assets/LMS_statediagram_Delete_License.png" width="700" />
<figcaption>Delete License State Diagram</figcaption>
</figure>

### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA

## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

###### Maven Dependencies:

*	org.springframework.boot: spring-boot-starter-web
*	org.springwork.boot: spring-boot-starter-test
*	com.fasterxml.jackson.core: jackson-databind
*	javax: jaxb-api
*	junit : junit
*	org.junit.jupiter: junit-jupiter-api
*	org.junit.jupiter: junit-jupiter-engine
*	org.springframework.cloud: spring-cloud-starter-config
*	org.springframework.cloud: spring-cloud-starter-bootstrap
*	com.amazonaws: aws-java-sdk-sns
*	org.mockito: mockito-core
*	org.springframework.boot: spring-boot-maven-plugin
*	org.jacoco:jacoco-maven-plugin


###### Internal Dependencies:

*	com.c2c: c2c_base_common
*	com.c2c.queue.client: c2c_base_queue_sqs_impl





## <a id="_Databasedesign"></a>4. Database design

database : **c2c_device_registration_service_db (schema:lms)**

   **t_license_txn_status**
   
|Column Name |	Datatype 
| :------------- | :------------ |
lms_txn_id| 	Integer 
source_txn_id |	String 
txn_type |	String 
lms_txn_state |	String 
vin |	String 
ecu_type |	String 
ecu_id| 	Integer 
feature_list| 	String 
qwes_hashed_device_id| 	String 
delete_serials |	String 
qwes_license_id |	String 
sku_id |	Integer 
lms_txn_state_time |	Long 
smp_request_body |	String 
source_txn_ts |	Long 
error_code |	String 
chipset_id |	String 
created_by |	String 
created_time |	Long 
updated_by |	String 
updated_time |	Long 




    


## <a id="_Applicationconfiguration"></a>5. Application configuration

*	aws.credentials.access-key:Encrypted access key for Amazon Web services
*	aws.credentials.secret-key:Encrypted secret key for Amazon Web services
*	aws.region=Region name to be accessed in Amazon Web services.Datatype is String
*	spring.datasource.url=database url along with database name
*	spring.datasource.username= database username
*	spring.datasource.password=database password
*	spring.jpa.show-sql=to show database entry logs in logs
*	spring.datasource.driver-class-name=postgres driver class name
*	smp_lms_queue=The queue name to which LMS listens.Datatype is String.The name of the queue is {env}_lms_sq_smplms_queue
*   device_response_queue=The queue name to which LMS listens to device.Datatype is String.The name of the queue is {env}_lms_sq_receive_queue
*	c2dsender-queue= The queue name to which C2DSender listens.Datatype is String.The name of the queue is {env}_cc_sq_c2d_inbound_queue
*	state_processor_queue= The queue name to which LMS sends to state processor.Datatype is String.The name of the queue is {env}_dm_sq_device_data_update_queue
*	retry-queue=The queue name to which LMS retry messages are send.Datatype is String.The name of the queue is {env}_resilience_sqs_lmspro
*	smp-baseurl=API endpoint to onboard chipsets via smp endpoint. Datatype is String
*	smp-license-status-endpoint=API endpoint to update license status to SMP
*	smp-deletelicense-status=endpoint=API endpoint to update delete license status to SMP
*	nonce-endpoint=API endpoint to get nonce via lmsc api.Datatype is String
*	license-endpoint=API endpoint to get license via lmsc api.Datatype is String
*	update-license-endpoint=API endpoint to get update license history
*	get-chipset-endpoint=API endpoint to get chipsetDetails
*	update-state-endpoint=API endpoint to update chipset state to active
*	spring.application.name=Name of the spring application
*	lms-api-key=LMS C api key as header for authorization .Datatype is String


 
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
| LMS |  License Management System | 
| SMP | Service Management Portal | 
| SQS |  Simple Queue Service|  
| C2C | Cloud to Cloud |
