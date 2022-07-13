     
# Error Code Dictionary
List of all platfrom wide error codes and its respective description. Every components or satellite applications are provided with a set of defined range to be used for error and validation purposes.

Based on the error code, a consumer can take an action based on the severity of the error.

## System Level

### API Application
All APIs need to have below HTTP codes supported and if required implemented. Refer <https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html>

| Code | Error | Description |  
|:------:|:-------|:-------------|  
| 200 | OK | OK/Success Message |  
| 202 | Accepted | For Asynchronous operations. Request is accepted for processing. Processing will take time and will be validated. |
| 204 | No content | No Content Available |  
| 400 | Bad Request | Server cannot process the request due to something that is perceived to be a client error. API failed to process the received request. <br /> Return this HTTP Code and add Response object containing application specific error / validation code. |   
| 401 | Unauthorized | If the systemid associated with the publisher of the message is not authorized. |  
| 403 | Forbidden | If the message was received on a forbidden topic. IGNORE Currently|
| 404 | Not Found | If the message was sent to an unknown topic. IGNORE Currently|
| 408 | Request Timeout | If the timeout git commit is set and logic warrants, and a timeout event occurs. |
| 409 | Version Conflict | Request could not be completed due to a conflict with the current state of the resource. E.g. Version mismatch |
| 413 | Payload too large | If the message size exceeds a defined threshold (a threshold is required to protect against sending malicious messages.) |
| 500 | Internal Server Error | If error occured / encountered processing a message.|
| 501 | Not Implemented | If the configured endpoint value is not correct and a message cannot be read / published. |
| 503 | Service Unavailable | If the configured endpoint service is unavailable for receiving / transmitting the messages.  |


### Common for Platform Application 

These error codes are common to platform backend components. Platform reserved error code Range is 1000 to 9999.
   
