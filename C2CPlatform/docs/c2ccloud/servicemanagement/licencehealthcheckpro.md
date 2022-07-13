<center>

# **License Health Check Processor Document** 

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



License Health Check Processor is a project which was developed as part of license validation.  It listens to license health check queue to which the device sends the LICENSE_HEALTH_CHECK messages. It then validates and compares the features of licenses send by the device with that of the license features from SMP and populates the health check details to license_health_check_log table in SMP database. The features of License Health Check Processor are listed below 

*   License_health_check_processor process only messages of type “LICENSE_HEALTH_CHECK” with base64 encoded body. The incoming messages are validated first. If the encoding type and message type are not the same as required one, the message is not processed. 
*   It invokes chipset API to retrieve chipset_id from t_chipset_onboarding table based on device_id and chipset_name. If the chipset_id retrieved is null/empty, the health_check status in license_health_check_log table is set to ‘CHIPSET_NOT_ONBOARDED’ 
*   It queries vin_license table in SMP database for license details based on chipset_id and vin. If there are no records in vin_license for the specified vin and chipsetId, the health_check status in license_health_check_log table is set to ‘NO_LICENSE_IN_SMP’. Otherwise combine all the featureIds from the retrieved license records. 
*   After validating the license_list in LICENSE_HEALTH_CHECK message body, health_check status in license_health_check_log table is set to ‘NO_LICENSE_IN_CHIPSET’ if empty.  
*   Compares the feature_id list in the message from Device with that of the licenses retrieved from SMP if the serialNumbers are matching. The health_check status is set to ‘MATCH’ if the features are matching. Otherwise, it is set to ‘MISMATCH. If none of the serialNumbers matches, then it sets the health_check status in license_health_check_log table to ‘SERIAL_NUM_MISMATCH’. 
*   After validating, it stores license details to license_health_check_log table with corresponding health_check status. 



### <a id="_Scope"></a>1.1 Scope 

*	When the type of message is not “LICENSE_HEALTH_CHECK”, license health check processor logs the error as invalid message type, and the message is not processed.  
*	If the encoding type is not base64, the message is not processed, and processor logs the error as invalid encoding type. 
*	When the chipset_id retrieved by invoking chipset API is null/empty, the health_check status in license_health_check_log table is set to ‘CHIPSET_NOT_ONBOARDED’ 
*	When there are no records in vin_license for the specified vin and chipsetId after querying vin_license table, the health_check status in license_health_check_log table is set to ‘NO_LICENSE_IN_SMP’. Otherwise combine all the featureIds from the retrieved license records. 
*	After validating the license_list in LICENSE_HEALTH_CHECK message body, health_check status in license_health_check_log table is set to ‘NO_LICENSE_IN_CHIPSET’ if empty.  
*	On comparing the feature_id list in the message from Device with that of the licenses retrieved from SMP if the serialNumbers are matching, the health_check status is set to ‘MATCH’ if the features are matching. Otherwise, it is set to ‘MISMATCH. If none of the serialNumbers matches, then it sets the health_check status in license_health_check_log table to ‘SERIAL_NUM_MISMATCH’. 
*	After validating, license details are stored onto license_health_check_log table with corresponding health_check status.   





### <a id="_OutofScope"></a>1.2 Out of Scope 

LMS Time Based Retry Processor uses various modules for its working.

*	License Health Check Processor uses various modules for its working.  
*	The License Health Check Processor listens to license health check queue for processing only LICENSE_HEALTH_CHECK messages from the Device. 
*	It invokes chipset API call to get chipsetId based on deviceId and chipset_name from the incoming message and invokes method in service layer to validate and compare features. If the chipsetId received is empty, then set the health_check status in license_health_check_log table to ‘CHIPSET_NOT_ONBOARDED’. 
*	Based on the chipsetId received as part of api call and vin from LICENSE_HEALTH_CHECK message, license health check service class retrieves license records from vin_license table in SMP database. 
*	If there are no records in vin_license for the specified vin and chipsetId, the health_check status in license_health_check_log table is set to ‘NO_LICENSE_IN_SMP’. Otherwise combine all the featureIds from the retrieved license records. 
*	If the license_list in LICENSE_HEALTH_CHECK message body is empty, then set the health_check status in license_health_check_log table to ‘NO_LICENSE_IN_CHIPSET’. Otherwise compare the featured list in the message from Device with that of the licenses retrieved from SMP if the serialNumbers are matching. 
*	If the featureId list is matching, then then set the health_check status in license_health_check_log table to ‘MATCH’. Otherwise set the health_check status in license_health_check_log table to ‘MISMATCH.  
*	If none of the serialNumber matches, then set the health_check status in license_health_check_log table to ‘SERIAL_NUM_MISMATCH’. 
*	3)  LicenseHealthCheck entity is then stored on to license_health_check_log table with license health check details.           


