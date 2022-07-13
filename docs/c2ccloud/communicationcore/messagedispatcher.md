


<center>

	
# **Message Dispatcher Document ** 

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


Message Dispatcher is a project which listens to inbound stream to which device sends the communication core message from AWS IoT core. It is the starting point of the D2C flow.The features of MD (Message Dispatcher) are listed below.

* The incoming messages are validated first by MD. If the mandatory fields are empty or null, MD sets the status field as INVALID, populates the property bag with necessary error codes and sends it to storage processor.
* Messages are sent to the storage processor in an async manner. If while sending the message any C2CRetryException is encountered resilience retry is done for n times. On further failure, the failure will be notified.If a fatal exception is encountered retry will not happen but it will be notified.
* Based on the valid message’s message type field and target id field streams and queues mapped in the table are retrieved using route config API. The message is sent to these routed streams and queues. It is also sent to the storage processor. The communication core message sent by the device is converted to Standard Internal Message in MD and is published to the routed streams and queues. All the database calls are done using route config API.
* If no routes are found for an incoming message, the status field is set as ROUTE_NOT_FOUND, error code is added to the message and sent to storage processor.
* If Message Dispatcher is not able to publish the message to none of the mapped routes, the status is set as ROUTE_NOT_AVAILABLE, error code is added and sent to storage processor. Unavailable streams status is set as NOT_AVAILABLE in table using route config API and it will be notified.
* If the route received is a single stream or a single queue MD sends it in an async manner to increase the performance.
* If any incoming messages are in the wrong JSON format, the message is sent as a JSON string to storage processor for analysis purpose.
* Message dispatcher also listens to the expiry queue. C2Dsender sends the expired messages to this queue. Expired messages are routed to the mapped routes but not to the storage processor.


### <a id="_Scope"></a>1.1 Scope 


* Incoming messages that come with mandatory fields as null or empty are set as INVALID and sent to storage processor. Storage processor stores it in INVALID S3 bucket.
* Valid messages with the field message type and target Id not mapped to any routes in the database is set as ROUTE_NOT_FOUND by MD and sent to storage processor. Storage processor stores that message in c2c messages S3 bucket and database table.
* Valid messages with the field message type and target Id mapped to any valid routes in the database are sent to those mapped streams and queues and sent to storage processor. Storage processor stores that message in c2c messages S3 bucket and database table. There will be no setting of the message status here.
* Valid messages with the field message type or target Id mapped to an invalid stream, message dispatcher tries to send it to that stream. If a fatal exception is encountered no retry will happen but it will send an email to the user stating the failure. If a C2CRetryException is encountered MD using kinesis adapter will retry to publish for n times. After retrying if it fails MD sends a mail to the user stating the failure and sets the route status in the table as NOT_AVAILABLE using route config API. Message dispatcher sets the status of the message as ROUTE_NOT_AVAILABLE and sends it to storage processor for storing in c2c messages S3 bucket and table.
* Valid messages with the field message type or target Id mapped to an invalid queue, message dispatcher tries to send it to that queue. After failure message dispatcher sets the status of the message as ROUTE_NOT_AVAILABLE and sends it to storage processor for storing in c2c messages S3 bucket and table.
* Valid messages with the field message type mapped to an invalid queue and target id mapped to a valid stream. Message dispatcher sends the message to the stream and tries to send it to that queue. After failure message dispatcher does not set the status of the message as ROUTE_NOT_AVAILABLE, the status will be as it is as ROUTE_NOT_AVAILBLE status is set when none of the mapped streams and queues are valid. MD sends the message to storage processor for storing in c2c messages S3 bucket and table.
* When message dispatcher receives an incorrect JSON format message, it sends it as a JSON string to storage processor. Storage processor stores it in INVALID S3 bucket.


### <a id="_OutofScope"></a>1.2 Out of Scope 


Message Dispatcher uses various modules for its working.