| Code | Error | Description |  
|:------:|:-------|:-------------|  
| 1001 | System Id not found | Either attribute is not found OR is null or blank. |
| 1002 | Message Id not found | Either attribute is not found OR is null or blank. |
| 1003 | Device Id not found | Either attribute is not found OR is null or blank. |
| 1004 | ECU Type not found | Either attribute is not found OR is null or blank. |
| 1005 | Source Id not found | Either attribute is not found OR is null or blank. |
| 1006 | Target Id not found | Either attribute is not found OR is null or blank. |
| 1007 | Message Type not found | Either attribute is not found OR is null or blank. |
| 1008 | Message Creation Time Not Found | Either attribute is not found OR is null or blank. |
| 1200 | Success | Success response. |
| 1401 | Unauthorized | If the systemid associated with the publisher of the message is not authorized. |  
| 1403 | Forbidden | If the message was received on a forbidden topic. IGNORE Currently|
| 1404 | Not Found | If the message was sent to an unknown topic.  IGNORE Currently|
| 1408 | Request Timeout | If the timeout git commit is set and logic warrants, and a timeout event occurs. |
| 1413 | Payload too large | If the message size exceeds a defined threshold (a threshold is required to protect against sending malicious messages.) |
| 1409 | Version Conflict | Message version not found OR not provided. |
| 1500 | Internal Server Error | If error occured / encountered processing a message.|
| 1501 | Not Implemented | If the configured endpoint value is not correct and a message cannot be read / published. |
| 1503 | Service Unavailable | If the configured endpoint service is unavailable for receiving / transmitting the messages.  |
| 4000 | User status not confirmed | User status not confirmed. |
| 4001 | User has another challenge | User has another challenge. |
| 4002 | User already confirmed | User already confirmed. |
| 4003 | User not authorized | User not authorized. |
| 4004 | Cognito Identity or General Security exception occurred | Cognito Identity or General Security exception occurred. |
| 4005 | UserName can’t be null or empty | User name can’t be null or empty. |
| 4006 | Password can’t be null or empty | Password can’t be null or empty. |
| 4007 | AppClientId can’t be null or empty | App Client Id can’t be null or empty. |
| 4008 | UserPoolId can’t be null or empty | User Pool Id can’t be null or empty. |
| 4009 | AppClientSecret can’t be null or empty | App Client Secret can’t be null or empty. |
| 4010 | New password can’t be null or empty | New password can’t be null or empty. |
| 4011 | Authentication response from AWS is null | Authentication response from AWS is null. |
| 5000 | Invalid Lifecycle Update | Invalid lifecycle update.  |
| 5001 | Database Error | Exception occurred while performing Database Operation.  |
| 5002 | Invalid Url | Invalid URL used.  |
| 6000 | Retry threshold | When maximum retry count reached. |
| 6001 | Retry queue unavailable | When retry queue is not available. |
| 6002 | Retry failure | When retry processor not able to connect to corresponding input queue. |
| 6003 | Invalid messageId or queueName | Invalid messageId or queueName. |
| 6004 | ProcessorName can not be null or empty | Source Processor Name can not be null or empty. |
| 6005 | QueueName can not be null or empty | Queue Name can not be null or empty. |
| 6006 | QueueStatus can not be null or empty | Queue Status can not be null or empty. |
| 6007 | MaxRetryCount can not be null | Max Retry Count can not be null. |
| 6008 | RetryIntervalType can not be null or empty | Retry Interval Type can not be null or empty. |
| 6009 | RetryInterval can not be null | Retry Interval can not be null. |
| 6010 | ProcessorStatus can not be null or empty | Processor Status can not be null or empty. |
| 6011 | ResilienceMode can not be null or empty | Resilience Mode can not be null or empty. |
| 6012 | MsgLimitPerMin can not be null | Message Limit Per Min can not be null. |
| 6013 | CreatedTime can not be null | Created Time can not be null. |
| 6014 | CreatedBy can not be null or empty | Created By can not be null or empty. |
| 6015 | UpdatedTime can not be null | Updated Time can not be null. |
| 6016 | UpdatedBy can not be null or empty | Updated By can not be null or empty. |
| 6017 | InputQueue can not be null or empty | Input Queue can not be null or empty. |
| 6018 | QueueType can not be null or empty | Queue Type can not be null or empty. |
| 6019 | Application Exception occurred in Resilience | Application Exception occurred in Resilience. |
| 6020 | Queue Connection Failed | Exception occurred while connecting to queue. |
| 6100 | Region not found | Region Code Does Not Exist In Records. |
| 6101 | Null Queue Name | Queue Name Is Empty. |
| 6102 | Null Queue Access key | Queue Access Key Is Empty. |
| 6103 | Null Queue Secret key | Queue Secret Key Is Empty. |
| 6104 | Null Queue Region | Queue Region Does Not Exist. |
| 6105 | Null API Endpoint | API Endpoint Is Empty. |
| 6106 | Null API Key | API Key Is Empty. |
| 6107 | API Error | Error Invoking API Endpoint. |
| 6108 | Invalid Vin Length | Vin Length Is Not Having 17 Chars. |
| 6109 | Invalid System id Length | System Id Length Is Not Having 23 Chars. |
| 6110 | Duplicate Vin | Vin Already Exists In Table. |
| 6111 | Duplicate System id | System Id Already Exists In Table. |
| 6112 | Invalid SystemID/VIN input | Please provide valid SystemID or VIN in request. |

### Health Check codes
| Code | Error | Description |  
|:------:|:-------|:-------------|  
| | | |


## Communication Core 

Configured error code range is 10000 to 10999.

### Message Dispatcher

Covers GLOBAL and REGIONAL Partition.

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 1001 | System Id not found | Either attribute is not found OR is null or blank. | No |
| 1002 | Message Id not found | Either attribute is not found OR is null or blank. | No |
| 1003 | Device Id not found | Either attribute is not found OR is null or blank. | No |
| 1004 | ECU Type not found | Either attribute is not found OR is null or blank. | No |
| 1005 | Source Id not found | Either attribute is not found OR is null or blank. | No |
| 1006 | Target Id not found | Either attribute is not found OR is null or blank. | No |
| 1007 | Message Type not found | Either attribute is not found OR is null or blank. | No |
| 1008 | Message Creation Time Not Found | Either attribute is not found OR is null or blank. | No |
| 1409 | Version Not Found | If the version is not present in the message| No |
| 10000 | Body Not Found | If the body is not present in the message| No |
| 10001 | Status Not Found | If the Status is not present in the message| No |
| 10050 | Route Not Found | If the destination route is not found in the table for the message type, target id/application name| No |
| 10051 | Route Not Available | If the specifed destination is available in table , but not available in AWS| Yes |
| 10052 | Exception while sending to MSP Stream | Exception while sending to MSP Stream| Yes |
| 10053 | Exception while calling Route Config API | Exception while calling Route Config API| Yes |

### Route Config API

