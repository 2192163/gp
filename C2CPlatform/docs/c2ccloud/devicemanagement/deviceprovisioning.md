<center>

# **Provisioning Flow Document** 

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

**Feature overview**

Device Provisioning happens after the assembly of vehicle with device, and it will be triggered when the vehicle starts for the first time. Device will be initiating the device provisioning process. It happens through the below two steps.

1. Device Provisioning Query: Identify home/region for vehicle & its devices. Vehicle will then rehome to Regional Partition. 
2. Device Provisioning: Once the device registered in regional partition, device receives the regional connection details. Devices connect to the corresponding region and send the provisioning message.

**Device Provision Query service**

Vehicles will be assembled with the devices after they have been registered in global partition. The device will connect to the provided global Iot gateway endpoint using the certificate. Once connected, the C2C Edge hub will prepare the provisioning query message and send it through the MQTT channel to the Global IoT Gateway endpoint. The Global partitions Provisioning message processing component would process this message and register the device to the regional instance.

**Device Provisioning service**

Following the successful completion of the query procedure, the regional IoT Gateway endpoint will be communicated to the device through a message. The device will connect
to a regional IoT Gateway instance and transmit the provisioning message to that instance. This is the first time the device connects to the regional instance. Provisioning messages in regional instances are picked up by the Communication Core message dispatcher component and sent to the Device Management's Provisioning Input Queue. The message will be received by the provisioning module, which will then perform data UPSERT operations for device Metadata, Device Details, SIM information, and VIN details.

**Typical use case**

1. Process provision query message and register device in regional partition: Once the device is powered on, it should connect to IoT Global gateway. C2C Platform should be listening to the provisioning query message and validates the message. The C2C platform then checks for the status of the registration in the global device store. Following this the additional data in the query message is then   updated in the device data store. Certificate details, regional URL and other details needed for regional registration is picked up from global device store and send to Provisioning Query processor. Provisioning Query processor invoke the regional registration service. Regional registration component creates the device identity in regional IoT gateway using the same certificate obtained from Global data store. The updated status and other device details are stored in the regional data store.
2. Process provisioning message: Following the successful completion of the query procedure, the regional IoT Gateway endpoint should communicated to the device through a message. The device should connect to a regional IoT Gateway instance and transmit the provisioning message to that instance. When the provisioning message is received, the provisioning module validates the header and body of the message. Once all the fields have been validated, provisioning module should check the database to verify if the device has previously been provisioned and match the unique ids to the fields in the message. The additional data is then stored in both the vehicle and device databases, and the status should be updated to PROVISION. Following this provisioning response should be sent back to the device via C2C Communication Core with Message type DEVICE_PROVISION_RESPONSE and chipset onboarding process should be initiated. After completing the provisioning process an API should be invoked to delete the device identity from the global partition.
3. Delete device identity from global after provision a device: Once the vehicle is registered in regional instance, all the communication here after will be done through the regional partition. Therefore, the device identity in the global partition will no longer be needed for communicating to the device. So after successfully completing the provisioning process the device identity will be deleted by invoking the deletion API in the global registration module. The deletion process can be enabled or disabled depending on the user preference.

**Variant use case**

1. Handle transaction failures: Any failure happening to the process while execution will be handled by the Resilience module in the regional registration service. The failure will be captured, and all the operation executed will be reverted back to its initial state and failure response will be sent back to the device.


### <a id="_Scope"></a>1.1 Scope 

This document is for the software developer implementing the provisioning feature/features to ensure compliance with feature requirements and software design requirements. This document also is intended
to assist the test engineer with designing provisioning feature test plans.

### <a id="_OutofScope"></a>1.2 Out of Scope 

NA

### <a id="_Assumption"></a>1.3 Assumption 

NA

## <a id="_Design"></a>2. Design

**High-level software design**

<figure>
<img src="../../../assets/provFlowFig1.png" width="1100" />
<figcaption>High-level software design</figcaption>
</figure>

Provisioning is a two-part procedure, with the first stage being the selection of the region/home for the vehicle and its related registered devices. The second stage involves storing the vehicle and device metadata in a database and removing the device identification from the global partition. Provisioning will be triggered at the end of the vehicle production line. The manufacturing location will test and verify vehicle devices at random, as well as initiate the provisioning sequence for the vehicle before it is transferred to the dealer / warehouse / vendor.

