

## Device Management

| Component Name|   Summary |  |   
| :------------- | :------------ | :------------: |    
| Registration |  |  [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}DeviceManagement/Registration/){ target="_blank"} |    
| Provisioning |  | [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}DeviceManagement/Provisioning/){  target="_blank"} |   
| Certificate Managmeent |  | [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}DeviceManagement/CertificateManagement/){  target="_blank"} |  

<center>

# **Registration Flow Document** 

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

Device Registration is an offline process where OEM/Tier1 will invoke the registration API of C2C platform to perform the registration. The output of the registration process will provide the configuration details that will be sideloaded into the device. Device will connect later to C2C platform using the configuration details provided in the side loading.
 
Device registration module registers all devices to the C2C platform to facilitate the device to cloud communication. Device registration in the global and regional partitions involves several validation processes, the generation of multiple unique identifiers, the generation of certificates for each device, registering the device with the Iot Gateway, and storing the data in tables to uniquely identify each device after registration. The device registration procedure is made up of the components listed below.

1. Device Request Processor: Registration request from OEM/Tier1 is send to the Request processor component in Global partition. The processor component will generate a unique id for each request and validate and verify the request parameters and headers before grouping them into small chunks of devices and forwarding them to the device registration module for additional operations. The request id is sent back to the device and using which it can interact with C2C platform to get the status of registration
2. Device Registration Service: The registration module will receive the device chunks and generate unique identifiers for each device, which will be stored in the database. These devices are then submitted to the Certificate manager module for certificate generation. After producing a certificate for each device, it will be registered in the IoT gateway and also its status in the database will be updated to REGISTERED.
3. Certificate Manager: This module is responsible for generating certificate for each device and returning a X.509 certificate for each device, to the registration module with certificate data.
4. Device Registration Regional Service: This module works in the same way as the global registration service. This module handles device registration and rehoming to regional partitions. Since certificates have already been produced and stored in the global partition, we will reuse the certificate details while registering devices in the regional partition and will register directly to the Iot Gateway in the regional partition.

**Typical use case**

* Single/multiple device registration: The user should be able to register a single or multiple devices by making a request to the C2C platform. The user must be an authorized individual to begin the registration procedure. Unauthorized individuals will not be able to send requests to the c2c platform. The C2C platform should validate the user request against a set of constraints previously defined for device registration. Following are list of constraints for registration.

	* Request not null validation
	* Size of the request exceeded validation
	* Payload size validation
	* Validate the size of field device_id and check for invalid characters
	* Validate the device_type to the list of valid system names
	* Validate the attestationMechasim to the list of valid Attestation Mechanism

The user has the privilege of breaking the bulk request into smaller groups for registration. Once all the devices have been validated against a certain set of constraints, they will be sent for certificate generation for device security. The platform should use X.509 certificate to secure the device communication. Using AWS Cloud, the platform should be able to create an X.509 certificate. Certificate based authentication is should leverage the X.509 public key infrastructure (PKI) standard.
These devices should be registered into the Iot Gateway through the AWS cloud, and the device meta data should be stored in a database. The device should be able to connect to the cloud using the url obtained once the identity is created in the IoT gateway.

* Retrieve status of the list of devices send for registration: The user should be able to retrieve the status of the registered devices by using the request id obtained from the response at the time of registration. The user should be able to query the C2C platform to know the progress of the registration using the request id. C2C platform should respond with a list of devices with its status, IoT endpoint connection url, certificate details, system_id, device_id, device_type and attestation mechanism requested by user.
The registration database should store all data related to the device registration. The user should also be able to obtain the details of successful and failed devices separately of a specific request when asked.

* Retrieve overall status of the request: The user should be able to retrieve the overall status of the registered devices and the count of failed and successful devices by using the request id obtained from the response at the time of registration. After registration, the user should be able to send a request to the C2C platform with the request id to retrieve the general status and count information of the request. The c2c platform should retrieve the count of successful and unsuccessful devices in a request after registration using the request id and return a json body with the overall status of the request to the user.
	