Covers GLOBAL and REGIONAL Partition.

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 10021 | Application id cannot be blank  | When creating or updating routes for application, application id cannot be null or empty | No |  
| 10022 | Application name cannot be blank | When creating or updating application , application name cannot be null or empty | No |  
| 10023 | Created by cannot be blank | When creating application or message type or routes, created by cannot be null or empty | No |   
| 10024 | Updated by cannot be blank | When updating application or message type or routes updated by cannot be null or empty| No |
| 10025 | Message type cannot be blank | When creating  message type ,msg type cannot be null or empty| No |
| 10026 | Route cannot be blank|  When creating or updating routes for application or message type, route cannot be null or empty | No |
| 10027 | Route type should be either stream or queue | When creating  or updating routes for application or message type, route type should be either stream or queue| No |
| 10028 | Application description cannot be blank | When creating or updating application , application description cannot be null or empty| No |
| 10029 | Message type id cannot be blank | When creating or updating routes for message type, msg type id cannot be null or empty| No |
| 10030 | Ack required should be either true or false | When updating message type ack required should be either true or false | No |
| 10031 | Application not found | The given application id or name not exist | No |
| 10032 | Message type not found | The given message type id or msg type not exist | No |
| 10033 | Route not found | Route not exist | No |
| 10034 | Application name already exist | Application should be unique | No |
| 10035 | Message type already exists | Message type should be unique | No |
| 10036 | Data with the given route and route type | The given route and route type combination already exist in given id. Combination already exist in the given id | No |


### C2D Sender

Covers GLOBAL and REGIONAL Partition.

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 1001 | System Id not found | Either attribute is not found OR is null or blank. | No |
| 1002 | Message Id not found | Either attribute is not found OR is null or blank. | No |
| 1003 | Device Id not found | Either attribute is not found OR is null or blank. | No |
| 1004 | ECU Type not found | Either attribute is not found OR is null or blank. | No |
| 1005 | Source Id not found | Either attribute is not found OR is null or blank. | No |
| 1006 | Target Id not found | Either attribute is not found OR is null or blank. | No |
| 1007 | Message Type not found | Either attribute is not found OR is null or blank. | No |
| 1008 | Message Creation Time Not Found | Either attribute is not found OR is null or blank. | No |
| 1409 | Version Not Found | If the version is not present in the message| No |
| 10000 | Body Not Found | If the body is not present in the message| No |
| 10001 | Status Not Found | If the Status is not present in the message| No |
| 10003 | Message Expired | If message got expired | No |
| 10005 | Device Not Found | If thing name is not found on aws iot core | No |
| 10054 | Exception while sending to MSP Stream | Exception while sending to MSP Stream | Yes |
| 10055 | Exception while sending to Expiry Queue | Exception while sending to Expiry Queue | Yes |
| 10056 | Exception while calling Route Config API | Exception while calling Route Config API | Yes |

### C2D Sender API

Covers GLOBAL and REGIONAL Partition.


| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 1413 | Payload too large | If the message list size exceeds a defined threshold (a threshold is required to protect against sending malicious messages.) | No |
| 10004 | Empty Message | If the message received is empty| No |  
| 10011 | Queue Not Found | If the message was sent to an invalid queue or queue not found. | No |  Need discussion 
| 10013 | Publish Failure | If the configured endpoint value is not correct and a message cannot be read / published.| No | Need discussion
| 10017 | Exception Occured | If any exception occured other than queue related for eg: IO, Null or any general exception occuring | No |

***

## Device Management

Configured error code range is 13000 to 13999.

### Request Processor


| Code | Error | Description |
|:------:|:-------|:-------------|
| 1200 | SUCCESS | If Request successfully submitted for registration|
| 1413 | Payload too large | If the message size exceeds a defined threshold (a threshold is required to protect against sending malicious messages.)|
| 13002 | Maximum device limit exceeded | If a payload of more than 1000 devices is sent as a request|
| 13004 | Invalid Creator| If invalid values such as special characters present in personaid|
| 13006 | No device id found | If empty payload is sent|
| 13007 | Mandatory fields are empty | If device id/ system name/ attestation mechanism is not present in the request message|