### <a id="_Assumption"></a>1.3 Assumption 

* License Health Check Processor needs internal dependencies named c2c_base_queue_sqs_impl and c2c_base_common for its working.These wrappers must be running for License Health Check Processor to work.

## <a id="_Design"></a>2. Design

##### ARCHITECTURE:

License Health Check Processor is developed as part of license validation. It listens to license health check queue and processes messages of the type - LICENSE_HEALTH_CHECK. Invokes chipset api to get Chipset_Id from t_chipset_onboarding table based on device_id and name. Queries vin_license table in SMP database for license details based on Chipset_Id and vin. After validating and comparing features, it stores license details to license_health_check_log table with corresponding health_check status.  
##### High level diagram
 <figure>
    <img src="../../../assets/license_health_check_architechtural_diagram.png" width="700" />
		<figcaption>High Level Architecture Diagram</figcaption>
 </figure>

###### FLOWCHART:

 <figure>
	<img src="../../../assets/licensehealthcheckflowchart.png" width="700" />
		<figcaption>FLOW CHART</figcaption>
 </figure>

*	License_health_check_processor process only messages of type “LICENSE_HEALTH_CHECK” with base64 encoded body. The incoming messages are validated first. If the encoding type and message type are not the same as required one, the message is not processed. 
*	It invokes chipset API to retrieve chipset_id from t_chipset_onboarding table based on device_id and chipset_name. If the chipset_id retrieved is null/empty, the health_check status in license_health_check_log table is set to ‘CHIPSET_NOT_ONBOARDED’ 
*	It queries vin_license table in SMP database for license details based on chipset_id and vin. If there are no records in vin_license for the specified vin and chipsetId, the health_check status in license_health_check_log table is set to ‘NO_LICENSE_IN_SMP’. Otherwise combine all the featureIds from the retrieved license records. 
*	After validating the license_list in LICENSE_HEALTH_CHECK message body, health_check status in license_health_check_log table is set to ‘NO_LICENSE_IN_CHIPSET’ if empty.  
*	Compares the feature_id list in the message from Device with that of the licenses retrieved from SMP if the serialNumbers are matching. The health_check status is set to ‘MATCH’ if the features are matching. Otherwise, it is set to ‘MISMATCH. If none of the serialNumbers matches, then it sets the health_check status in license_health_check_log table to ‘SERIAL_NUM_MISMATCH’. 
*	After validating, it stores license details to license_health_check_log table with corresponding health_check status. 

### List of validations

*	Message Type Validations
*	Body Encoding Type Validation 
*	Platform Type validations

If the validation fails then the invalid messages are moved to S3 bucket - c2c-cts-usw1-dev-reg-license-health-check-message-store

###### SEQUENCE DIAGRAM:

 <figure>
	<img src="../../../assets/license_health_check_sequence_diagram.png" width="700" />
		<figcaption>Low Level Sequence Diagram</figcaption>
 </figure>



### <a id="_ClassDiagram"></a>2.1 Class Diagram

