<center>

# **LMS Time Based Retry Processor Document** 

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



LMS Time Based Retry Processor is a scheduler processor which checks for transactions that must be retried or timeout as part of the retry flow of LMS. It is scheduled to trigger retry flow of LMS for every fixed interval and  retries transactions which are stuck at particular transaction state due to not receiving any response from the device for fixed number of times. It also sends report for all timeout transactions and other failed transactions to SMP. The features of LMS Time Based Retry Processor are listed below:

*   The LMS Time Based Retry Processor is scheduled to trigger the retry flow every fixed interval. 
*   It retries the same message for fixed number of times. 
*   It fetches all records from ‘t_license_txn_status’ table and process only the latest transaction for each chipset. Rest of the old transactions are direclty reported to SMP as TIMEOUT transactions.
*   Latest transactions having states like ‘NONCE_PUBLISHED’, LICENSE_PUBLISHED’ and ‘DELETE PUBLISHED’ satisfying the retry condition (diffrenece between current time and transaction state time > threshold value)  are retried by publishing the StandardInternalMessage of that particular record  resilience processor queue.
*   The transaction states are updated to ‘currentState_RETRY’ after publishing the message to queue for retrying. 
*   Latest transactions having states ending with ‘_RETRY’ satisfying the timeout condition(diffrenece between current time and created time > threshold value) are reported to SMP as timeout transactions with corresponding error code. The transaction states are then updated to states ending with ‘_TIMEOUT’ instead of ‘_RETRY’.
*   Records having 'REPORTING_TRANSACTION_ERROR' and 'REPORTING_TRANSACTION_ERROR_FAILURE' within reportingThreshold value are retried either by invoking api call to SMP or publishing the status to sku response processor queue based on isReportToSkuResponseProcessorEnabled flag. The transaction state is updated to SUCCESS if the retry is success for transaction with 'REPORTING_TRANSACTION_ERROR' state . 
* Transactions other than latest ones are directly reported to SMP and updated in table as TIMEOUT transactions with corresponding error codes.
*  For each update on 't_license_txn_status' table, corresponding entry is made on 't_license_txn_status_history' tablebased on SaveToHistoryTableFlag flag.



### <a id="_Scope"></a>1.1 Scope 

*	The LMS Time Based Retry Processor retries a particular message for fixed number of times. 
*	It is scheduled to trigger retry flow for every fixed interval. 
*	The retrying of LMS transactions is done by publishing the StandardInternalMessage of that particular transaction to resilience processor queue. This publishing to queue module is designed to process as a separate thread. 
*	Only the latest transactions are processed. Rest is timeout transactions. Latest transactions having states like ‘NONCE_PUBLISHED’, LICENSE_PUBLISHED’ and ‘DELETE PUBLISHED’ satisfying the retry condition (diffrenece between current time and transaction state time > threshold value)  are retried by publishing the StandardInternalMessage of that particular record  resilience processor queue.
*	For the retried transactions, the transaction states are updated to ‘currentState_RETRY’ after publishing the message to queue for retrying. For the timeout transactions, the transaction states are updated to ‘currentState _TIMEOUT’. 
*	If the retried transactions are stuck for more than timeoutThreshold, then transaction is reported to SMP and the transaction states are then updated from states ending with ‘_RETRY’ to ‘_TIMEOUT’.  





### <a id="_OutofScope"></a>1.2 Out of Scope 

LMS Time Based Retry Processor uses various modules for its working.

*	The LMS Time Based Retry Processor has a scheduler module which is scheduled to trigger processing part every fixed interval. 
*	The retrying of LMS transactions is done by publishing the StandardInternalMessage of that particular transaction to resilience processor queue. This publishing to queue module is designed to process as a separate thread. 
*	It publishes install/ delete status request to sku response processor queue for retrying transactions with 'REPORTING_TRANSACTION_ERROR' OR 'REPORTING_TRANSACTION_ERROR_FAILURE'.
*	The LMS Time Based Retry Processor also connects to SMP endpoint to report failure or timeout transactions.


### <a id="_Assumption"></a>1.3 Assumption 