### Registration 
| Code | Error | Description |
|:------:|:-------|:-------------|
| 1200 | Success | If status of a device is successfully fetched|
| 13001 | Invalid status found | If invalid status is provided in api request|
| 13005 | Invalid action found | Action param in detail status API should be download or null|
| 13008 | Thing creation failed | Thing creation failed in regional registration|
| 13009 | Throttle exception occurred | Throttle exception occurred while thing creation|
| 13010 | Provision query call back to global failed | API call to confirm successful rehoming to provision query service failedt|
| 13011 | JMS Exception occurred | Exception occurred while listening to the device queue.|
| 13012 | Device deletion in cloud failed | Failed to delete thing from cloud|
| 13013 | JSON Processing Exception | Exception occurred while mapping JSON|
| 13014 | Invalid Device Id | Device not found in db for the device_id|
| 13015 | More than one in progress request found | Update Registration request table failed due to more than one in progress request|
| 13016 | Exception occurred while mapping dto | Exception occurred while mapping dto|
| 13017 | No provisioned device found for system id | Device deletion failed due to no device found|
| 13018 | No devices found | If no devices is found in db|
| 13019 | Successfully deleted device from cloud | Successfully deleted device from cloud|
| 13020 | Thing already exists in cloud. Duplicate system_id found  | Thing already exists in cloud. Duplicate system_id found |


### Provisioning Query


| Code | Error | Description |
|:------:|:-------|:-------------|
| 1200 | SUCCESS | Device provisioning query execution was successfull |
| 1003 | Invalid device id | Device id is null or empty in provisioning query message |
| 13101| Invalid vin | Vin is null or empty in provisioning query message
| 13103|	Invalid system id | Device is not present with the given system id in database
| 13105|	Regional api invocation failed | Regional api invocation failed due to rest client exception
| 13108|	Device Id does not match | Device is present in the database with the system Id given but the corresponding device id is wrong
| 13111|	Device is not registered | If device is not registered with the given device id
| 13112|	System name does not match | If the system name is different for the given system id 
| 13114|	Property bag is null | If property bag is not present in the json.
| 13115|	Invalid message type | If message id is something other than PROVISION_QUERY
| 13118|	Body is null | If the body is empty
| 13125|	Duplicate unique key values in device table | If duplicate value is present in sub system id.
| 13126|	Unexpected encoding type | If encoding type is other than 0 and 1
| 13127|	Unsupported encoding type | If encoding type is not an Integer.
| 13129|	Mandatory fields are empty | If any mandatory field is missing in the body 
| 13130|  Header and body does not match | If the request body parameters are not matching with that specified in the header



### Provisioning 

Covers GLOBAL and REGIONAL Partition.

| Code | Error | Description |
|:------:|:-------|:-------------|
| 1200 | SUCCESS | Device provisioning was successfull | 
| 1001 | System id is null | If system id is not present in the body.
| 1003 | Device id is null | If device id is not present in the body.
| 13113 | Invalid json structure | If json given is not proper.
| 13114 | Property bag is null | If property bag is not present in the json.
| 13115 | Invalid message type  | If message type is other than DEVICE_PROVISION.
| 13116 | Sub system id is null | If sub system id is not present in the body.
| 13117 | Vehicle info is null | If vehicle info is not present in the body.
| 13119 | Region code is null | If region code is not present in the body.
| 13120 | Country code is null | If country code is not present in the body.
| 13121 | Chipset count is null | If chipset count is not present in the body.
| 13122 | Field violation | If any mandatory field is missing in the message, If any field contains Invalid values such as special characters.
| 13123 | Device not found | If the primary device does not exist in db
| 13124 | Device already provisioned | If the device with device id is already provisioned
| 13125 | Duplicate unique key in device table | If duplicate value is present in subsystem id
| 13126 | Unexpected encoding type | If encoding type is other than 0 or 1.
| 13127 | Unsupported encoding type | If encoding type given is not an Integer.
| 13128 | Duplicate unique key in vin table | If duplicate value is present in vin 
| 13130 | Values in the header and body does not match | If the values in header and body does not match 


### State Processor
| Code | Error | Description |
|:------:|:-------|:-------------|
| | | |


### Device APIs

Covers GLOBAL and REGIONAL Partition.

| Code | Error | Description |
|:------:|:-------|:-------------|
|13200 |Device Not Found |Device does not exist |



### Vehicle APIs

| Code | Error | Description |
|:------:|:-------|:-------------|
|13201 |Vehicle Not Found |Vehicle does not exist|
|13202 |Connection State not found for given SystemId |Connection State not found for given SystemId|
|13203 |Invalid Connection state value in given request |Invalid Connection state value in given request|
|13204 |Invalid SystemId value in given request |Invalid SystemId value in given request|
|13205 |Invalid state change time value in given request |Invalid state change time value in given request|