* Provision query process flow:
After all devices have been registered in the global partition, vehicle assembly will commence, and all devices will be integrated into the vehicle. For the query process, only the primary device will be communicated to the C2CPlatform. Using the certificate, the device will connect to the given global IoT gateway endpoint. Once connected, the C2C Edge hub will prepare the provisioning query message and send it to the Global IoT Gateway endpoint through the MQTT channel. The Global partitions Provisioning query message processing component must handle this message and register the device to the regional instance. Once the provisioning query message is received to the provision query module, it validates the request and stores it in the database. Following that, the database is updated with the vehicle and device data from the query message. The device is finally sent to the registration module, where it is registered in the regional partition. When the registration in the regional partition is successfully completed, a confirmation message is sent back to the provision query module, and the database status is updated to REGIONAL. The C2CPlatform will then send a query response to the device, indicating that the query procedure has been finished.

* Provisioning process flow:
Following the successful completion of the query procedure, the regional IoT Gateway endpoint will be communicated to the device through a message. The device will connect to a regional IoT Gateway instance and transmit the provisioning message to that instance. When the provisioning message is received, the provisioning module validates the header and body of the message. Once all the fields have been validated, provisioning module will check the database to verify if the device has previously been provisioned and match the unique ids to the fields in the message. The additional data is then stored in both the vehicle and device databases, and the status is updated to PROVISION. Following this provisioning response is sent back to the device via C2C Communication Core with Message type DEVICE_PROVISION_RESPONSE and chipset onboarding process is initiated. After completing the provisioning process an API is invoked to delete the device identity from the global partition.

**Sequence diagram**

Device Provision Query Flow

<figure>
<img src="../../../assets/provFlowFig2.png" width="900" />
<figcaption>Provision Query Sequence diagram</figcaption>
</figure>

Device Provisioning Process Flow

<figure>
<img src="../../../assets/provFlowFig3.png" width="1000" />
<figcaption>Provisioning flow Sequence diagram</figcaption>
</figure>

**API**

***publishProvisionQueryResponse() – Confirmation from regional registration module***

Once the device is rehomed and registered in the regional partition to acknowledge the status of the process, registration module will send a POST request to the global provision query module with status of the regional registration. The body will be receiving a RegionalRegistrationResponseDto object with device_id, system_id, status and failureDetails. The provisioning query module will check the status of the registration first. If it is SUCCESS, then the global database is updated with state as REGIONAL. If the status is FAIL, the database is updated with status as QRY_FAIL. Following this a provision query response is sent back to the device with the state of the process and error details if the process has failed.

RegionalRegistrationResponseDto:

<table>
  <tr>
    <th>Attribute Name</th>
    <th>Datatype</th>
  </tr>
  <tr>
    <td>device_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>system_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>status</td>
    <td>String</td>
  </tr>
  <tr>
    <td>failureDetails</td>
    <td>String</td>
  </tr>
</table>  

Prototype:

publishProvisionQueryResponse<br>
 (<br>
IN CONST RegionalRegistrationResponseDto regionalRegistrationResponseDto,<br>
OUT C2CResponseDto response<br>
);


Parameters:

<table>
  <tr>
    <td>in</td>
    <td>regionalRegistrationResponseDto</td>
	<td>The object will be having the status of the regional registration, system_id, device_id and failureDetails if any</td>
  </tr>
  <tr>
    <td>out</td>
    <td>response</td>
	<td>C2CResponseDto will be having a response code and a response message</td>
  </tr>
</table>  

Returns:

On success, returns success code success message, 
For failure, returns error code, error message.


<table>
  <tr>
    <td>URL</td>
    <td>/device-provisioning-query-service/v1/device/regional-registration/confirmation</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>POST</td>
  </tr>
  <tr>
    <td>Header</td>
    <td>accept-type: application/json<br>      
x-application: application_id<br> 
external-trace-id:string<br> 
content-type: application/json<br>     
</td>
  </tr>
  <tr>
    <td>API request</td>
    <td>[ <br>
  { <br>
    "deviceId": "string", <br>
    "systemId": "string", <br>
    "status": "string", <br>
    "failureDetails": "string"<br>
  } <br>
] <br>
</td>
  </tr>
  <tr>
    <td>API success response</td>
    <td>{ <br>
    "responseCode": "2001",<br> 
    "responseMessage": "SUCCESS<br>
} 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
    <td>{ <br>
    "responseCode": "3007", <br>
    "responseMessage": FAILED” <br>
} 
</td>
  </tr>