* LMS Time Based Retry Processor needs internal dependencies named c2c_base_queue_sqs_impl and c2c_base_common for its working.These wrappers must be running for LMS Time Based Retry Processor to work
* LMS Time Based Retry Processor depends on other software modules for its working.Modules like  smp, lms  are essential for LMS Time Based Retry Processor to complete its flow.

## <a id="_Design"></a>2. Design

##### ARCHITECTURE:

LMS Time Based Retry Processor is a scheduler processor which checks for transactions that must be retried or timeout as part of the retry flow of LMS. It fetches all records from ‘t_license_txn_status’ table and groups transactions based on chipset. Only the latest transaction for each chipset is processed rest are direclty reported to SMP as TIMEOUT transactions. Latest transactions having states like ‘NONCE_PUBLISHED’, LICENSE_PUBLISHED’ and ‘DELETE PUBLISHED’ satisfying the retry condition (diffrenece between current time and transaction state time > threshold value) are retried by publishing the StandardInternalMessage of that particular record to resilience processor queue, which then retries it for a fixed number of times.  For the retried transactions, the transaction states are updated to ‘currentState_RETRY’ after publishing the message to queue. Latest transactions having states ending with ‘_RETRY’ satisfying the timeout condition(diffrenece between current time and created time > threshold value) are reported to SMP as timeout transactions with corresponding error code. The transaction states are then updated to ‘currentState_TIMEOUT’.

Latest transactions having ‘REPORTING_TRANSACTION_ERROR’ and ‘REPORTING_TRANSACTION_ERROR_FAILURE’ within reportingThreshold value are retried either by invoking api call to SMP or publishing the status to sku response processor queue based on isReportToSkuResponseProcessorEnabled flag. The transaction state is updated to SUCCESS if the retry is success for transaction with ‘REPORTING_TRANSACTION_ERROR’ state .
Transactions other than latest ones are directly reported to SMP and updated in table as TIMEOUT transactions with corresponding error codes. For each update on 't_license_txn_status' table, corresponding entry is made on 't_license_txn_status_history' tablebased on SaveToHistoryTableFlag flag.

##### High level diagram
 <figure>
    <img src="../../../assets/LMS_Retry_HighLevelDiagram.png" width="700" />
		<figcaption>High Level Architecture Diagram</figcaption>
 </figure>

###### FLOWCHART:

 <figure>
	<img src="../../../assets/LMS_RETRY Processor_Flowchart1.png" width="800" />
 </figure>
  <figure>
	<img src="../../../assets/LMS_RETRY Processor_Flowchart2.png" width="800" />
		<figcaption>FLOW CHART</figcaption>
 </figure>
*	 The scheduler module of LMS Time Based Retry Processor is scheduled to trigger processing part for every fixed interval. 
*	The retrying of LMS transactions is done by publishing the StandardInternalMessage of that particular transaction to resilience processor queue. This publishing to queue module is designed to process as a separate thread.
* Latest transactions having states like ‘NONCE_PUBLISHED’, LICENSE_PUBLISHED’ and ‘DELETE PUBLISHED’ satisfying the retry condition (diffrenece between current time and transaction state time > threshold value) are retried by publishing the StandardInternalMessage of that particular record resilience processor queue.
For the retried transactions, the transaction states are updated to ‘currentState_RETRY’ after publishing the message to queue for retrying. For the timeout transactions, the transaction states are updated to ‘currentState _TIMEOUT’.
If the retried transactions are stuck for more than timeoutThreshold, then transaction is reported to SMP and the transaction states are then updated from states ending with ‘_RETRY’ to ‘_TIMEOUT’.

		
###### SEQUENCE DIAGRAM:

 <figure>
	<img src="../../../assets/LMS_Retry_Processor_SequenceDiagram.png" width="700" />
		<figcaption>Low Level Sequence Diagram</figcaption>
 </figure>



### <a id="_ClassDiagram"></a>2.1 Class Diagram