***

## OTA components    

Configured error code range is 14000 to 14499. 

| Code | Error | Description |
|:------:|:-------|:-------------|
|14000 |success |success response from CAROTA|
|14001 |model is not allowed to be empty |model cannot be an empty string |
|14002 |vin must be 17 chars long |vin must be 17 characters |
|14003 |ecu is not allowed to be empty |ecu cannot be an empty string |
|14004 |sn is not allowed to be empty |sn cannot be an empty string |
|14005 |vehicles are not allowed to be empty |vehicles list must not empty |
|14006 |version is not allowed to be empty |version cannot be an empty string |
|14007 |file must be URL |file must be a valid URL |
|14008 |Date is required or Date formatter is wrong. |Date must not be null or Date must be of correct format |
|14009 |ref-id is not allowed to be empty |ref-id cannot be an empty string |
|14010 |script-ref-id is not allowed to be empty |script-ref-id cannot be an empty string |
|14011 |schedule-ref-id is not allowed to be empty |schedule-ref-id cannot be an empty string |
|14012 |event is not allowed to be empty |event cannot be an empty string |
|14013 |release-note is not allowed to be empty |release-note cannot be an empty string |
|14014 |pre-condition element is not allowed to be empty |pre-condition list cannot be empty |
|14015 |source-version is not allowed to be empty |source-version cannot be an empty string |
|14016 |target-version is not allowed to be empty |target-version cannot be an empty string |
|14017 |x-token is not allowed to be empty |x-token cannot be empty |
|14018 |x-checksum is not allowed to be empty |x-checksum cannot be empty |
|14019 |x-tm verification failed |x-tm verification failed |
|14020 |Invalid Token |Invalid Token |
|14021 |token verification failed |token verification failed |
|14022 |token is timeout |token is timeout |
|14023 |Unknown Error |Unknown Error from CAROTA |
|14024 |No firmware package available |Target version is not uploaded |
|14025 |Schedule is not found |Schedule does not exist |
|14026 |Schedule already exists |Schedule is already present |
|14027 |campaign is not found |Campaign does not exist |
|14028 |campaign already exists |Campaign is already present |
|14029 |duplicated Firmware Version |The firmware version is already uploaded |
|14030 |Vehicle Model name is wrong |vehicle was not onboarded to CAROTA |
|14031 |No any parameters |No any parameters |
|14032 |duplicated VIN number |VIN is already present |
|14033 |ECU name is wrong |ECU name is wrong |
|14034 |Invalid event |Event must be a valid event |
|14035 |From is empty |From field must be an empty string |
|14036 |To is empty |To field must not be an empty string |
|14037 |URL is not valid |URL is not a valid url |
|14038 |Invalid value for precondition |Pre-condition values must be valid. |
|14039 |script step is empty |script-step element must not be empty |
|14040 |Ref id is not a valid schedule id |Ref Id must be present in the ota schedule table |
***

## Command and Control components

Configured error code range is 14500 to 14999. 

| Code | Error | Description |
|:------:|:-------|:-------------|
|14500 |Invalid command name |Command name values must be valid. |
|14501 |Command name is null or empty |Command name should not be empty. |
|14502 |Invalid app id |App id should be valid. |
|14503 |Payload is null or empty |Payload should not be empty. |
|14504 |Invalid CCID |CCID should be valid. |
|14505 |Target is empty |Target should not be empty. |
|14506 |Invalid trackingId |Tracking id should not be empty. |
|14507 |Invalid vin |Vin should be valid. |
|14508 |Invalid systemId |System id should be valid. |
|14509 |Target size should be less than or equals 50 |Target array size should not be greater than 50. |
|14510 |Missed CCID |Required CCID is not available. |

***
## SOTA components

Configured error code range is 15000  to 15499. 

| Code | Error | Description |
|:------:|:-------|:-------------|
|15000 |success |success response from SOTA | 
|15001 |Mandatory field missing |One or many mandatory fields in the request are missing |
|15002 |Uploading file to S3 bucket got failed |Error occurred while uploading the package to S3 bucket |
|15003 |Invalid Json format |Error occurred while parsing json |
|15004 |File name format is wrong |File name does not follow the valid format |
|15005 |File not selected |File to be uploaded is not provided in the request |
|15006 |No data available |No data is available in the database to fetch |
|15007 |System name is invalid |System name validation failed |