</table>  

***getAllVehicles () – API to get all system_id using vin***

The use should be able to retrieve the existing vehicle vins auto suggested in the user interface so that user can choose the list. The API will response with a list of VinSystemIdDto each time the API is invoked so that user will get an auto suggestion experience each time the person inserts a character in the UI.

VinSystemIdDto:

<table>
  <tr>
    <th>Attribute Name</th>
    <th>Datatype</th>
  </tr>
  <tr>
    <td>vin</td>
    <td>String</td>
  </tr>
  <tr>
    <td>system_id</td>
    <td>String</td>
  </tr>
</table> 

Prototype:

getAllVehicles<br>
 (<br>
IN CONST String vin,<br>
OUT C2CResponseDto response<br>
);

Parameters:

<table>
  <tr>
    <td>in</td>
    <td>vin</td>
	<td>Vin id of the vehicle the user wants to search</td>
  </tr>
  <tr>
    <td>out</td>
    <td>response</td>
	<td>C2CResponseDto will be having a response code a response message and the list of vin and system_id</td>
  </tr>
</table>  

Returns: 

On success, returns success code success message and List VinSystemIdDto
For failure, returns error code, error message

<table>
  <tr>
    <td>URL</td>
    <td>/device-provisioning-service/v1/device/vehicles?vin=vin_id</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET</td>
  </tr>
  <tr>
    <td>Header</td>
    <td>accept-type: application/json<br>      
x-application: application_id<br> 
external-trace-id:string<br> 
content-type: application/json<br>     
</td>
  </tr>
  <tr>
    <td>API request</td>
    <td>
</td>
  </tr>
  <tr>
    <td>Optional Parameter</td>
    <td>vin</td>
  </tr>
  <tr>
    <td>API success response</td>
    <td>{ <br> 
    "responseCode": "2001", <br> 
    "responseMessage": "SUCCESS”,<br> 
         "responseData": [ <br> 
 {<br> 
     "systemId": " String ",<br> 
     "vin": " String "<br> 
 },<br> 
 {<br> 
     "systemId": " String ",<br> 
     "vin": " String "<br> 
 }<br> 
] <br> 
} <br> 
</td>
<tr>
    <td>API incorrect vin</td>
    <td>{ <br> 
    "responseCode": "2001", <br> 
    "responseMessage": "No system_id found for the vin  'xx' "<br> 
         "responseData": null<br> 
} <br> 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
    <td>{ <br>
    "responseCode": "3007", <br>
    "responseMessage": FAILED” <br>
} 
</td>
  </tr>
</table>  

**Low-level software design**

<figure>
<img src="../../../assets/provFlowFig4.png" width="900" />
<figcaption>C2C Platform Architecture</figcaption>
</figure>

* Provision query process: When the provisioning query message is received at the provision query module, it first evaluates to see if the message_type in the request is PROVISION_QUERY. Following that, the body of the provision query message is decoded and changed to ProvisionQueryMessageDto. 

After the initial validation, the request is then stored into the t_provision_query_message table in global partition. Following this the request body fields are validated against the below constraints

* system_id should not be null and special characters check
* vin should not be null and special characters check
* device_id should not be null and special characters check
* primary field cannot be empty
* region_info cannot be empty
* ecu_type validated against a set of values (e.g.: IVI, TCU REFRIGERATOR)
	
If there is any violation of the above constraints the module will stop further execution and send Provision query response back to the device with status as FAIL and failure details as the constraint violation. If there is no constraint violation, then the next procedure is to validate the request headers fields with the body fields. For example, we will cross check the system_id to the system_id given in the body. Like wise all the fields are cross checked and if there is any violation or mismatch then the Provision query response is sent back to the device with status as FAIL and failure details as the constraint violation.

After all the validations, the module fetches the device details from the table and verify the status of the device. If the device is already registered in the regional partition that means if status of the device is REGIONAL, then no further operations will be performed. If not, then the device table will be updated, and vehicle data will be stored inside the t_vehicle table in the database. Following this the regional registration module is invoked from the provision query module to register the device in the regional partition. Only the primary devices will be sent for regional registration.