|Sl No| Class | Functionality and Public Methods |  
| :------------- | :------------- | :------------ |
| 1| LicenseHealthCheckProcessor  |	The Class LicenseHealthCheckProcessor Processes LICENSE_HEALTH_CHECK messages passed from listener and performs operations like calling chipset API service to get ChipsetId, retrieves license records from vin_license table and compares features for each license in license_list of incoming license health check messages. . 
|||Methods:	process: verifies license-details by checking for required fields in LICENSE_HEALTH_CHECK message, invokes chipset API service to get unique chipsetId, invokes validateLicense() to validate, compare and store license features in table.|
| 2| LicenseHealthCheckListener  |	The Class LicenseHealthCheckListener is to listen messages from license health check queue and forwards messages of type LICENSE_HEALTH_CHECK to license health check processor class.  
|||Methods:	onMessageReceived: Incoming messages are received from license health check queue and forwards messages of type LICENSE_HEALTH_CHECK to license health check processor class..|
|3|	LicenseHealthCheckService  |	The Class LicenseHealthCheckService is the service class used to check for all the different validation status scenarios. It has methods to compares features from device and SMP and populates license_health_check_log table. 
|||Methods : verifyLicense ():to check all the license_health_check_status scenarios and invoke method to compare features and store data to license_health_check_log table, verifylicenseFeatures(): verifies all the scenarios and invokes method to compare features and populate license_health_check_log table, compareLicenseFeatures(): Method to iterate through each license in license_list, compare featureIds of chipset with that of smp, stores license_health_check_log data to license_health_check_log table and returns the count of licenses with non-matching serialNum. |
|4|	LicenseHealthCheckDatabaseService  |	The Class LicenseHealthCheckDatabaseService is used to perform database operation logics. It connects to different repositories and performs insertion and retrieval of data .
|||Methods:  storeLicenseHealthCheckLog (): To save LicenseHealthCheckLog entity to license_health_check_log table, getVinLicenseByChipsetIdandVin():Toget vin_license details based on chipsetId and vin 
|5|	ChipsetAPIService  |	The Class ChipsetAPIService is a service class used to call chipset API endpoint. It connects to the endpoint provided and perform GET, POST etc. operations. 
|||Methods:	 getChipsetId: To call chipsetAPI url with deviceId and chipsetName as arguments to get chipsetId in return.




 <figure>
	<img src="../../../assets/license_health_check_class_diagram.PNG" width="700" />
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
*	mysql:mysql-connector-java 
*	junit : junit 
*	org.springframework.cloud: spring-cloud-starter-config
*	org.springframework.cloud: spring-cloud-starter-bootstrap 
*	org.mockito: mockito-core 
*	org.jacoco:jacoco-maven-plugin 
*	org.projectlombok:lombok 

###### Internal Dependencies:

*	com.c2c: c2c_base_common
*	com.c2c.queue.client: c2c_base_queue_sqs_impl





## <a id="_Databasedesign"></a>4. Database design



database : ** statmanq-auto-ccm-1.4.1 (schema:public)**

   **license_health_check_log**

|Column Name |	Datatype 
| :------------- | :------------ |
id  |	int |
system_id |	varchar(100) |
vin |	varchar(17) |
device_id  |	varchar(100) |
chipset_id |	varchar(100) |
serial_num|  varchar(100)|
device_features| varchar(250) |
smp_features |	varchar(250) |
license_health_check_body |	varchar(2000) |
license_health_check_status |	varchar(100) |
license_health_check_time |	bigint |
created_time |	bigint |
created_by |	varchar(100) |

   **Discrepancy Identification Rules **

|Discrepancy rule |	Status 
| :------------- | :------------ |
chipset_id not found for device_id and source id  |	CHIPSET_NOT_ONBOARDED |
No data found in vin_license table for vin and chipset_id |	NO_LICENSE_IN_SMP |
No license in the license health check message received from device |	NO_LICENSE_IN_CHIPSET |
Serial_num of license health check message not matching with the license_id of  vin license table  |	SERIAL_NUM_MISMATCH |
feature list of device not matching with feature lis of smp |	MISMATCH |
feature list of device matches with feature lis of smp|  MATCH|

For field violations like message_type mismatch body encoding missing and platform type not present inside body the message is added to the INVALID folder in the s3 bucket - c2c-cts-usw1-dev-reg-license-health-check-message-store
 
"Message Structure"