***
## Chipset/SKU components    

Configured error code range is 11000 to 11999.   

### Chipset Onboarding

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 11000 | Chipsets Not Found | Chipsets not found in the message | No |
| 11001 | Chipsets State Not Found | Chipsets State Not Found in the message | No |
| 11002 | Chipset Name Not Found | Chipset Name not found in the message | No |
| 11003 | Chipset Type Not Found | Chipset Type Not Found in the message | No |
| 11004 | Chipset Version Not Found | Chipset Version Not Found in the message | No |
| 11005 | Unsupported base Encoding Type | If the base encoding type value is not 'one' | No |
| 11006 | Invalid message Type | If the message types are not CHIPSET_PROVISION and CHIPSET_ONBOARDING_NONCE_RESPONSE | No |
| 11007 | Invalid Transaction Id | Transaction id is not valid in NONCE Response | No |
| 11008 | Chipset Mismatch with count | If number of chipsets and chipset count don't match | No |
| 11009 | Chipset Count Not Found | Chipset count is null or not found | No |
| 11010 | Onboarding Request Failed | Onboarding Request failed due to unknown exceptions | Yes |
| 11011 | Stop Onboarding when in progress | Stopping onboarding when the status is Onboarding in progress | Yes |
| 11012 | Stop Onboarding when Completed | Stopping onboarding when the status is Onboarding Completed | No |
| 11013 | Nonce Request Failed | Nonce Request Failed while calling LMS API | Yes |
| 11014 | Additional Data Request Failed | Additional Data Request Failed while calling LMS API | Yes |
| 11015 | Exception while sending to C2Dsender | Exception while sending to C2Dsender | Yes |
| 11015 | PROGRAM_SKU_ID_NOT_FOUND | If the programSKUId is not found | No |
| 11016 | DBCALL_FAILED | If the Database Call failed | Yes |
| 11017 | C2DSENDER_FAILED  | If the C2dSender Call failed | Yes |
| 11018 | UNEXPECTED_EXCEPTION | If there is any unexpected exception | Yes |
| 11019 | NONCE_VALIDATION_FAILED | Error while validating nonce response | Yes |
| 11020 | APPLICATION_DATA_VALIDATION_FAILED | Error while validating application data response | Yes |
| 11021 | INVALID_APPLICATION_DATA | Error while converting base64 encoded application data(prog id, sku id) recieved from qwes. | Yes |

### COP RETRY PRO
| Code | Error | Description | 
|:------:|:-------|:-------------|
| 11100 | NONCE_PUBLISHED_TIMEOUT | if status of chipset in db is NONCE_PUBLISHED_RETRY for more than specified nonce timout duration(now its 1200000ms) |

### CHIPSET API
| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 11025 | ACTIVE_STATUS_ALLOWED  | update request is expected only to have "active" status | No |


### SMP

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 10004 | Empty Payload | chipset payload should not be empty | No |
| 11500 | Program/Program Version  Not Found | If the Program and/or Program Version with Given Program Id Not Found | No |
| 11501 | Incorrect Chipset and/or Chipset SP | If the Chipset and/or Chipset SP is incorrect | No |
| 11502 | Incorrect Program ID and/or SKU ID | If the  Program ID and/or SKU ID in incorrect | No |
| 11503 | Program Not Active | If the Program with Given Program Id Not Active | No |
| 11504 | Onboarding Exception Occurred | If some exception occurred while onboading a chipset | No |
| 11505 | Invalid VIN | If the provided VIN is invalid | No |
| 11506 | Invalid Chipset Details | If the Chipset Details while onboarding is Invalid | No |
| 11507 | Invalid Vehicle Info Details | If the Vehicle info details while onboarding is invalid | No |
| 11508 | Incorrect ECU | If the ECU is incorrect | No |
| 11509 | ProgramSkuId not found | If the ProgramSkuId not found | No |
| 11510 | Partition information not found| Partition information should not be null or empty| No |

### SMP ADAPTER API

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 11601 | Api Call Failure| If Api call to chipset api fails | No |