|Sl No| Class | Functionality and Public Methods |  
| :------------- | :------------- | :------------ |
| 1| LMSRetryProcessor |	The Class LMSRetryProcessor retrieves records which satisfies conditions for retrying and timeout separately from t_license_txn_status table and invokes method to send for retry or send report to SMP if its timeout correspondingly. 
|||Methods:	process: process retrieved transactions to be retried and reported to SMP.|
| 2| LmsRetryQueueWriterService |	The Class LmsRetryQueueWriterService is a service class to publish Standard Internal Message to the resilience processor queue for retry as a separate thread. 
|||Methods:	writeToResilienceQueue: publishes the StandardInternalMessage to the queue.|
|3|	LMSRetryService |	The Class LMSRetryService is the service class used to process transactions to be retried and timeout transactions separately. It sends messages which must be retried to the resilience processor queue, invokes api to send reports to SMP for timeout transactions and invokes methods to update records in t_license_txn_status table with corresponding transaction state. 
|||Methods : processTransactions(): This method is used for iterating over the transactions for each chipsetId and sending latest messages to be retried to the queue and reporting expired messages to SMP, processTimeoutTransactions():retrieves transactions having states ending with 'RETRY' from t_license_txn_status table and invokes method to send report to SMP for timeout messages, processForMultipleLicense():reports expired messages to SMP and invokes processSingleLicense method for sending only latest messages to be retried to the resilience processor queue, sendForRetry():sendForRetry method submits tasks to Message Publisher Executor which  invokes writeToResilienceQueue method for sending messages to be retried to the resilience processor queue and update the lms_txn_status table with the transaction state and updated time, reportToSMP(): reports timeout transactions to SMP by invoking api and updates the transaction states to TIMEOUT, processReportingTransactions(): method to retry reporting transaction error records.|
|4|	LMSRetryDatabaseService |	The Class LMSRetryDatabaseService used to perform database operation logics. It connects to different repositories and performs insertion and retrieval of data.
|||Methods: getNonceTransactions(): Gets all the t_license_txn_status details based on transaction state=NONCE_PUBLISHED, getPublishedTransactions(): Gets all the t_license_txn_status details based on transaction state=LICENSE_PUBLISHED/DELETE_PUBLISHED, getTimeoutTransactions():  Gets all the timeout from t_license_txn_status details based on transaction state ending with _RETRY, updateLicenseTransaction(): Updates the t_license_txn_status details, getReportingTransactions(): Gets all the t_license_txn_status details based on transaction state=REPORTING_TRANSACTION_ERROR, updateTransactionState(): method for updating the transaction state of the license in the license transaction table.
|5|	LMSApiService |	The Class LMSApiService is a service class used to call SMP endpoints. It connects to the endpoint provided and perform GET, POST etc. operations. 
|||Methods:	reportLicenseStatus():Created for calling the SMP install license url. It sends the status of the license back to SMP, reportDeleteLicenseStatus(): Created for calling the delete License url to report back to SMP.
|6|	LMSRetryJob 	|The Class LMSRetryJob is the class which implements Job for scheduling the process every fixed interval. 
|||Methods :	getNonce: gets nonce by calling lmsc api, onboardChipsets: onboard chipsets by sending request to SMP, getAdditionalData: gets additional data like chipset id, prog id, sku id from lmsc api
|7|	MessagePublisherThread |	The Class MessagePublisherThread class which implements publishing of retry messages to the queue as a thread.
|||Methods : run(): initiates publishing of retry messages to the queue as a thread.



 <figure>
	<img src="../../../assets/lms_retry_processor_class_diagram.png" width="700" />
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
*	org.springframework:spring-context-support 
*	junit : junit 
*	org.springframework.cloud: spring-cloud-starter-config
*	org.springframework.cloud: spring-cloud-starter-bootstrap 
*	org.mockito: mockito-core 
*	org.jacoco:jacoco-maven-plugin 
*	org.projectlombok:lombok 
*	org.postgresql: postgresql 
*	org.quartz-scheduler:quartz 
*	log4j:log4j 
*	com.googlecode.json-simple: json-simple 

###### Internal Dependencies:

*	com.c2c: c2c_base_common
*	com.c2c.queue.client: c2c_base_queue_sqs_impl





## <a id="_Databasedesign"></a>4. Database design



database : **c2c_lms_db (schema:lms)**

   **t_license_txn_status**
   
|Column Name |	Datatype 
| :------------- | :------------ |
lms_txn_id  |	String 
txn_type |	String 
source_txn_id  |	String 
lms_txn_state |	String 
vin |	String 
ecu_id|  Integer 
chipset_id | Integer
ecu_type| String
feature_list|  String
qwes_hashed_device_id| 	String 
delete_serials |	String 
qwes_license_id |	String 
sku_id |	Integer 
lms_txn_state_time |	Integer 
smp_request_body |	String 
source_txn_ts |	Integer 
error_code |	String 
created_by |	String 
created_time |	Long 
updated_by |	String 
updated_time |	Long 
serial_num | String


database : **c2c_lms_db (schema:lms)**

   **t_license_txn_status_history**
   
|Column Name |	Datatype 
| :------------- | :------------ |
id | Integer
lms_txn_id  |	String 
txn_type |	String 
source_txn_id  |	String 
lms_txn_state |	String 
vin |	String 
ecu_id|  Integer 
ecu_type| String
sku_id |	Integer 
lms_txn_state_time |	Integer 
source_txn_ts |	Integer 
error_code |	String 
created_by |	String 
created_time |	Long 


## <a id="_Applicationconfiguration"></a>5. Application configuration

*	aws.credentials.access-key:Encrypted access key for Amazon Web services
*	aws.credentials.secret-key:Encrypted secret key for Amazon Web services
*	aws.region=Region name to be accessed in Amazon Web services.Datatype is String
*	spring.datasource.url=database url along with database name
*	spring.datasource.username= database username
*	spring.datasource.password=database password
*	spring.jpa.show-sql=to show database entry logs in logs
*	spring.datasource.driver-class-name=postgres driver class name
*   lms_retry_queue=The queue name to which LMS Retry Processor publishes messages to be retried. Datatype is String.The name of the queue is {env}_resilience_sqs_lmspro
*   sku_processor_queue= The queue name to which LMS Retry Processor publishes install/delete license status to report to SMP. Datatype is String.The name of the queue is {env}_sku_sqs_response_pro
*	smp_license_status_endpoint=API endpoint to report license install status  to smp . Datatype is String
*	smp_delete_license_status_endpoint=API endpoint to report delete license status to smp.Datatype is String
*	nonce-threshold-value=Its nonce duration which is used to determine whether NONCE_PUBLISHED record needs to be retried or not. Datatype is Long
*	license-threshold-value=Its license duration which is used to determine whether LICENSE_PUBLISHED or DELETE_PUBLISHED records needs to be retried or not. Datatype is Long
*	timeout-threshold-value=Its TIMEOUT duration which is used to determine whether transactions are expired or not. Datatype is Long
*	reporting-threshold-value=Its reporting transaction error duration which is used to determine whether REPORTING_TRANSACTION_ERROR or REPORTING_TRANSACTION_ERROR_FAILURE records needs to be retried or not. Datatype is Long
*	SaveToHistoryTableFlag= Flag which determines whether update made on 't_license_txn_status' table needs to be added in 't_license_txn_status_history' table. Datatype is Boolean
*	ReportToSkuResponseProcessor= Flag which determines whether reporting to SMP should be done by invoking SMP api or by publishing to sku response processor queue. Datatype is Boolean	
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

*	Usage of try catch blocks in important methods so that the processor will not get terminated even if one method fails. Exceptions are caught and logged properly.

List of all platforms wide error codes and their respective description are listed in the link below. Based on the error code, a consumer can take an action based on the severity of the error.




## <a id="_Howto"></a>7. How to

NA
    

**NOTE** :: Acronyms and terms or concepts can be added in below section and it will be rendered as a tooltip in the document. 

| Acronym or term|   Definition |  
| :------------- | :------------ |
| LMS |  License Management System | 
| SMP | Service Management Portal |
|SQS|  Simple Queue Service|  