* Download the registration details of a request: The user should be able to download the detailed status of devices in a request after registration is completed. The user should be able to retrieve the status of each device using the request_id and should be able to send a request to registration module to download the detailed status of each device.
The device's registration data should be able to be downloaded as a json file using the request identifier.

* Delete the device identity from global after provisioning: Devices are registered as part of the registration process, and identities are generated on the Global IoT Gateway instance at the start. Following that, each device will begin and send the query region request (1st step of provisioning). The device will be registered on the regional IoT Gateway instance during this stage. After successfully registering a device in the Regional instance, the device's identification must be removed from the Global partition IoT Gateway instance.
The user should be able to delete a device in global partition using system_id. On successful deletion the user should receive a response back saying the identity has been deleted.

**Variant use case**

* Generate certificate on demand: For providing security of the device on registration we should create a X.509 certificate and attach it with the device while registering to the Iot Gateway. The X.509 certificate is used to secure the communication. Using AWS Cloud, the platform should be able to create an X.509 certificate. Certificate based authentication is built by leveraging the X.509 public key infrastructure (PKI) standard.


### <a id="_Scope"></a>1.1 Scope 

This document is for the software developer implementing the device registration feature/features to ensure compliance with feature requirements and software design requirements. This document also is intended to assist the test engineer with designing device registration feature test plans.

### <a id="_OutofScope"></a>1.2 Out of Scope 

NA

### <a id="_Assumption"></a>1.3 Assumption 

NA

## <a id="_Design"></a>2. Design

**High-level software design**

<figure>
<img src="../../../assets/RegFlowFig1.png" width="1200" />
<figcaption>High level software design</figcaption>
</figure>

Device Registration is an offline process where OEM/Tier1 will invoke the registration API of C2C platform to perform the registration. The output of the registration process will provide the configuration details that will be sideloaded into the device. Device will connect later to C2C platform using the configuration details provided in the side loading. Registration request from OEM/Tier1 is send to the Request processor component in Global partition and the request processor will generate a unique id for each request and verify the request details. Request id is sent back to the device and using which it can interact with C2C platform to get the status of registration. Validated device is then stored inside the device store and deice details is pushed to the queue. Device Registration service will listen to the queue and need to create the device identity in IoT gateway. For this certificate need to be generated. Device Registration processor interact with certificate management component. Certificate generators look up any certificate request has come and generate the certificate accordingly. Certificate will be pushed to output queue. Device Registration processor create the device identity in IoT gateway using the certificates and the device details are updated in the device store.

**List of various modules**

Registration module the following components to register a device successfully

1. Device Request Processor: The request processor module is responsible for validating the request coming from the device for registration in the C2C Platform. It receives a single or multiple device registration request and divides them into small chunks for further procedure and sends them to the device registration service module. 
2. Device Registration Service: The device registration module receives the list of device request and generate a unique system_id for each device and sends them for certificate generation to the certificate manager module. After generating certificate, the device is then registered into the global Iot Gateway.
3. Certificate Manager Service: This module is responsible for generating certificate and attaching them to each device and sending the device back to the registration module.

**Sequence diagram**

<figure>
<img src="../../../assets/RegFlowFig2.png" width="1000" />
<figcaption>Device Registration Flow Sequence diagram</figcaption>
</figure>

**API**

registerDevice() – Register single/multiple device request: User should be able to register a group of devices or a single device by submitting a request to the C2C platform. You will require a set of headers to validate the user's legitimacy before submitting the request. You will be unable to send and register your devices if you provide unauthorized header values.
When you send the request, it is routed to the request processor module, which validates the request against a set of constraints that have previously been defined for device registration. If you make a bulk registration request, the processor module will divide it into small chunks of devices and send them to the registration module for further processing.
Request processor will generate unique request ids for each request and store the request details in the data store. After this each device is forwarded to the registration module for registering in Iot gateway and the request id and status of registration is sent back to the device.

 
getDeviceDetails( ) – Detailed status API: When we send a list of devices for registration, we will only receive a response with a request id and a message stating that the request has been submitted. As a result, we've introduced a retrieve API call to the registration module in order to obtain the specific status of each device in that list. We'll do this by issuing a GET request call using the request_id we got when we submitted the list for registration. The request_id and device information are already recorded in the registration request and device tables. To get information about each device in the request, we construct a query that joins both tables and stores it to a DeviceResponseDto object and return a list of DeviceResponseDto holding all status information about each device as the response.