### LMS API

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 11200 | Cognito authentication Failed | Unable to get authorization token | No |
| 11201 | QWES Authentication Failed | QWES Authentication Failed | No |
| 11202 | Nonce Request Failed | Nonce Request Failed | No |
| 11203 | Invalid Token | Invalid Attestation Report | No |
| 11204 | Invalid Input | Incorrect Input Values | No |
| 11205 | Licence Request Failed | Licence Request Failed | No |
| 11206 | Attestation Report Missing | Attestation Report Missing | No |
| 11207 | Features Missing | Features Missing | No |
| 11208 | Delete Serials Missing | Delete Serials Missing | No |
| 11209 | Invalid Attestation Token | Invalid Attestation Token | No |
| 11210 | Delete Request Failed | Delete Request Failed | No |
| 11211 | Application Data Request Failed | Application Data Request Failed | No |
| 11212 | Attestations Missing | Attestation Report Missing | No |
| 11213 | Delete Serials Empty | Delete Serials Empty | No |
| 11214 | Auth Headers Missing | Auth Headers Missing | No |
| 11215 | API Key Invalid | API Key Invalid | No |
| 11216 | Invalid Payload Version | Invalid Payload Version | No |
| 11217 | Attestation Error | Attestation Error | No |
| 11218 | QWES Blank Response | QWES Blank Response | No |
| 11219 | VALIDATION_ERROR  | If validation of input failed at LMS C/Q api | No |
| 11220 | AUTHENTICATION_ERROR | QWES Blank Response | No |

### LMS Q API
| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 11221 | Program Error Code | Unknown Error during Create Program from CFT | No |

### LMS PROCESSOR

| Code | Error | Description | Retry |
|:------:|:-------|:-------------|:-----:|
| 11400 | Invalid Install license request | Invalid Install license request | No |
| 11401 | Invalid delete license request | Invalid delete license request | No |
| 11402 | SOURCE TRANSACTION IS ID MISSING |Source Transaction Id is missing| No |
| 11403 | ECU ID IS MISSING| Ecu Id is missing| No |
| 11404 | VIN MISSING |  Vin is missing | No |
| 11405 | DELETE SERIALS MISSING | Delete serials is missing | No |
| 11406 | SOURCE TRANSACTION TIME MISSING | Source transaction time is missing| No |
| 11407 | ECU TYPE MISSING | Ecu type is missing | No |
| 11408 | FEATURE LIST MISSING | Feature List is missing  | No |
| 11409 | TRANSACTION TYPE MISSING| Source transaction time is missing| No |
| 11410 | SKU ID MISSING | Sku Id is missing | No |
| 11411 | NO DEVICE FOUND | No device found | No |
| 11412 | NO CHIPSET FOUND | No Chipset Found | No |
| 11413 | UNABLE TO GET NONCE |Unable to get nonce | No |
| 11414 | UNABLE TO GET LICENSE |Unable to get license | No |
| 11415 | INVALID NONCE RESPONSE | Invalid nonce response from device | No |
| 11416 | INVALID LICENSE RESPONSE |Invalid License response from device | No |
| 11417 | INVALID DELETE RESPONSE |Invalid delete response from device | No |
| 11418 | INSTALL LICENCE FAILED |License installation has failed | No |
| 11419 | DELETE LICENSE FAILED|Delete license has failed | No |
| 11420 | DATABASE_EXCEPTION |Database Exception occured| Yes |
| 11421 | REPORTING_TRANSACTION_ERROR| Reporting license status to SMP failed| No |
| 11422 | Publishing to c2d failed | Publishing messages to C2D failed| Yes |

### LMS Retry PROCESSOR

| Code | Error | Description |
|:------:|:-------|:-------------|
| 11451 | NONCE_PUBLISHED_TIMEOUT | If status of license transaction in db is NONCE_PUBLISHED_RETRY for more than specified timeout duration |
| 11452 | LICENSE_PUBLISHED_TIMEOUT | If status of license transaction in db is LICENSE_PUBLISHED_RETRY for more than specified timeout duration | 
| 11453 | ERROR_CODE_LMSC_TIMEOUT | If status of license transaction in db is LMSC_RETRY for more than specified timeout duration | 
| 11454 | ERROR_CODE_C2D_TIMEOUT | If status of license transaction in db is C2D_RETRY for more than specified timeout duration |
| 11455 | DELETE_PUBLISHED_TIMEOUT | If status of license transaction in db is DELETE_PUBLISHED_RETRY for more than specified timeout duration |

***

## C2C Data Service

| Code | Error | Description |
|:------:|:-------|:-------------|
| | | |