* In the D2C flow message dispatcher uses route config API to retrieve the routes mapped to the incoming message’s message type and target id field. It also uses api to update the route status of a stream to NOT_AVAILABLE in the message type table and application table.
* MD sends the incoming messages after validating and routing to storage processor module. Storage processor stores the valid messages to a S3 bucket and to a database table. It stores the invalid messages to an invalid S3 bucket. Message dispatcher sends messages coming with incorrect JSON format also to the storage processor as a JSON string. Storage processor stores it as a string in invalid S3 bucket.
* Message dispatcher listens to the expiry queue to which C2DSender module sends the expired messages. MD routes these messages to its mapped streams and queues but not to the storage processor.


### <a id="_Assumption"></a>1.3 Assumption 

* MessageDispatcher needs internal dependencies named c2c_base_queue_sqs_impl, c2c_base_stream_kinesis_impl and c2c_base_common for its working.These wrappers must be running for MD to work.
*  MessageDispatcher depends on other software modules for its working.Modules names c2c_commcore_msgstorage_pro,c2c_commcore_c2dsender_pro and c2c_commcore_routeconfig_api are essential for MD to complete its flow.



## <a id="_Design"></a>2. Design


###### ARCHITECTURE:

Message Dispatcher is the starting point of the D2C flow. The communication core message from the device is sent to the d2c_inbound_stream from IoT. Message Dispatcher listens to this stream. After validation, the valid messages are routed to the mapped streams and queues which are the starting points of other applications. The mapped routes are obtained from the database with the use of route config API. The data is retrieved from the database based on message’s message type and target Id. The incoming messages are all sent to d2c_message_storage_stream which is listened by storage processor. Messages are published to stream using kinesis adapter and to queue using SQS adapter. Message Dispatcher also listens to an expiry queue to which C2DSender sends the expired messages. MD routes these messages to its mapped streams and queues.
	
<figure>
<img src="../../../assets/D2CFlowDiagram.png" width="700" />
<figcaption>High Level Architecture Diagram</figcaption>
</figure>
		
###### Flow Chart:

* Message Dispatcher listens to the inbound stream and expiry queue continuously. 
* If the communication core messages listened from the stream is of incorrect JSON format, it is sent as a JSON string to the d2c storage stream.
* If it is of correct JSON format the message is validated. If the validation fails, the status of the message is set as INVALID and the required error codes are added in the property bag of the message and is sent to the storage stream. 
* If it is a valid message, the mapped routes are obtained based on the message type and target id of the message with the help of route config API. The streams obtained are put in streamNameSet and queues are put in queueNameSet.
* If both streamNameSet and queueNameSet are empty, the status of the message is set as ROUTE_NOT_FOUND and error code is added in the property bag of the message and is sent to the storage stream.
* If streamNameSet is empty and queueNameSet has one queue, the message is sent to the queue in async manner. If publishing fails the message status is set as ROUTE_NOT_AVAILABLE, populates the message with error code and sent to the storage stream, otherwise the message is sent to the storage stream only.
* If queueNameSet is empty and streamNameSet has one entry, the message is published to the stream in async manner. If publishing fails because of retry exception, resilience retry happens and on further failure, notifies admin with email and sets the route status as NOT_AVAILABLE using route config API.The message is set as ROUTE_NOT_AVAILABLE and error code is added. The message is sent to storage processor even if it fails or not.
* After these 2 cases If the streamNameSet is not empty, message is sent to those streams in sync manner. If publishing fails,the method returns false, the failure notification is sent, and route status is updated in the table using routeconfig API. The message is sent to the storage stream. If publishing is successful, the method returns true.
* If queueNameSet is not empty, the message is sent to those mapped queues. If publishing fails returns false or else the method returns true. Based on the return values if atleast one of them is not true, the status of the message is set as ROUTE_NOT_AVAILABLE and the error code is added. The messages are sent to the storage stream. 
* The standard internal messages received from the expiry queue is routed to the mapped routes but not to the message storage stream. The expired messages goes through the same methods as that received from the stream except the validation parts.

<figure>
<img src="../../../assets/MessageDispatcherFlowChart.png" width="700" />
<figcaption>Flow Chart</figcaption>
</figure>