Upon completing the regional registration, a confirmation API is invoked from the regional registration module to acknowledge the status of the registration. After verifying the status, the device and vehicle table will be updated with the query completion state and provision query response will be sent back to the device with proper lifecycle state and other details of the process. 

* Provisioning Process: Following the successful completion of the query procedure, the regional IoT Gateway endpoint will be communicated to the device through a message. The device will connect to a regional IoT Gateway instance and transmit the provisioning message to that instance. After receiving the provisioning message similar to the query process, it first validates the message_type of the request and verifies it is DEVICE_PROVISION. Following that, the body of the provision query message is decoded and changed to ProvisioningMessageDto. Below is a sample of the provisioning message.

The provisioning request will be having all the additional details about the device vehicle and chipset. Similar to the query process it validates all the body fields and request header fields against a certain list of constraints.

* system_id should not be null and special characters check
* vin should not be null and special characters check
* device_id should not be null and special characters check
* ecu_type validated against a set of values (e.g.: IVI, TCU REFRIGERATOR)
* lifecyclestate should not contain special characters
After completing all the validations if any violations of the fields are found then device provisioning response is sent back to the device with lifecyclestate as PROV_FAIL.
Now the module will fetch the device from the regional database using the device_id in the request. Status of the stored device is checked to see if the device is already provisioned or not. All the additional data in the request is then stored inside the databases. Once the updating is successful the module will send the device provisioning response with proper lifecyclestate according to the ecu_type of the request
* if ecu_type is TCU or IVI set lifecyclestate as PROVISION
* if ecu_type is REFRIGERATOR set lifecyclestate as ACTIVE


Following this provisioning response is sent back to the device via C2C Communication Core with message_type DEVICE_PROVISION_RESPONSE and chipset onboarding process is initiated. After completing the provisioning process an API is invoked to delete the device identity from the global partition

**Low level sequence diagram**

<figure>
<img src="../../../assets/provFlowFig5.png" width="1000" />
<figcaption>Provision query Exception – Field violation</figcaption>
</figure>

<figure>
<img src="../../../assets/provFlowFig6.png" width="1000" />
<figcaption>Provision query Exception – Invalid message_type</figcaption>
</figure>

<figure>
<img src="../../../assets/provFlowFig7.png" width="900" />
<figcaption>Provision query Exception – Regional registration failed</figcaption>
</figure>

### <a id="_ClassDiagram"></a>2.1 Class Diagram

NA

### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA

## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

**External Dependencies**

1. org.springframework.boot: spring-boot-starter-web
2. org.springframework.cloud: spring-cloud-starter-config
3. org.springframework.cloud: spring-cloud-starter-bootstrap
4. org.springframework.boot: spring-boot-starter-actuator
5. org.springframework.boot: spring-boot-starter-data-jpa
6. org.springwork.boot: spring-boot-starter-test
7. org.postgresql : postgresql
8. org.modelmapper : modelmapper
9. com.fasterxml.jackson.core: jackson-databind
10. com.fasterxml.jackson.core: jackson-core
11. org.projectlombok : lombok
12. junit : junit
13. org.slf4j : slf4j-api
14. org.mockito: mockito-core
15. commons-beanutils: commons-beanutils
16. commons-codec: commons-codec
17. org.springframework.boot: spring-boot-maven-plugin
18. org.jacoco:jacoco-maven-plugin
19. maven-surefire-plugin
20. io.springfox : springfox-swagger2
21. io.springfox : springfox-swagger-ui

**Internal Dependencies**

1. Chipset Onboarding: At the end of the provisioning process the Chipset Onboarding process is initiated by sending a request to the Chipset onboarding module. After completing the onboarding, a     Chipset onboarding response message is sent back to the device containing confirmation of the Chipset onboarding in the system. This message will be triggered for every chipset getting onboarded.
2. Adapter used for publishing and receiving messages in AWS SQS: c2c_base_queue_sqs_impl, c2c_base_queue_intf.
3. Adapter for all common components: c2c_base_common , common


## <a id="_Databasedesign"></a>4. Database design

**Database Structure**

t_provision_query_message