getDeviceData() - Overall status API: We'll use the same request id to retrieve the overall status of the registration request we sent. What we want to obtain from this API call is the overall number of devices in that request, as well as the success and failure count of devices after registration and the overall status of registration.
We will retrieve the overall device count from the registration request summary database using the request id, and then we will retrieve all of the device data from the registration request table and compute the success and failure count.
The total count, success count, and fail count are used to calculate the overall status of the request.
Calculation logic:

* if (success count + fail count = 0), then status=submitted
* (total count == (success count + fail count), status=Completed
* (total count > (success count + fail count), status= In progress
* And also, if (total count! (success count + fail count) status=In Progress

After completing all processes, the data is saved in a DeviceStatusResponseDto and sent as a response.


downloadDeviceDetail() – Download details of a request: We will use the same logic that we used to retrieve the status of each device to create an API to download the registration data of each device.
We will create an API to download each device's registration data using the same logic that we used to retrieve the status of each device. After creating the list of DeviceResponseDto, we'll convert the object to a byte array for downloading and save the file locally in json format with the name identical to the request_id. 


deleteThing() – Delete device identity from AWS cloud: Devices are registered as part of the registration process, and identities are generated on the Global IoT Gateway instance at the start. Following that, each device will begin and send the query region request (1st step of provisioning). The device will be registered on the regional IoT Gateway instance during this stage. After successfully registering a device in the Regional instance, the device's identification must be removed from the Global partition IoT Gateway instance.
We will utilize the deleteThing() function of the C2CIotClient class, which is supplied by the adapter service, to remove the device identification from the Iot core. For the deletion process, the deleteThing method will demand an object of IotThingRequest as an argument, which should be populated with the device's system_id and certificate data. Using the system_id supplied during the API call for deletion, we should retrieve the device information from the device database.


saveRequestSummary() – Save the request summary in database: When the user send a request for registration, it is routed to the request processor module, which validates the request against a set of constraints that have previously been defined for device registration. . A POST API is called from the request processor service to the registration service to save the request id and count in the table.
The saveRequestSummary method will receive an object of RegistrationRequestSummaryDto which consists of the request_id, total count of devices in the request and the creator field. We will save the data into the database and respond with a success code and success message after saving the data.



**Low-level software design**

<figure>
<img src="../../../assets/RegFlowFig3.png" width="1000" />
<figcaption>Low level software design</figcaption>
</figure>

***Device Registration Flow***

User should be able to register a group of devices or a single device by submitting a request to the C2C platform. You will require a set of headers to validate the user's legitimacy before submitting the request. You will be unable to send and register your devices if you provide unauthorized header values.
When you send the request, it is routed to the request processor module, which validates the request against a set of constraints that have previously been defined for device registration. If you make a bulk registration request, the processor module will divide it into small chunks of devices and send them to the registration module for further processing.
After receiving the device chunks, the registration module will assign each device a unique identification and store the data in a database. Following that, each device is sent to the certificate manager module for certificate creation. The certificate manager will generate certificates with AWSIot, assign them to each device, and return them to the registration module for further processing. The device with the certificate attached is then registered to the Iot Gateway, and the database is updated with the registered status to indicate that registration is complete. Device_id, device_type, and attestationMechanism are required fields for sending requests. The request processor will not accept any more fields during global device registration. If it detects a new field in the request, it will throw an error stating that extraneous keys are not permitted, and if any of the mandatory fields are missing, it will throw an error stating that required key not found.
Headers:  

* personaid:  personaid indicates the name of the individual who’s sending the list of devices for global registration. This field is not mandatory in device registration.
* api-key: api-key is an encoded 16-byte string.
* x-requestor: x-requestor is the name of the service, in this case REQUEST-PROCESSOR-SERVICE

These are the mandatory headers required for hitting the service. 

*Request Processor Service*: When we first send a request for device registration, it is routed to the DeviceController class. The header parameters are then validated, and the fields in the registration request are mapped into a DeviceRequestDto object.
Validations:

 * Request not null validation
 * Size of the request exceeded validation
 * Payload size validation
 * Validate the size of field device_id and check for invalid characters
 * Validate the device_type to the list of valid system names
 * Validate the attestationMechasim to the list of valid Attestation Mechanism

Following the validation of all cases, a unique request id is generated and saved to the t_registration_request_summary database, along with the total number of devices in the request. A POST API is called from the request processor service to the registration service to save the request id and count in the table. 
The device list will be divided into small groups and mapped to a list of DeviceChunkDto. The developer determines the size of the chunk based on the application. Each chunk of devices is then published to a queue in the global environment, and the user receives a response confirming that the request has now been submitted for registration, along with the request_id and message mentioned in the table above. Adapter based SQS interface is used for publishing and receiving messages to and from the queue.

*Device Registration Service*: The Device Registration service will listen to the same queue that the Request Processor Service publishes the DeviceChunkDto list to. When it first starts receiving DeviceChunks, it will verify to see if the device_id is present and if the device has already been registered in the global partition. If it's a duplicate device, we'll run the following operations in DeviceChunkDto.

 * Set the status to FAIL
 * Set errorMessage with appropriate error text (e.g.: Device is already registered)
 * Set errorFlag to true

If this is not the case, the status will be set to UNREG. If the device is in the IN_PROGRESS state, the same rules apply.
Following that, each device will be assigned a unique system id and the data will be stored in two tables, initially in the t_device table and later in the t_registration_request table. Duplicate device details will not be kept in the device table; instead, data regarding duplicate devices will be saved in the registration request table.

After the initial storing of device data each device will be send for certificate generation and i.e., published to a separate queue. The Certificate manager module will return the device, along with the new certificate, to a separate queue that the device registration module will be listening to.
The device will be registered to Iot Gateway after the certificate is received. We will use the adapter methods supplied by Team1 for thing creation, and our device will be successfully registered in the global partition. Following that, we will update the state and status column of device and registration request tables respectively with REGISTERED value and connection_url with a hardcoded Iot endpoint based on the environment. We will also add relevant certificate data to the certificate and certificate key tables.

*Certificate Manager Service*: When a device has to be registered into the IoT gateway, we may use the Certificate Manager service to produce a X.509 certificate on demand. The X.509 certificate is used to secure the communication. Using AWS Cloud, the platform should be able to create an X.509 certificate. Certificate based authentication is built by leveraging the X.509 public key infrastructure (PKI) standard. The certificate manager will listen to the queue to which the device registration service will send devices that need a certificate for registration. When the certificate manager gets a device, it will use the AWSIot class's createKeysAndCertificate () function to generate a new certificate for that device.
Following that, the certificate manager will store the certificate data in the DeviceChunkdto object and publish it to the certificate output queue.

**Low level design sequence diagram**

<figure>
<img src="../../../assets/RegFlowFig4.png" width="800" />
<figcaption>Request Processor Sequence diagram</figcaption>
</figure>

<figure>
<img src="../../../assets/RegFlowFig5.png" width="900" />
<figcaption>Device registration service Sequence diagram</figcaption>
</figure>

<figure>
<img src="../../../assets/RegFlowFig6.png" width="900" />
<figcaption>Device registration service regional sequence diagram</figcaption>
</figure>

<figure>
<img src="../../../assets/RegFlowFig7.png" width="1000" />
<figcaption>Certificate manager service Sequence diagram</figcaption>
</figure>

### <a id="_ClassDiagram"></a>2.1 Class Diagram

NA

### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA

## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

**External Dependencies**

1.	org.springframework.boot: spring-boot-starter-web
2.	org.springframework.cloud: spring-cloud-starter-config
3.	org.springframework.cloud: spring-cloud-starter-bootstrap
4.	org.springframework.boot: spring-boot-starter-actuator
5.	org.springframework.boot: spring-boot-starter-data-jpa
6.	org.springwork.boot: spring-boot-starter-test
7.	org.postgresql: postgresql
8.	org.modelmapper: modelmapper
9.	com.fasterxml.jackson.core: jackson-databind
10.	com.fasterxml.jackson.core: jackson-core
11.	org.projectlombok: lombok
12.	junit: junit
13.	org.slf4j: slf4j-api
14.	org.mockito: mockito-core
15.	commons-beanutils: commons-beanutils
16.	commons-codec: commons-codec
17.	org.springframework.boot: spring-boot-maven-plugin
18.	org.jacoco:jacoco-maven-plugin
19.	maven-surefire-plugin
20.	io.springfox: springfox-swagger2
21.	io.springfox: springfox-swagger-ui

**Internal Dependencies**

1.	Adapter used for registering device in AWS Iot Gateway: c2c_base_iot_aws_impl 
2.	Adapter used for publishing and receiving messages in AWS SQS: c2c_base_queue_sqs_impl, c2c_base_queue_intf 
3.	Adapter for all common components: c2c_base_common , common 


## <a id="_Databasedesign"></a>4. Database design

**Database Structure**

t_registration_request_summary

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
    <td>request_id</td>
    <td>UUID</td>
  </tr>
  <tr>
    <td>count</td>
    <td>integer</td>
  </tr>
</table>

t_device

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
    <td>device_id</td>
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
    <td>attestationMechansim</td>
    <td>String</td>
  </tr>
  <tr>
    <td>is_primary</td>
    <td>Boolean</td>
  </tr>
  <tr>
    <td>connection_url</td>
    <td>String</td>
  </tr>
  <tr>
    <td>ecu_type</td>
    <td>String</td>
  </tr>
  <tr>
    <td>state</td>
    <td>String</td>
  </tr>
  <tr>
    <td>error_message</td>
    <td>String</td>
  </tr>
  <tr>
    <td>created_by</td>
    <td>String</td>
  </tr>
  <tr>
    <td>updated_by</td>
    <td>String</td>
  </tr>
  <tr>
    <td>created_time</td>
    <td>Long</td>
  </tr>
  <tr>
    <td>updated_time</td>
    <td>Long</td>
  </tr>
</table>

t_registration_request

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
    <td>request_id</td>
    <td>UUID</td>
  </tr>
  <tr>
    <td>device_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>message_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>status</td>
    <td>String</td>
  </tr>
  <tr>
    <td>error_message</td>
    <td>String</td>
  </tr>
  <tr>
    <td>created_by</td>
    <td>String</td>
  </tr>
  <tr>
    <td>updated_by</td>
    <td>String</td>
  </tr>
  <tr>
    <td>created_time</td>
    <td>Long</td>
  </tr>
  <tr>
    <td>updated_time</td>
    <td>Long</td>
  </tr>
</table>

t_certificate

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
    <td>device_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>certificate</td>
    <td>String</td>
  </tr>
  <tr>
    <td>certificate_id</td>
    <td>String</td>
  </tr>
  <tr>
    <td>certificate_arn</td>
    <td>String</td>
  </tr>
  <tr>
    <td>credential</td>
    <td>String</td>
  </tr>
  <tr>
    <td>not_before</td>
    <td>Long</td>
  </tr>
  <tr>
    <td>not_after</td>
    <td>Long</td>
  </tr>
  <tr>
    <td>serial_no</td>
    <td>String</td>
  </tr>
   <tr>
    <td>subject</td>
    <td>String</td>
  </tr>
</table>

## <a id="_Applicationconfiguration"></a>5. Application configuration

*Device Request Processor*

* server.servlet.context-path: context path
* logging.level.root
* logging.file.name
* management.endpoints.web.exposure.include
* server.port: port
* spring.datasource.url: PostgreSQL url
* spring.datasource.username: PostgreSQL username
* spring.datasource.password: PostgreSQL password
* cloud.aws.credentials.access-key: Encrypted access key for Amazon Web services
* cloud.aws.credentials.secret-key: Encrypted secret key for Amazon Web services
* cloud.aws.region.static: Region name to be accessed in Amazon Web services.Datatype is String
* cloud.aws.sqs.queue-name: queue used by the application uses
* cloud.aws.chunked-device-queue-endpoint
* chunk-size
* max-device-limit
* max-payload-size
* regional-partition
* registration-request-summary-url
* server.compression.enabled
* apikey.secret: key for api authentication
* x-requestor: key for api authentication
* validate-schema-json-path
* maxAttempts-value: Retry Property
* delay-value: Retry Property
* multiplier-value: Retry Property
* maxDelay-value: Retry Property
* delay-value-publish: Retry Property

*Device Registartion Service*

* server.servlet.context-path: context path
* logging.level.root
* logging.file.name
* management.endpoints.web.exposure.include
* regional-partition
* server.port: port
* device.security.policy.wildcard.enable
* cloud.aws.region.static: Region name to be accessed in Amazon Web services.Datatype is String
* cloud.aws.credentials.access-key: Encrypted access key for Amazon Web services
* cloud.aws.credentials.secret-key: Encrypted secret key for Amazon Web services
* cloud.aws.certificate-request-queue: queue used by the application uses
* cloud.aws.chunked-device-queue: queue used by the application uses
* cloud.aws.certificate-response-queue: queue used by the application uses
* cloud.aws.chunked-device-queue-endpoint
* spring.datasource.url: PostgreSQL url
* spring.datasource.username: PostgreSQL username
* spring.datasource.password: PostgreSQL password
* spring.jpa.show-sql: PostgreSQL
* provisioning-query-processor-url
* regional-partition
* apikey.secret: key for api authentication
* x-requestor: key for api authentication
* server.compression.enabled: key for api authentication

*Certificate Manager*

* server.port: port
* server.servlet.context-path: context path
* logging.level.root
* logging.file.name
* cloud.aws.region.static: Region name to be accessed in Amazon Web services.Datatype is String
* cloud.aws.credentials.access-key: Encrypted access key for Amazon Web services
* cloud.aws.credentials.secret-key: Encrypted secret key for Amazon Web services
* cloud.aws.certificate-request-queue: queue used by the application uses
* cloud.aws.certificate-response-queue: queue used by the application uses
* management.endpoints.web.exposure.include

*Device Registartion Service Regional*

* server.servlet.context-pathcontext path
* logging.level.root
* logging.file.name
* management.endpoints.web.exposure.include
* server.port: port
* device.security.policy.wildcard.enable
* cloud.aws.region.static: Region name to be accessed in Amazon Web services.Datatype is String
* cloud.aws.credentials.access-key: Encrypted access key for Amazon Web services
* cloud.aws.credentials.secret-key: Encrypted secret key for Amazon Web services
* cloud.aws.chunked-device-queue: queue used by the application uses
* cloud.aws.chunked-device-queue-endpoint
* provisioning-query-processor-url
* spring.datasource.url: PostgreSQL url
* spring.datasource.username: PostgreSQL username
* spring.datasource.password: PostgreSQL password
* management.endpoints.web.exposure.include
* server.compression.enabled: key for api authentication
* apikey.secret: key for api authentication
* x-requestor: key for api authentication


## <a id="_AdditionalDetails"></a>6. Additional Details

**Logging mechanism**

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
* Uses randomness in the derivation of cryptographic keys
* Stores cryptographic keys securely
* Does not use banned APIs or unsafe functions

**Error handling**

Functional safety:

* Usage of try catch blocks in every important method so that the processor will not get terminated even if one method fails. Exceptions are caught and logged properly
* While publishing the messages to queues if a retriable exception is caught resilience retry mechanism is done for n times and if that also isn’t successful database is updated with proper error messages.
* In case of Json processing exception the message received will be directly saved into a database without further processing.
* Internal API invocation will be retried n times with a specific time interval for exceptions except json processing exception.
* Circuit breakers are implemented for proper rollback of all the process if any unexpected failure happening.


## <a id="_Howto"></a>7. How to

NA