###### Sequence Diagram:
	

<figure>
<img src="../../../assets/MessageDispatcherSequeneceDiagram.png" width="700" />
<figcaption>Low Level Sequence Diagram</figcaption>
</figure>





### <a id="_ClassDiagram"></a>2.1 Class Diagram

<figure>
<img src="../../../assets/MessageDispatcherClassDiagram.png" width="700" />
<figcaption>Class Diagram</figcaption>
</figure>
		
|Sl No| Class | Functionality and Public Methods |  
| :------------- | :------------- | :------------ |
| 1| MessageProcessor| Processes C2CMessages from the D2C inbound stream and does the validation and sent it to the storage stream and also calls the method for routing to the mapped streams and queues if the message is valid. Sends corrupted messages to storage stream. 
|||Methods: processMessage(CommunicationCoreMessage c2cMessage)-void: process messages from the inbound stream|
|||processCorruptedMessage(String message)-void:process incorrect JSON format messages as a string from inbound stream.|
| 2| ExpiryQueueListener |The Class ExpiryQueueListener is to listen messages from expiry queue and to invoke the method to route to mapped routes based on target id and message type of StandardInternalMessage fields.
|||Methods:onMessageReceived(StandardInternalMessage standardInternalMessage)-void:process messages from expiry queue.|   
| 3| D2CInboundStreamReaderService | Continuously receives Device Data from D2C inbound stream and invokes the processor class.
|||Methods:subscribeToStream()-void:to subscribe to the inbound stream | 
| 4| ExpiryQueueListenerService|  Continuously receives data from the expiry queue and invokes the listener class.
|||Methods:listen()-void: To invoke the listener class|  
| 5|MessageRoutingService | The Class MessageRoutingService is for routing the messages mapped to queues and streams based on targetId and messageType.The routes mapped is obtained through api calls.This class also sets the message status as ROUTE_NOT_FOUND and populates error code in property bag when no routes are mapped to the message type and target id and sets the status as ROUTE_NOT_AVAILABLE when all the mapped routes are invalid.
|||Methods:publishToRoute(CommunicationCoreMessage c2cMessage, StandardInternalMessage standardInternalMessage)-int:Method which calls the api method and finds the mapped routes and sents it for publishing|
| 6| MappedQueuesWriterService | For writing messages to given queues in async and sync manner.
|||Methods:writeToSingleQueue(String queue,CommunicationCoreMessage c2cMessage, StandardInternalMessage standardInternalMessage)-void: publishing messages to queue in async| 
||| writeToQueue(String queue, StandardInternalMessage standardInternalMessage)-boolean: publishing messages to queue in sync| 
| 7|StorageAndMappedStreamsWriterService| The Class StorageAndMappedStreamsWriterService writes the C2CMessage to the stream for both, routes coming from Database and to storage processor stream and if any of them fails, retry mechanism happens and on further failure email will be sent to the user and streams which are not valid will be set to NOT_AVAILABLE status via api method call.
|||Methods:writeToSingleStream(String stream,CommunicationCoreMessage c2cMessage, StandardInternalMessage standardInternalMessage)-void: publishing messages to stream in async|  
|||writeToStream(String stream, StandardInternalMessage standardInternalMessage)-boolean: publishing messages to stream in sync|
|||storeMessage(CommunicationCoreMessage c2cMessage)-void: sent the message to storage stream.|
|||storeCorruptedMessage(String c2cMessage)-void: sent the Json exception messages to storage stream as JSON string.|  


		



### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA
    


## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

###### Maven Dependencies:

* org.springframework.boot: spring-boot-starter-parent
* org.springframework.boot: spring-boot-starter-web
* org.springwork.boot: spring-boot-starter-test
* junit : junit
* org.springframework.boot: spring-cloud-starter-actuator
* org.springframework.cloud: spring-cloud-starter-config
* org.springframework.cloud: spring-cloud-starter-bootstrap
* com.amazonaws: aws-java-sdk-sns
* org.mockito: mockito-core
* org.mockito: mockito-inline
* org.springframework.boot: spring-boot-maven-plugin
* org.jacoco:jacoco-maven-plugin