<table>
  <tr>
    <th>Column Name</th>
    <th>Datatype</th>
  </tr>
  <tr>
    <td>id</td>
    <td>Long</td>
  </tr>
  <tr>
    <td>message_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>correlation_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>version</td>
    <td>String</td>
  </tr>
  <tr>
    <td>system_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>subsystem_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>vin</td>
    <td>String</td>
  </tr>
  <tr>
    <td>device_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>source_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>target_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>ecu_type</td>
    <td>String</td>
  </tr>
  <tr>
    <td>message_type</td>
    <td>String</td>
  </tr>
  <tr>
    <td>time</td>
    <td>Long</td>
  </tr>
  <tr>
    <td>region_code</td>
    <td>String</td>
  </tr>
  <tr>
    <td>country_code</td>
    <td>String</td>
  </tr>
  <tr>
    <td>property_bag</td>
    <td>String</td>
  </tr>
</table>

t_vehicle

<table>
  <tr>
    <th>Column Name</th>
    <th>Datatype</th>
  </tr>
  <tr>
    <td>id</td>
    <td>Long</td>
  </tr>
  <tr>
    <td>vin</td>
    <td>String</td>
  </tr>
  <tr>
    <td>system_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>state</td>
    <td>String</td>
  </tr>
  <tr>
    <td>region_code</td>
    <td>String</td>
  </tr>
  <tr>
    <td>country_code</td>
    <td>String</td>
  </tr>
</table>  

## <a id="_Applicationconfiguration"></a>5. Application configuration

**Device Provision Query service**

* server.servlet.context-path:context path
* logging.level.root
* logging.file.name
* server.port:port
* cloud.aws.credentials.access-key:Encrypted access key for Amazon Web services
* cloud.aws.credentials.secret-key:Encrypted secret key for Amazon Web services
* cloud.aws.region.static:Region name to be accessed in Amazon Web services.Datatype is String
* cloud.aws.device-provisioning-request-queue:queue used by the application uses
* cloud.aws.device-provisioning-response-queue:queue used by the application uses
* spring.datasource.url:PostgreSQL url
* spring.datasource.username:PostgreSQL username
* spring.datasource.password:PostgreSQL password
* spring.jpa.show-sql:PostgreSQL
* spring.datasource.driver-class-name:PostgreSQL
* management.endpoints.web.exposure.include
* regional-reg-api-url.default:Default region details
* regional-iot-end-point-url.default:Default region details
* server.compression.enabled:key for api authentication
* apikey.secret:key for api authentication
* x-requestor:key for api authentication

**Device Provisioning service**

* server.servlet.context-path:context path
* logging.level.root
* logging.file.name
* server.portport
* spring.jpa.show-sql:PostgreSQL
* spring.datasource.driver-class-name:PostgreSQL
* management.endpoints.web.exposure.include:Enable logging endpoint of actuator
* spring.datasource.url:PostgreSQL url
* spring.datasource.username:PostgreSQL username
* spring.datasource.password:PostgreSQL password
* cloud.aws.region.static:Region name to be accessed in Amazon Web services.Datatype is String
* cloud.aws.credentials.access-key:Encrypted access key for Amazon Web services
* cloud.aws.credentials.secret-key:Encrypted secret key for Amazon Web services
* cloud.aws.device-provisioning-request-queue:The queues that the application uses
* cloud.aws.device-provisioning-response-queue:The queues that the application uses
* cloud.aws.chipset-onboarding-request-queue:The queues that the application uses
* delete.thing.url:url to delete thing
* delete.from.global:To delete the thing from global after provisioning
* server.compression.enabled:key for api authentication
* apikey.secret:key for api authentication
* x-requestor:key for api authentication
 
## <a id="_AdditionalDetails"></a>6. Additional Details

**Logging Mechanism**

All the projects are having a common logging framework which is implemented in the module c2c_base_common.  Execution time is logged for every method which uses @LogExecutionTime annotation. Entry and exit log will be logged by this module for every public method. Trace id and span id is injected to all logs. Along with-it identifiers like message type, message id etc. is also logged in every line.

**Security**

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

**Error Handling**

Functional safety:

*	Usage of try catch blocks in every important method so that the processor will not get terminated even if one method fails. Exceptions are caught and logged properly
*	While publishing the messages to queues if a retriable exception is caught resilience retry mechanism is done for n times and if that also isn’t successful database is updated with proper error   messages.
*	In case of Json processing exception the message received will be directly saved into a database without further processing.
*	Internal API invocation will be retried n times with a specific time interval for exceptions except json processing exception.


## <a id="_Howto"></a>7. How to

NA