```json
   {
	"message_id": "MSG-TEST-1",
	"correlation_id": "COR-ID-35461",
	"version": "v1",
	"system_id": "sys55f6c9ac1d3d11ec9fbf",
	"sub_system_id": "c2c-sub-uniqueid",
	"vin": "sim_1632490662812",
	"device_id": "sim_4wuo93bsjtto0so16ob",
	"ecu_type": "tcu",
	"source_id": "mdm_1",
	"target_id": "c2c-cloud",
	"message_type": "LICENSE_HEALTH_CHECK",
	"time": 1620891851,
	"ttl": -1,
	"status": "SUBMIT",
	"property_bag": {
		"body_encoding_type": 1
	},
	"body": "{
       "msg_type": 12,                    
       "license_list": [
                          {
                            "serial_num" : "tgjj",
                            "feature_id_list":[896,898,805,806,811],                
                            "license_expiry":["start_date","end_date"],
                            "type":"platform",
                            "meta":[
									{
										"mismatch_codes": 100,
										"rectification_codes": 100
									}
									]
                          },
                          {
                            "serial_num" : "88281381743021050375132231140978770203",
                            "feature_id_list":[1400],                
                            "license_expiry":["start_date","end_date"],
                            "type":"device",
                            "meta":[
									{
										"mismatch_codes": 101,
										"rectification_codes": 102
										}
										]
                          } 
                   ],
		"trans_id" : -1
	    }",
		"trace_id": "a20ebb9ca87179f8",
		"span_id": "a20ebb9ca87179f8"
	}
```
"Message Report Structure"

   ```json
   {
	"systemId": "sys55f6c9ac1d3d11ec9fbf",
	"vin": "SIMV1634204959174",
	"deviceId": "simD_KW43ESHY0m5RZp",
	"chipsetId": "33026682",
	"serialNum": "zgobEyck6Uey",
	"deviceFeatures": "805,806,811,896,898",
	"smpFeatures": "805,806",
	"licenseHealthCheckBody": {
		"msg_type": 12,
		"license_list": [
			{
				"serial_num": "zgobEyck6Uey",
				"feature_id_list": [
					896,
					898,
					805,
					806,
					811
				],
				"license_expiry": [
					"start_date",
					"end_date"
				],
				"type": "platform",
				"meta": [
					{
						"mismatch_codes": 100,
						"rectification_codes": 100
					}
				]
			},
			{
				"serial_num": "88281381743021050375132231140978770203",
				"feature_id_list": [
					1400
				],
				"license_expiry": [
					"start_date",
					"end_date"
				],
				"type": "device",
				"meta": [
					{
						"mismatch_codes": 101,
						"rectification_codes": 102
					}
				]
			}
		],
		"trans_id": -1
	},
	"licenseHealthCheckStatus": "MISMATCH",
	"licenseHealthCheckTime": 1648565077743,
	"createdTime": 1648565077743,
	"createdBy": "LICENSE_HEALTH_CHECK_PROCESSOR"
   }
   ```
 

 **S3 Bucket Name** : c2c-cts-usw1-dev-reg-license-health-check-message-store

 **sns topic **: c2c_usw1_dev_reg_lms_sns_audit_report



## <a id="_Applicationconfiguration"></a>5. Application configuration

*	aws.credentials.access-key:Encrypted access key for Amazon Web services
*	aws.credentials.secret-key:Encrypted secret key for Amazon Web services
*	aws.region=Region name to be accessed in Amazon Web services.Datatype is String
*	spring.datasource.url=database url along with database name
*	spring.datasource.username= database username
*	spring.datasource.password=database password
*	spring.jpa.show-sql=to show database entry logs in logs
*   license-health-check-queue=The queue name to which License health check processor listens for LICENSE_HEALTH_CHECK messages. Datatype is String.The name of the queue is {env}_lms_sq_license_health_check_queue
*	chipset-endpoint-url=API endpoint to get onboarded chipset details . Datatype is String
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





## <a id="_Howto"></a>7. How to

NA
    

**NOTE** :: Acronyms and terms or concepts can be added in below section and it will be rendered as a tooltip in the document. 

| Acronym or term|   Definition |  
| :------------- | :------------ |
| SMP | Service Management Portal |