###### Internal Dependencies:

* com.c2c: c2c_base_common
* com.c2c.queue.client: c2c_base_queue_sqs_impl
* com.c2c: c2c_base_stream_kinesis_impl
    


## <a id="_Databasedesign"></a>4. Database design

NA
    


## <a id="_Applicationconfiguration"></a>5. Application configuration

* aws.credentials.access-key:Encrypted access key for Amazon Web services 
* aws.credentials.secret-key:Encrypted secret key for Amazon Web services
* region:Region name to be accessed in Amazon Web services.Datatype is String
* d2cInboundStreamName:Name of the stream to which message dispatcher subscribes.Datatype is String. Name of the stream is {env}_cc_d2c_inbound_stream.
* d2cInboundStreamApplication:Consumer name of the stream to which message dispatcher is subscribed.Datatype is String
* storageStreamName:Name of the stream to which message dispatcher sends the messages for storage.Input stream of the message storage processor.Datatype is String. Name of the stream is {env}_cc_c2c_d2c_kinesis_storage_stream.
* expiryQueue:Name of the queue to which message dispatcher subscribes for expired messages.Datatype is String. Name of the queue is {env}_cc_sq_d2c_expiry_queue.
* topic-arn=arn:Topic name of the AWS SNS to which message dispatcher sends the failure notifications.Datatype is String
* spring.main.allow-bean-definition-overriding: to enable or disable bean creation overriding
* spring.application.name : Name of the spring application
* baseurl:Base URL of route config API.Datatype is String
* getMessageUrl:API endpoint to get messagetype data.Datatype is String
* getApplicationUrl:API endpoint to get application data.Datatype is String
* applicationRouteToNotAvailabaleUrl:API endpoint to update application route status.Datatype is String
* messageRouteToNotAvailabaleUrl:API endpoint to update messagetype route status.Datatype is String
* apiKey:Encoded route config api key as header for authorization .Datatype is String
* apiXRequestor:Name of the component which uses route config API.It is a header for authorization.Datatype is String
* apiContentEncoding:This field value as gzip will inform the server that it accept Gzip compression.Datatype is String
* server.compression.enabled:In order to enable or disable gzip compression. By enabling Gzip compression for an API application, the server will compress the response and send to the client and the client will decompress it.
* publish.buffer.time.zero:Low latency configuration to publish without delay to the kinesis stream.Datatype is long
* publish.buffer.time.high:High latency configuartion to publish in batches after this given time to the kinesis stream.Datatype is long
* publish.max.connection:Maximum number of connections to open to the back end. HTTP requests are sent in parallel over multiple connections.Datatype is long
* publish.ttl.default:Default time to live of the record to be published to stream.Datatype is long.
* publish.ttl.multiplier:Multiplier used in the function to obtain the time to live for the record to be published to the stream.Datatype is int.
* queue.receive.messagecount:Message counts to be retrived at once while listening to the queue.Datatype is int

 
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
*	While publishing the messages to streams if a retriable exception is caught resilience retry mechanism is done for n times and if that also is not successful further updates are made in the table for that route and a mail is sent to the user regarding the same. If a fatal exception is occurred a mail is sent to the user stating the failure.
*	When messages with wrong JSON format are read from the stream, message dispatcher sends it as a JSON string to storage processor which stores it in the invalid s3 bucket.

List of all platforms wide error codes and their respective description are listed in the link below. Based on the error code, a consumer can take an action based on the severity of the error.

   

## <a id="_Howto"></a>7. How to

NA
    
   | Acronym or term|   Definition |  
| :------------- | :------------ |
 | MD |  Message Dispatcher|   
| MSP |  Message Storage Processor | 
| C2DSender | Cloud to Device Sender |     
| IoT | Internet of Things |
| S3 | Simple Storage Service | 
|SQS|  Simple Queue Service|  
| C2C | Cloud to Cloud |
| AOP | Aspect Oriented Programming|
| D2C | Device To Cloud|
| AWS | Amazon Web Services|
