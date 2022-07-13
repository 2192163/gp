<center>

# **C2DSender Document** 

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


C2DSender is a project which listens to the inbound queue to which applications sends the standard internal messages. It is a module in the cloud to device flow. Main purpose of C2DSender is to send the messages from the applications to the device through AWS IoT. The features of C2DSender are listed below:

*	The incoming messages are validated first. If the mandatory fields are empty or null, C2Dsender sets the status field as INVALID and populates the property bag with error codes and sends it to storage processor as a communication core message. 
*	Only converted communication core messages are sent to the storage processor in async manner.
*	If the messages are not INVALID an expiration check is done based on the ttl field, time field of the message and the instant time at which message is processed. If it is expired C2Dsender sets the message’s status as EXPIRED, populates the property bag with its error code and sends it to the expiry queue as standard internal message itself and to the storage processor as a communication core message. Before sending the message to the expiry queue the target id and source id of the message is swapped. These messages are not sent to IoT topic
*	The messages that are valid and not expired are sent to device specific IoT topic. IoT topic is the system id field of the received message. Before sending the messages to IoT topic, ack_required flag is checked in the received message. If it is false or not present, C2DSender checks the ack flag for the message type field of the received message in the database using route config API. If acknowledgment flag is true in the database table, C2DSender adds the ack flag as true in the message before sending it to the IoT topic.
*	If the IoT topic/device is not present, the publishing to IoT fails.C2DSender sets the status of the message as DEVICE_NOT_FOUND and corresponding error codes is added to the communication core message and is sent to storage processor. If publishing to IoT fails due to some other exception, C2Dsender tries to send it to the IoT one more time.
*	If the C2Dsender fails to send the message to the storage processor, expiry queue or fails to retrieve the data using route config API call, C2Dsender sends the message to the retry processor. Retry processor sends the message back to the inbound queue for retrying the same message.


### <a id="_Scope"></a>1.1 Scope 

*	Incoming messages that come with mandatory fields as null or empty are set as INVALID and sent to c2d_storage_stream. Storage processor stores it in INVALID S3 bucket.
*	Expired messages are sent to the expiry queue to which message dispatcher listens. Message dispatcher routes it to the mapped streams and queues based on the message type and target id field of the message. Expired messages are also sent by C2DSender to the storage processor that stores the message in c2c messages S3 bucket and database table
*	Valid messages are sent to the IoT topic to which device is subscribed.C2DSender also sends it to the storage processor. Storage processor stores that message in c2c messages S3 bucket and database table. There will be no setting of the message status here.
*	In cases where the valid messages fail to be published to the IoT topic due to the absence of that topic, C2Dsender sets the status as DEVICE_NOT_FOUND and sends it to the storage processor. Storage processor stores that message in c2c messages S3 bucket and database table.


### <a id="_OutofScope"></a>1.2 Out of Scope 

C2DSender uses various modules for its working.

*	In the C2D flow C2Dsender uses route config API to retrieve the ack flag based on message type field of the incoming message.
*	C2Dsender sends the incoming messages after validating to storage processor module. Storage processor stores the valid, expired, device not found messages to a S3 bucket under c2d folder and also sends the messages to a database table. It stores the invalid messages to an invalid S3 bucket. 
*	C2DSender sends the expired messages to the message dispatcher module.


### <a id="_Assumption"></a>1.3 Assumption 

* C2DSender needs internal dependencies named c2c_base_queue_sqs_impl, c2c_base_stream_kinesis_impl, c2c_base_common and c2c_base_iot_mqtt_aws_impl for its working.These wrappers must be running for C2DSender to work
* C2DSender depends on other software modules for its working.Modules names c2c_commcore_msgstorage_pro,c2c_commcore_msgdispatcher_pro and c2c_commcore_routeconfig_api are essential for C2DSender to complete its flow.

## <a id="_Design"></a>2. Design

##### ARCHITECTURE:

C2DSender is the ending point of the C2Dflow.The standard Internal Messages from all applications are sent to c2d_inbound_queue. Applications can directly send messages to the c2d_inbound queue using SQS adapter or using C2DRequest API.C2DSender listens to this queue. All the received messages are sent to the c2d_storage stream after validations using Kinesis adapter. Message Storage processor (MSP) listens to this stream and stores the messages in database table and S3 bucket. The EXPIRED messages are sent to the expiry queue using SQS adapter. The expiry queue is listened by message dispatcher (MD) which routes these messages to its mapped queues and streams based on message type and target id field. C2DSender uses route config API to retrieve acknowledgment flag from the database based on the message type field of the message. The valid messages are sent to the AWS IoT using IoT adapter.

##### High level diagram
 <figure>
    <img src="../../../assets/C2D_FlowDiagram.png" width="700" />
		<figcaption>High Level Architecture Diagram</figcaption>
 </figure>

###### FLOWCHART:

 <figure>
	<img src="../../../assets/C2DSenderFlowChart.png" width="500" />
		<figcaption>FLOW CHART</figcaption>
 </figure>
		
* An INVALID check is done on the messages listened by the C2DSender.If the message is INVALID, it is sent to the storage processor. 
* If not an EXPIRY check is done on the message. If the messaged is EXPIRED, the status of the message is set as EXPIRED, error code is populated in the property bag, target ID and source ID is swapped, and the message is sent to the expiry queue. 
* If the message is not EXPIRED, there is a check for the ack flag in the property bag, if it is true in the property bag of the message, there will be a check for the device in the aws iot core. Device is the system Id field of the message. if it is not true, then C2DSender calls the routeconfig API to check if the ack is true in the message type database table. If it is true in the table, ack flag is added as true in the property bag of the message. After this only there will be a device check. 
* If the device is not found in the aws iot core, the message’s status is set as DEVICE_NOT_FOUND and sent to the storage stream. If device is present, the message is sent to the iot core. 
* In these flows, if publishing to the storage stream, expiry queue, aws iot core or calling the API fails, that message is sent to the retry processor for retry.
		
###### SEQUENCE DIAGRAM:

 <figure>
				<img src="../../../assets/C2DSenderSeqDiagram.png" width="700" />
				<figcaption>Low Level Sequence Diagram</figcaption>
 </figure>



### <a id="_ClassDiagram"></a>2.1 Class Diagram

|Sl No| Class | Functionality and Public Methods |  
| :------------- | :------------- | :------------ |
| 1| C2DMessageDriver| This class continuously receives data from the c2d inbound queue and invokes the listener. 
|||Methods: Init()-void: Initializes service queue client to listen to c2d inbound queue|     
| 2| C2DMessageListener |The Class C2DMessageListener validates incoming standard internal messages. It forward messages that are expired to expiry queue and valid to device specific topic in IoT core. And finally forwards every message to storage processor
|||Methods:onMessageReceived(StandardInternalMessage message)-boolean:process messages from inbound queue.|   
| 3| C2DIoTservice | C2DIoTService is a service class used to write messages to device specific IoT topic. It auto wires mqtt client and using this client it publishes to topic in IoT core. This class also checks the ack flag in the message, if it is not true or absent, it will check for the flag in the database using route config API. If any of it is true, the ack is set in the message and sent to the IoT core.
|||Methods:writeToMqttTopic(CommunicationCoreMessage c2cMessage)-void: This function creates mqtt configuration using system id. And using client it publishes to device specific topic in IoT core. | 
| 4| C2DSenderQueueWriterService| C2DSenderQueueWriterService is a service class used to publish expired standard internal messages to the expiry queue. It auto wires queue client and using it publishes to the queue. 
|||Methods:writeToQueue(StandardInternalMessage message)-void It publishes expired standard internal messages to expiry queue. Before and after publishing this method swaps the target id and source id of the message.|  
| 5|C2DSenderStreamWriterService | This is a service class used to publish communication core messages to the storage stream. It auto wires stream client and using this client publishes the messages.
|||Methods:writeToStream(String stream, CommunicationCoreMessage c2cMessage)-void: After receiving stream name and communication core message, this method publishes the message to the stream. And on C2CRetryException there will be n number of resilience retries. On further failure a mail is sent to the user via email. And on Fatal exceptions mail is sent to the user.|
| 6| AckInformationService | The Class AckInformationService is to retrieve the message type data from the database using route config API mainly to get the acknowledgment flag details.
|||Methods:findByMessageType(String messageType)-MessageType: This method is to retrieve the data based on message type given using Rest Template client.| 
| 7|RetryQueueWriterService| This is a service class used to publish standard internal messages which needs retry to the retry queue.
|||Methods:writeToRetryQueue(StandardInternalMessage standardInternalMessage)-void: After receiving queue name and retry message, using retry queue client retry message is published to the queue.|  
| 8|C2DSenderUtils| The Class C2DSenderUtils is a util class used to swap source id and target in a message.
|||Methods:swapSourceAndTargetId(StandardInternalMessage message)-void: swap target id and source id of the standard internal message given.|


 <figure>
	<img src="../../../assets/C2DSenderSDDClassDiagram.png" width="700" />
				<figcaption>Class Diagram</figcaption>
 </figure>


### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA

## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

###### Maven Dependencies:

*	org.springframework.boot: spring-boot-starter-web
*	org.springwork.boot: spring-boot-starter-test
*	org.springframework.boot: spring-boot-starter-actuator
*	org.springframework.cloud: spring-cloud-starter-config
*	org.springframework.cloud: spring-cloud-starter-bootstrap
*	com.amazonaws: aws-java-sdk-sns
*	org.mockito: mockito-core
*	junit : junit
*	org.springframework.boot: spring-boot-maven-plugin
*	org.jacoco:jacoco-maven-plugin

###### Internal Dependencies:

*	com.c2c: c2c_base_common
*	com.c2c.queue.client: c2c_base_queue_sqs_impl
*	com.c2c: c2c_base_stream_kinesis_impl
*	com.c2c.iot.mqtt: c2c_base_iot_mqtt_aws_impl





## <a id="_Databasedesign"></a>4. Database design

NA
    


## <a id="_Applicationconfiguration"></a>5. Application configuration

* aws.region=Region name to be accessed in Amazon Web services.Datatype is String
* aws.iot.endpoint=AWS IoT core endpoint to publish messages.Datatype is String.
* inbound-queue=The queue name to which C2DSender listens.Datatype is String.The name of the queue is {env}_cc_sq_c2d_inbound_queue
* expired-msg-queue=Queue name to which C2Dsender sends the EXPIRED messages.Datatype is String.The name of the queue is {env}_gb_cc_sq_d2c_expiry_queue
* retry-queue=Queue name to which C2DSender sends the messages to be retried.Datatype is String.The name of the queue is {env}_resilience_sqs_c2dsender
* message-storage-stream=Name of the stream to which C2Dsender sends the messages for storage.Input stream of the message storage processor.Datatype is String.The name of the stream is {env}_cc_c2c_c2d_kinesis_storage_stream
* topic-arn=arn:Topic name of the AWS SNS to which C2Dsender sends the failure notifications.Datatype is String
* spring.application.name=Name of the spring application
* baseurl=Base URL of route config API.Datatype is String
* getMessageUrl=API endpoint to get messagetype data.Datatype is String
* apiKey=Encoded route config api key as header for authorization .Datatype is String
* apiXRequestor=Name of the component which uses route config API.It is a header for authorization.Datatype is String
* apiContentEncoding=This field value as gzip will inform the server that it accept Gzip compression.Datatype is String
* server.compression.enabled=In order to enable or disable gzip compression. By enabling Gzip compression for an API application, the server will compress the response and send to the client and the client will decompress it.
* publish.buffer.time.high=High latency configuartion to publish in batches after this given time to the kinesis stream.Datatype is long
* publish.max.connection=Maximum number of connections to open to the back end. HTTP requests are sent in parallel over multiple connections.Datatype is long
* publish.ttl.multiplier=Multiplier used in the function to obtain the time to live for the record to be published to the stream.Datatype is int.
* queue.receive.messagecount=Message counts to be retrived at once while listening to the queue.Datatype is int
* retry.max.attempt=.Max attempts for retry.Datatype is int.


 
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

*	Usage of try catch blocks in every important method so that the processor will not get terminated even if one method fails. Exceptions are caught and logged properly
*	While publishing the messages to storage stream if a retriable exception is caught resilience retry mechanism is done for n times and if that also is not successful a mail is sent to the user regarding the same. If a fatal exception occur during publishing only email is sent to the user.
*	While sending the message to IoT if any exception is encountered other than the AWS IoT thing not being present, C2DSender retries to send the message one more time.
*	When an exception is encountered while publishing messages to the storage stream, expiry queue or while retrieving data using route config API, a C2CRetryException is thrown, and the message is sent to the retry processor module. The retry processor send the message back to the c2d_inbound_queue where the C2DSender again process that same message. If retriable exception is encountered again the same message is again sent to the retry processor. Retry processor will only sent the same message to the inbound queue the number of times we have configured it in the retry configuration table. After that count even if the message reaches retry processor no message is sent to the inbound queue.


List of all platforms wide error codes and their respective description are listed in the table below. Based on the error code, a consumer can take an action based on the severity of the error.
List of all platforms wide error codes and their respective description are listed in the table below. Based on the error code, a consumer can take an action based on the severity of the error.



## <a id="_Howto"></a>7. How to

NA
    

**NOTE** :: Acronyms and terms or concepts can be added in below section and it will be rendered as a tooltip in the document. 

| Acronym or term|   Definition |  
| :------------- | :------------ |
| C2DSender | Cloud to Device Sender |     
| MD |  Message Dispatcher|   
| MSP |  Message Storage Processor | 
|ack|   acknowledgment|  
| IoT | Internet of Things |
| S3 | Simple Storage Service | 
|SQS|  Simple Queue Service|  
| C2C | Cloud to Cloud |
| AOP | Aspect Oriented Programming|
