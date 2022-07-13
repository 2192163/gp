
<center>

# **RouteConfig API Document** 

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


Route Config API project does basic crud operations with message type and application. It creates message type and application. It also creates route for it based on the id of message type or application. MD calls Route API to get the application or message type info along with route details. A single message type or application can have multiple routes. Route type can be either stream or queue. Apart from this it also gets application or message type details based on id, update and deletion is also performed on application, message type and routes. C2D sender calls route api for getting the acknowledgement flag. MD can update the route status to not available by calling this Api if route is mapped to an invalid stream. Route api can make the status as available when the stream is available. Message type and application will be cached when getMessage by msgType or getApplication by application name is called and when adding routes to existing message type or updating message type, application, or routes, then its message type or application will be evicted from the cache. 

##### High level diagram
 <figure>
    <img src="../../../assets/RouteConfigFlowDiagram.png" width="500" />
		<figcaption>High Level Architecture Diagram</figcaption>
 </figure>


### <a id="_Scope"></a>1.1 Scope 



*	Expose an end point to create an application. 
*	Expose an end point to get an application by applicationId.
*	Expose an end point to get an application by applicationName. 
*	Expose an end point to delete an application by applicationName. 
*	Expose an end point to get All applications. 
*	Expose an end point to update application description. 
*	Expose an end point to create a message type. 
*	Expose an end point to get a message type by msgTypeId.
*	Expose an end point to get a message type by msgtype. 
*	Expose an end point to update acknowledgement. 
*	Expose an end point to get All message types. 
*	Expose an end point to delete an message type by msgType. 
*	Expose an end point to create an application route. 
* 	Expose an end point to get application routes in given  applicationId. 
*	Expose an end point to update application route. 
*	Expose an end point to get All applications routes. 
*	Expose an end point to delete application route. 
*	Expose an end point to update route status of application route. 
*	Expose an end point to create a message route. 
*	Expose an end point to get message routes in given  msgTypeId.
*	Expose an end point to update application route. 
*	Expose an end point to get All message routes. 
*	Expose an end point to update route status of message route. 
*	Expose an end point to delete message route. 



### <a id="_OutofScope"></a>1.2 Out of Scope 



### <a id="_Assumption"></a>1.3 Assumption 

NA

## <a id="_Design"></a>2. Design

##### ARCHITECTURE:

**Sequence diagram**

<figure>
				<img src="../../../assets/Route_Application.png" width="700" />
				<figcaption>Low Level Sequence Diagram for Application</figcaption>
 </figure>

<figure>
				<img src="../../../assets/Route_ApplicationRoute.png" width="700" />
				<figcaption>Low Level Sequence Diagram for ApplicationRoute</figcaption>
 </figure>

<figure>
				<img src="../../../assets/Route_MessageType.png" width="700" />
				<figcaption>Low Level Sequence Diagram for MessageType</figcaption>
 </figure>

<figure>
				<img src="../../../assets/Route_MessageRoute.png" width="700" />
				<figcaption>Low Level Sequence Diagram for MessageRoute</figcaption>
 </figure>
                
### <a id="_ClassDiagram"></a>2.1 Class Diagram
</figure>
		<figure>
				<img src="../../../assets/RouteConfigClass_Diagram.png" width="900" />
				<figcaption>Class Diagram</figcaption>
 </figure>



### <a id="_InterfaceDetails"></a>2.2 Application Interface Details

NA
    


## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies

**Maven Dependencies**

*	org.springframework.boot: spring-boot-starter-web 
*	org.springframework.cloud: spring-cloud-starter-config 
*	org.springframework.cloud: spring-cloud-starter-bootstrap 
*	org.springframework.boot: spring-boot-starter-data-jpa 
*	org.springwork.boot: spring-boot-starter-test 
*	org.postgresql : postgresql 
*	org.modelmapper : modelmapper 
*	com.fasterxml.jackson.core: jackson-databind 
*	com.fasterxml.jackson.core: jackson-core 
*	io.springfox: springfox-bean-validators 
*	org.projectlombok : lombok 
*	junit : junit 
*	org.mockito: mockito-core 
*	org.springframework.boot: spring-boot-maven-plugin 
*	org.jacoco:jacoco-maven-plugin 
*	maven-surefire-plugin 
*	com.google.code.gson: gson 
* 	org.springframework.boot: spring-boot-starter-data-redis 
*	org.springframework.data: spring-data-redis 
*	redis.clients: jedis 
*	org.springframework.data: springfox-swagger2 
*	io.springfox : springfox-swagger2 
*	io.springfox : springfox-swagger-ui 

**Internal Dependencies**

*	com.c2c: c2c_base_common




    


## <a id="_Databasedesign"></a>4. Database design



#### TABLE NAME: t_message_type  ####

| Column Name |   Data type |  
| :------------- | :------------ |
| msg_type_id  | bigint  |     
| msg_type  |  NVARCHAR (60) |   
| created_by |  NVARCHAR (25)  | 
|created_time|   Long | 
| updated_by  |  NVARCHAR (25)  | 
|updated_time|   NVARCHAR (25) |  

##### TABLE NAME: t_application #####

| Column Name      |   Data type |  
| :-------------   | :------------ |
| application_id   | bigint  |     
| application_name |  NVARCHAR (50) |   
| application_description  |  NVARCHAR (200)  | 
|created_by |   NVARCHAR (25)  | 
| created_time |  bigint  | 
|updated_by |   NVARCHAR (25) |  
|updated_time |   bigint  |   


##### TABLE NAME: t_application_route #####

| Column Name      |   Data type     |  
| :-------------   | :------------   |
| application_id   | integer         |     
| route            |  NVARCHAR (255)  |   
| route_type       |  NVARCHAR (25) | 
| route_status     |  NVARCHAR (25)  | 
|Created_by        |   NVARCHAR (25) | 
| created_time     |  bigint         | 
|updated_by        |   NVARCHAR (25) |  
|updated_time      |   bigint        | 


##### TABLE NAME: t_message_route #####

| Column Name      |   Data type     |  
| :-------------   | :------------   |
| msg_type_id  | integer         |     
| route            |  NVARCHAR (80)  |   
| route_type       |  NVARCHAR (25) | 
| route_status     |  NVARCHAR (25)  | 
|Created_by        |   NVARCHAR (25) | 
| created_time     |  bigint         | 
|updated_by        |   NVARCHAR (25) |  
|updated_time      |   bigint        | 
 


## <a id="_Applicationconfiguration"></a>5. Application configuration


*	spring.datasource.url=Data source url
*	spring.datasource.username=Data source username
*	spring.datasource.password=Decrypted password for datasource
*	spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
*	spring.jpa.show-sql=true
*	spring.jpa.hibernate.ddl-auto=none
*	redis.hostname=Redis host name
*	redis.port=Redis Port
*	spring.cache.type=Cache type used
*	server.servlet.context-path=Context path for routeconfig api
*	apiKey.secret=Api key for the application
*	server.compression.enabled Inorder to enable or disable gzip compression. By enabling Gzip compression for an API application, the server will compress the response and send to the client and the client will decompress it.
   

 
## <a id="_AdditionalDetails"></a>6. Additional Details

**API**

***(CreateApplicationDto body)-Creates Application***

When the end point for creating application is called, it is first routed to ApplicationController class. The fields are validated, Fields in the request is mapped to  CreateApplicationDto. In the service class fields are validated. 
<br>
Validations: 

* applicationName cannot be null or empty. 
* applicationDescription cannot be null or empty. 
* createdBy cannot be null or empty. 

After validations application will be saved to t_application table in route_config schema   of commcore database. If validation failed, then corresponding error code and error message are sent to the user.  

###### Prototype:

createApplication  <br>
 (<br>
IN  CreateApplicationDto body, <br>
OUT ApplicationDto applicationDto 
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>CreateApplicationDto </td>
    <td>It consists of object of CreateApplicationDto  </td>
  </tr>
  <tr>
    <td>out</td>
    <td>ApplicationDto </td>
    <td>Response will be consisting applicationDto  </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns applicationDto. <br>
For failure, returns error code and error message.  
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/application  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>POST </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{ <br>
"applicationName ": "string", <br>
"applicationDescription": "string", <br>
"createdBy": "string", <br>
}  </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> {  <br>
“applicationId”: int,  <br>
"applicationName ": "string",  <br>
"applicationDescription": "string",  <br>
"createdBy": "string",  <br>
“createdTime”:  long , <br>
"updatedBy": "string",  <br>
“updatedTime”:  long  <br>
} 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td> 
{  <br>
"errorCode": "10022",  <br>
“errorMessage”: “application name cannot be blank”  <br>
}  <br>
{  <br>
"errorCode": "10028",  <br>
"errorMessage": "application description cannot be blank"  <br>
}  <br>
{ <br>
" errorCode ": " 10023 ",  <br>
" errorMessage ": " created by cannot be blank"  <br>

}<br>
</td>
  </tr>
</table>  <br><br>


***getApplication(int applicationId)-Get Application by id***

When the end point for get Application is called, it is first routed to  ApplicationController class. It will return the application in the given id. 


ApplicationDto :

| Attribute Name   |   Data type     |  
| :-------------   | :------------   |
| applicationId     | int             |
| applicationName  | String          |     
| applicationDescription  |  String  |   
| createdBy        |  String         | 
| createdTime       | Long           |
| updatedBy        | String          |
| updatedTime      | Long            |
<br>

###### Prototype:


getApplication<br>
 (<br>
IN int applicationId,<br>
OUT ApplicationDto applicationDto<br>
);
<br>

###### Parameters:

<table>
  <tr>
    <td>in</td>
    <td>applicationId</td>
    <td>Unique applicationId</td>
  </tr>
  <tr>
    <td>out</td>
    <td>ApplicationDto</td>
    <td>Response will be consisting of an application with its route configurations. </td>
  </tr>
</table><br>


###### Returns:

On success, returns ApplicationDto <br>
For failure, returns error code and error message. 
<br>
<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/application/{applicationId}</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td>{ <br>
"applicationName ": "string",<br> 
"applicationDescription": "string",<br> 
"createdBy": "string",<br> 
“createdTime”:  long ,<br>
“applicationRouteEntity”:[  <br>
“applicationId: Integer”, <br>
“route”: "string", <br>
“routeType”: "string", <br>
routeStatus: "string", <br>
“createdBy”: "string", <br>
“createdTime”: Long <br>
“updatedBy”: "string", <br>
“updatedTime”: Long <br>
]<br>
     } <br>


</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
    "errorCode": "10031",<br> 
    “errorMessage”: “application not found” <br>  
} 
</td>
  </tr>
</table>  <br><br>

***findByApplicationName(String applicationName) – Get Application by Name***

When the end point for findByApplicationName(String applicationName) is called,It is first routed to Application Controller class. It will return the application in the 
given name. 


Application:

| Attribute Name   |   Data type     |  
| :-------------   | :------------   |
| applicationId     | int             |
| applicationName  | String          |     
| applicationDescription  |  String  |   
| createdBy        |  String         | 
| createdTime       | Long           |
| updatedBy        | String          |
| updatedTime      | Long            |
<br>

###### Prototype:

findByApplicationName <br>
 (<br>
IN String applicationName,,<br>
OUT Application application,<br>
);
<br>

###### Parameters:

<table>
  <tr>
    <td>in</td>
    <td>applicationName </td>
    <td>Unique application name </td>
  </tr>
  <tr>
    <td>out</td>
    <td>Application</td>
    <td>Response will be consisting of an application with its route configurations.</td>
  </tr>
</table><br>


###### Returns:

On success, returns Application <br>
For failure, returns error code and error <br>message. 
<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/application/name/{applicationName}</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td>{ <br>
"applicationName ": "string",<br> 
"applicationDescription": "string",<br> 
"createdBy": "string",<br> 
“createdTime”:  long ,<br>
“applicationRouteEntity”:[<br>
{<br>
“applicationId: Integer”, <br>
“route”: "string", <br>
“routeType”: "string", <br>
routeStatus: "string", <br>
“createdBy”: "string", <br>
“createdTime”: Long <br>
“updatedBy”: "string", <br>
“updatedTime”: Long <br>
}<br>
]<br>
     } <br>

  

</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
    "errorCode": "10031",<br> 
    “errorMessage”: “application not found” <br>  
} 
</td>
  </tr>
</table>  <br><br>

***updateApplication (UpdateApplicationDto  body) -Update Application description ***

When end point for updateApplication(UpdateApplicationDto body) is called, it is first routed to Application Controller, fields are validated, fields in the request is mapped to UpdateApplicationDto. This endpoint will update the application description. In the service class, fields are validated. 
<br>
Validations: 

* applicationName cannot be null or empty. 
* applicationDescription cannot be null or empty. 
* updatedBy cannot be null or empty. 

After validations application will be saved to t_application table in route_config schema   of commcore database. If validation failed, then corresponding error code and error message are sent to the user.  

###### Prototype:


updateApplication  <br>
 (<br>
IN UpdateApplicationDto updateApplicationDto,<br>
OUT String, 
Parameters:
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>UpdateApplicationDto </td>
    <td>It consists of object of UpdateApplicationDto </td>
  </tr>
  <tr>
    <td>out</td>
    <td>String  </td>
    <td>Response will be a string </td>
  </tr>
</table><br>


###### Returns:

On success, returns a string ‘Application updated successfully’ <br>
For failure, returns error code and error message. <br>
<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/application  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>PUT  </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{ <br>
"applicationName ": "string", <br>
"applicationDescription": "string", <br>
"updatedBy": "string", <br>
}  </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> “Application updated successfully”
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td> 
{ <br>
“errorCode": "10031", <br>
" errorMessage ": “application not found” <br>
} <br>
{<br>
    "errorCode": "10022", <br>
    " errorMessage ": " application name cannot be blank found" <br>
} <br>
{ <br>
"errorCode": "10028", <br>
" errorMessage ": “application description cannot be blank” <br>
} <br>
{ <br>
    "errorCode": "10024", <br>
    " errorMessage ": " updated by cannot be blank" <br>
} 

 
</td>
  </tr>
</table>  <br><br>


***getAllApplication ()***

When the end point for getAllApplication() is called, it is first routed to Application Controller class. It will return the applications. 

###### Prototype:


getAllApplication  <br>
 (<br>
OUT List<ApplicationDto> applicationDto <br>
);
<br>

###### Parameters:

<table>
  <tr>
    <td>out</td>
    <td>List<ApplicationDto>  </td>
    <td>Response will be a list of ApplicationDto</td>
  </tr>
</table>
<br>

###### Returns:

On success, returns ApplicationDto ,<br>
For failure, returns error code and error message.  
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/applications</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> [<br>{ <br>
"applicationName ": "string", <br>
"applicationDescription": "string", <br>
"createdBy": "string", <br>
“createdTime”:  long ,<br>
applicationRouteEntity: [ <br>{<br>
“applicationId”: integer, <br>
“route”: "string", <br>
“routeType: "string", <br>
“routeStatus”:” string”, <br>
“createdBy”: "string", <br>
“updatedBy”: "string", <br>
“createdTime”: Long, <br>
“updatedTime”:  Long <br>
} <br>
] <br>
} <br>
  

</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
    "errorCode": "10031",<br> 
    “errorMessage”: “application not found” <br>
} 
</td>
  </tr>
</table>  <br><br>



***deleteApplication (String applicationName) – Delete application by name***

 When deleteApplication(String applicationName) method is called, application will be deleted. 

###### Prototype:


deleteByApplicationName  <br>
 (<br>
IN String applicationName  <br>
OUT String 
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>applicationName </td>
    <td>Unique application name </td>
  </tr>
  <tr>
    <td>out</td>
    <td>String  </td>
    <td>Response will a String</td>
  </tr>
</table>
<br>

###### Returns:

On success, return ‘‘Application deleted successfully’'<br>
For failure, returns error code and error message.   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/application/name/{applicationName} </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>DELETE  </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> ‘Application deleted successfully’ 

</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
    "errorCode": "10031",<br> 
    “errorMessage”: “application not found” <br>
} 
</td>
  </tr>
</table>  <br><br>

***(CreateMsgTypeDto body)-Creates Message Type***

 When the end point for creating msg type is called, it is first routed to MessageType Controller class. The fields are validated, Fields in the request is mapped to CreateMsgTypeDto. In the service class, fields are validated. <br>
Validations: 

* msgType cannot be null or empty 
* CreatedBy cannot be null or empty 

After validations message type will be saved to t_message_type table in route_config schema of commcore database. If validation failed, then corresponding error code and error message is sent to the user 

###### Prototype:


createMessageType  <br>
 (<br>
IN  CreateMessageTypeDto body,   <br>
OUT MessageTypeDto messageTypeDto
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>CreateMessageTypeDto </td>
    <td>It consists of object of CreateMessageTypeDto </td>
  </tr>
  <tr>
    <td>out</td>
    <td>MessageTypeDto</td>
    <td>Response will be consisting messageTypeDto </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns MessageTypeDto <br>
For failure, returns error code and error message.   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messagetype </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>POST </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{ <br>
"msgType ": "string", <br>
"createdBy": "string", <br>
} </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> { <br>
"msgTypeId ": "string", <br>
"msgType": "string",<br> 
"createdBy": "string",<br> 
“createdTime”:  long, <br>
“updatedBy”: "string", <br>
“updatedTime”: "string" <br>
 
} 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10025", <br>
“errorMessage”: “msg type cannot be blank” <br>
     }<br>
{ <br>
" errorCode ": " 10023 ", <br>
" errorMessage ": " created by cannot be blank" <br>
}<br>
</td>
  </tr>
</table>  <br>

***getMessage (int msgTypeId)-Get messagetype by msgTypeId***

When the end point for getMessageTypeById(String msgTypeId) is called, it is first routed to MessageType Controller class. It will return the message type in the given id.  <br><br>

###### Prototype:


getMessageTypeById ( <br>
 (<br>
IN int msgTypeId,    <br>
OUT MsgTypeDto msgTypeDto 
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>msgTypeId </td>
    <td>Unique msgTypeId  </td>
  </tr>
  <tr>
    <td>out</td>
    <td>MessageTypeDto</td>
    <td>Response will be MessageTypeDto  </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns MessageTypeDto <br>
For failure, returns error code and error message.  
<br><br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messagetype/id/{msgTypeId} </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  
  <tr>
    <td>API success response</td>
    <td> { <br>

“msgTypeId”: " string”, <br>
"msgType": "string", <br>
"createdBy": "string", <br>
“createdTime”:  long ,<br>
“messageRouteEntity”: [<br>{ <br>
“msgTypeId”: integer, <br>
“route”: "string", <br>
“routeType”: "string", <br>
“routeStatus: ”: "string”, <br>
“createdBy”: "string", <br>
“updatedBy”: "string", <br>
“createdTime”: Long, <br>
“updatedTime”:  Long <br>
}<br>
] <br>
} 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10025", <br>
“errorMessage”: “msg type cannot be blank” <br>
     }<br>
{ <br>
" errorCode ": " 10032", <br>
" errorMessage ": "message type not found" <br>
}<br>
</td>
  </tr>
</table>  <br>


***findByMsgType(String msgType) – Get message type by msgType***

 When the end point for findByMsgType(String msgType) is called, it is first routed to MessageType Controller class. It will return the message type by msgType.  <br>

###### Prototype:

findByMsgType   <br>
 (<br>
IN String msgType,    <br>
OUT MessageType messageType, 
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>msgType  </td>
    <td>Unique msgType  </td>
  </tr>
  <tr>
    <td>out</td>
    <td>MessageType </td>
    <td>RResponse will be consisting of a message type with its route configurations. </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns MessageType <br>
For failure, returns error code and error message. 
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messagetype/msgtype/{msgType}  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> { <br>
“msgTypeId”: int, <br>
"msgType": "string",<br> 
"createdBy": "string", <br>
“creaedTime”:  Long ,<br>
“messageRouteEntity”: [<br>{ <br>
“msgTypeId: int, <br>
“route”: "string", <br>
“routeType”: "string", <br>
“createdBy”: "string", <br>
“createdTime”: Long ,<br>
“updatedBy”: "string", <br>
“updatedTime”: Long ,<br>

}<br>] 
<br>
} 


</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10032", <br>
“errorMessage”: “message type not found” <br>
     }

</td>
  </tr>
</table>  <br><br>

***updateMessageType(updateMessageTypeDto body) -Update AckRequired***

When end point for updateMessageType(updateMessageTypeDto body) is called, it is first routed to MessageType Controller, fields are validated, fields in the request is mapped to updateMessageType. This endpoint will update the ackRequired. In the service class, fields are validated. 
<br>
Validations: 

* msgType cannot be null or empty. 
* ackRequired cannot be null or empty. 
* updatedBy cannot be null or empty. 

After validations message type will be saved to t_message_type table in route_config schema   of commcore database. If validation failed, then corresponding error code and error message are sent to the user.  

###### Prototype:


updateMessageType <br>
 (<br>
IN UpdateApplicationDto updateApplicationDto, <br>
OUT  String
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>UpdateApplicationDto </td>
    <td>It consists of object of UpdateApplicationDto. </td>
  </tr>
  <tr>
    <td>out</td>
    <td>String  </td>
    <td>Response will be a string .</td>
  </tr>
</table>
<br>

###### Returns:

On success, returns a string ‘Application updated successfully’. <br>
For failure, returns error code and error message. 

 
<br><br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/application  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>PUT  </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{ <br>
"applicationName ": "string", <br>
"applicationDescription": "string", <br>
"updatedBy": "string", <br>
}  </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> “Application updated successfully”
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td> 
{ <br>
“errorCode": "10031", <br>
" errorMessage ": “application not found” <br>
} <br>
{<br>
    "errorCode": "10022", <br>
    " errorMessage ": " application name cannot be blank found" <br>
} <br>
{ <br>
"errorCode": "10028", <br>
" errorMessage ": “application description cannot be blank” <br>
}   <br>
{ <br>
    "errorCode": "10024", <br>
    " errorMessage ": " updated by cannot be blank" <br>
} 

 
</td>
  </tr>
</table>  <br><br>


***deleteMessageType (String msgType) – Delete message type by msgType***

 When deleteMessageType(String msgType) is called, message type will be deleted. .  <br>
<br>

###### Prototype:


deleteByMessageType   <br>
 (<br>
IN String msgType    <br>
OUT String 
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>msgType </td>
    <td>Unique msgType </td>
  </tr>
  <tr>
    <td>out</td>
    <td>String  </td>
    <td>Response will a String. </td>
  </tr>
</table>
<br>

###### Returns:

On success, return ‘‘Message Type deleted successfully’’ <br>
For failure, returns error code and error message.
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messagetype/msgtype/{msgType}  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>DELETE </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td>‘‘Message Type deleted successfully’’ 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10032", <br>
“errorMessage”: “message type not found” <br>
     }
</td>
  </tr>
</table>  <br><br>

***getAllMessageType ()***

 When the end point for getAllMessageType () is called, it is first routed to MessageType  Controller class. This will return all message types. .  <br>

###### Prototype:


getAllMessageType    <br>
 (<br>
OUT List<MsgTypeDto> msgTypeDto 
);
<br>

###### Parameters:

<table>

  <tr>
    <td>out</td>
    <td>List<messsagTypeDto> </td>
    <td>Response will be list of messageTypeDto . </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns MessageTypeDto <br>
For failure, returns error code and error message.  

   
<br><br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messagetype/ </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> [<br>{ <br>

“msgTypeId”: " string”,<br> 
"msgType": "string", <br>
"createdBy": "string",<br> 
“createdTime”:  long <br>
messageRouteEntity:[<br> { <br>
“msgTypeId”: integer, <br>
“route”: "string", <br>
“routeType”: "string", <br>
“routeStatus”: "string",<br>
“createdBy”: "string", <br>
“updatedBy”: "string", <br>
“createdTime”: Long, <br>
“updatedTime”:  Long ,<br>
} <br>
] <br>
}<br>] 

</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10032", <br>
“errorMessage”: “message type not found” <br>
     }

</td>
  </tr>
</table>  <br><br>

***(CreateApplicationRouteDto body)-Creates ApplicationRoute***

 When the end point for creating application route is called, it is first routed to  ApplicationRouteController class. The fields are validated, Fields in the request 
is mapped to CreateApplicationRouteDto. In the service class fields are validated. 
<br><br>
Validations:  

* route cannot be null or empty 
* route type should be either stream or queue 
* createdBy cannot be null or empty <br><br>
After validations application route will be saved to t_application_route table in route_config schema of commcore database. If validation failed, then corresponding error code and error message is sent to the user. 

###### Prototype:


createApplicationRoute  <br>
 (<br>
IN  CreateApplicationRouteDto body, <br>
OUT ApplicationRouteDto applicationRouteDto 
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>CreateApplicationRouteDto  </td>
    <td>It consists of object of CreateApplicationRouteDto  </td>
  </tr>
  <tr>
    <td>out</td>
    <td>ApplicationRouteDto </td>
    <td>Response will be consisting applicationRouteDto  </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns applicationRouteDto <br>
For failure, returns error code and error message. 
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/applicationroute </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>POST </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{ <br>
"applicationId ": integer,  <br>
"route": "string",  <br>
“routeType”: "string”,  <br>
"createdBy": "string",  <br>
}  </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> { <br>
"applicationId ": integer, <br>
"route": "string", <br>
“routeType”: "string”,<br> 
“routeStatus”: "string”, <br>
"createdBy": "string", <br>
“createdTime”: "string”,<br>
“updatedBy”: "string”, <br>
“updatedTime”: "string”,<br> 
} 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10021", <br>
“errorMessage”: “application id cannot be blank” <br>
} <br>

{ <br>
"errorCode": "10026", <br>
"errorMessage": "route cannot be blank" <br>
} <br>
{ <br>
"errorCode": "10027", <br>
"errorMessage": "route type should be either stream or queue" <br>
} <br>

{ <br>
" errorCode ": " 10023", <br>
" errorMessage ": " created by cannot be blank" <br>
}<br>
</td>
  </tr>
</table>  <br><br>

***getApplicationRoute (int applicationId)***

 When the end point for getApplicationRout(int applicationId) is called, it is first 
routed to ApplicationRouteController class. This will return the list of application 
routes in the given id. Multiple routes can be created in one id.   <br>

###### Prototype:


getApplicationRoute     <br>
 (<br>
 IN int applicationId, <br>
OUT List<ApplicationRouteDto> applicationRouteDto<br>); 
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>applicationId <messsagTypeDto> </td>
    <td>applicationId  </td>
  </tr>
  <tr>
    <td>out</td>
    <td>List<ApplicationRouteDto>  <messsagTypeDto> </td>
    <td>Response will be list of ApplicationRouteDto . </td>
  </tr>
</table>
<br><

###### Returns:

On success, returns ApplicationRouteDto <br>
For failure, returns error code and error message.  

   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/applicationroute/id/{applicationId}  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> [<br>{ <br>

"applicationId ": integer, <br>
"route": "string", <br>
“routeType”: "string”, <br>
“routeStatus”: "string”,<br> 
"createdBy": "string", <br>
“createdTime”: "string”, <br>
“updatedBy”: "string”, <br>
“updatedTime”: "string”, <br>
} <br>] <br>

</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10033", <br>
“errorMessage”: “route not found” <br>
     }

</td>
  </tr>
</table>  <br><br>

***getAllApplicationRoute ()***

 When the end point for getAllApplicationRoute() is called, it is first routed to 
Application Controller class. This will return all application routes exist in table.    <br>

###### Prototype:


getApplicationRoute     <br>
 (<br>
OUT List<ApplicationRouteDto> applicationRouteDto 
<br>);

###### Parameters:

<table>
    <td>out</td>
    <td>List<ApplicationRouteDto> </td>
    <td>Response will be list of applicationRouteDto </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns ApplicationRouteDto <br>
For failure, returns error code and error message.
   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/applicationroutes/  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> [<br>{ <br>
"applicationId ": integer, <br>
"route": "string",  <br>
“routeType”: "string”,  <br>
“routeStatus”: "string”,  <br>
"createdBy": "string",  <br>
“createdTime”: "string”,  <br>
“updatedBy”: "string”,  <br>
“updatedTime”: "string”,  <br>
}  <br>] <br>
 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10033", <br>
“errorMessage”: “route not found” <br>
     }

</td>
  </tr>
</table>  <br><br>

***updateApplicationRoute(UpdateApplicationRoute body) – To update application route***

When end point for updateApplicationRoute(UpdateApplicationRouteDto body) is called, it is first routed to ApplicationRouteController, then fields are validated.

Validations:

* applicationId cannot be null or empty 
* route cannot be null or empty 
* routeType should be either stream or queue 

Felds in the request is mapped to UpdateApplicationRouteDto. This endpoint will update the application route details. The route type existing in dB is passed as path variable.

###### Prototype:


updateApplicationRoute(UpdateApplicationRouteDto  updateApplicationRouteDto <br>
 (<br>
IN String route, <br>
IN String routeType, <br>
OUT ApplicationRouteDto ApplicationRouteDto,  <br>
);
<br>

###### Parameters:

<table>
  <tr>
    <td>in</td>
    <td>UpdateApplicationRouteDto </td>
    <td> It consists of updateApplicationRouteDto 
 </td>
  </tr>
  <tr>
    <td>out</td>
    <td>String </td>
    <td>Response will be a string </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns a string ‘‘Application Route updated successfully’’ <br>
For failure, returns error code and error message. 
<br>
<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/applicationroute/route/{route}/routetype/{routeType}</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>PUT </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{<br>
  "applicationId": integer,<br>
  "route": "string",<br>
  "routeType": "string",<br>
  "updatedBy": "string"<br>
}<br>

</td>
  </tr>
 
  <tr>
    <td>API success response</td>
  <td>“Application Route updated successfully”
  </td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td> { <br>
“errorCode": "10033", <br>
" errorMessage ": “route not found” 
} <br>
{ <br>
  "errorCode": "10021", <br>
" errorMessage ": " application Id cannot be blank found" <br>
} <br>
{ <br>
"errorCode": "10027", <br>
" errorMessage ": “route type should be either stream or queue” <br>
} <br>
{ <br>
"errorCode": "10026", <br>
"errorMessage": "route cannot be blank" <br>
} <br>
{ <br>
    "errorCode": "10024", <br>
    " errorMessage ": " updated by cannot be blank" <br>
} <br>

 </td>
  </tr>
</table>  <br><br>

***deleteApplicationRoute(integer applicationId, String route, String routeType) – Delete application route***

 When deleteApplicationRoute(integer applicationId, String route,String routeType) is called application will be deleted. t_application_route table has application_id, route and routeType as composite primary key.     <br>

###### Prototype:


deleteApplicationRoute     <br>
 (<br>
 IN integer applicationId,<br>
 IN String route, <br>
 IN String routeType, <br>
 OUT String  
<br>

###### Parameters:

<table>
<tr>
<td>in</td>
<td>applicationId</td>
</tr>
<tr>
<td>in</td>
<td>route </td>
</tr>
<tr>
<td>in</td>
<td>routeType </td>
</tr>
<tr>
    <td>out</td>
    <td>String <ApplicationRouteDto> </td>
    <td>Response will be a String </td>
  </tr>
</table>
<br>

###### Returns:

On success, return ‘’Application Route deleted successfully’’ <br>
For failure, returns error code and error message.message.
   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/applicationroute/{applicationId}/{route}/{routeType}</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>DELETE </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> ‘Application Route deleted successfully’ 
 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10033", <br>
"errorMessage": “route not found” <br>
} 
</td>
  </tr>
</table>  <br><br>

***updateApplicationRouteStatus() – To update application route status***

When end point for updateApplicationRouteStatus(String route,String routeType,boolean routeAvailable) is called, it is first routed to ApplicationRoute Controller. The route, route type and routeAvailable is passed as request param, routeAvailable is a boolean value which will update the route status of given route and route type combination.  


###### Prototype:


updateApplicationRouteStatus <br>
 (<br>
IN String route ,<br>
IN String routeType,<br>
OUT  String, <br>
);
<br>

###### Parameters:

<table>
  <tr>
    <td>in</td>
    <td>UpdateApplicationRouteDto </td>
    <td> It consists of updateApplicationRouteDto 
 </td>
  </tr>
  <tr>
  <td>String </td>
  <td>route </td>
  </tr>
  </tr>
  <tr>
  <td>String </td>
  <td>routeType  </td>
  </tr>
  </tr>

  <tr>
    <td>out</td>
    <td>String </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns a string ‘’Successfully updated route status’’ <br>
For failure, returns error code and error message.  
<br>
<table>
  <tr>
    <td>URL</td>
    <td>v1.0/applicationroute/changestatus?route={route}&routeType={routeType}/</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>PUT </td>
  </tr>
  
 
  <tr>
    <td>API success response</td>
  <td>“Successfully updated route status”
  </td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td> { <br>
“errorCode": "10033",<br> 
" errorMessage ": “route not found”<br> 
} <br>
{ <br>
"errorCode": "10027", <br>
" errorMessage ": “route type should be either stream or queue” <br>
} <br>
{ <br>
"errorCode": "10026",<br> 
"errorMessage": "route cannot be blank" <br>
} 

 </td>
  </tr>
</table> <br><br> 

***(CreateMessageRouteDto createMessageRouteDto)-Creates MessageRoute***

 When the end point for creating message route is called, it is first routed to MessageRouteController class. The fields are validated, Fields in the request is mapped to CreateMessageRouteDtoIn the service class fields are validated. 
<br><br>
Validations: 

* msgTypeId cannot be null or empty 
* Route cannot null or empty 
* Route type is either stream or queue 
* CreatedBy cannot be null or empty <br><br>

After validations message route will be saved to t_message _route table in route_config schema of commcore database. If validation failed, then corresponding error code and error message is sent to the user. 

###### Prototype:


createMessageRoute  <br>
 (<br>
IN  CreateMessageRouteDto body, <br>
OUT MessageRouteDto messageRouteDto 
);
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>CreateMessageRouteDto </td>
    <td>It consists object of CreateMessageRouteDto </td>
  </tr>
  <tr>
    <td>out</td>
    <td>MessageRouteDto</td>
    <td>Response will be consisting messageRouteDto </td>
  </tr>
</table>
<br>

###### Returns:
On success, returns messageRouteDto <br>
For failure, returns error code and error message.  message. 
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messageroute  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>POST </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{  <br>
"msgTypeId ": integer,  <br>
"route": "string",  <br>
“routeType”: "string”,  <br>
"createdBy": "string", 
 <br>
}  </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> { <br>

"msgTypeId ": integer,<br> 
"route": "string", <br>
“routeType”: "string”, <br>
“routeStatus”: "string”, <br>
"createdBy": "string", <br>
“createdTime”: "string”,<br> 
“updatedBy”: "string”, <br>
“updatedTime”: "string”, <br>
} 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10029", <br>
“errorMessage”: “msg type id cannot be blank” <br>
} <br>
{ <br>
"errorCode": "10026", <br>
"errorMessage": "route cannot be blank'" <br>
} <br>
{ <br>
"errorCode": "10027", <br>
"errorMessage": "route type should be either stream or queue" <br>
} <br>
{ <br>
" errorCode ": " 10023", <br>
" errorMessage ": " created by cannot be blank" <br>
} <br>
</td>
  </tr>
</table>  <br><br>

***getMessageRoute (int msgTypeId)***

 When the end point for getMessageRoute(int msgTypeId) is called, it is first routed to MessageRouteController class. This will return the list of messageroutes in the given id. Multiple routes can be created in one id.    <br>

###### Prototype:

getMessageRoute      <br>
 (<br>
 IN int  msgTypeId, <br>
OUT List<MessageRouteDto> messageRouteDto 
<br>

###### Parameters:

<table>
<tr>
    <td>in</td>
    <td>msgTypeId  </td>
     <td>msgTypeId  </td>
  </tr>
  <tr>
    <td>out</td>
    <td>List<MessageRouteDto> </td>
    <td>Response will be list of MessageRouteDto  </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns MessageRouteDto <br>
For failure, returns error code and error message.  

   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messageroute/id/{msgTypeId}  </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> [<br>{ <br>

""msgTypeId" ": integer, <br>
"route": "string", <br>
“routeType”: "string”, <br>
“routeStatus”: "string”,<br> 
"createdBy": "string", <br>
“createdTime”: "string”, <br>
“updatedBy”: "string”, <br>
“updatedTime”: "string”, <br>
} <br>] <br>

</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10033", <br>
“errorMessage”: “route not found” <br>
     }

</td>
  </tr>
</table>  <br><br>

***getAllMessageRoute ()***

 When the end point for getAllMessageRoute() is called, it is first routed to MessageRoute Controller class. This will return all message routes exist in t_message_route table.     <br>

###### Prototype:


getAllMessageRoute      <br>
 (<br>
OUT List<MessageRouteDto> messageRouteDto 
<br>

###### Parameters:

<table>
    <td>out</td>
    <td>List<MessageRouteDto>  </td>
    <td>Response will be list of MessageRouteDto </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns MessageRouteDto <br>
For failure, returns error code and error message. message.
   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messageroutes/</td>
  </tr>
  <tr>
    <td>Method</td>
    <td>GET </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td>  
[ <br>
{ <br>
"msgTypeId ": integer, <br>
"route": "string", <br>
“routeType”: "string”, <br>
“routeStatus”: "string”, <br>
"createdBy": "string", <br>
“createdTime”: "string”, <br>
“updatedBy”: "string”, <br>
“updatedTime”: "string”, <br>
} <br>
] <br>
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10033", <br>
“errorMessage”: “route not found” <br>
     }

</td>
  </tr>
</table>  <br><br>

***updateMessageRoute(UpdateMessageRouteDto body) – To update message route***

When end point for updateMessageRoute(UpdateMessageRouteDto body) is called, it is first routed to MessageRouteController, fields are validated,
 Validation are: 

Validations:

* msgTypeId cannot be null or empty 
* route cannot be null or empty 
* routeType should be either stream or queue 
* updated by cannot be null or empty 

Felds in the request is mapped to UpdateMessageRouteDto. This endpoint will update the messageroute details. The route and route type is passed as path variable 

###### Prototype:


updateMessageRoute <br>
 (<br>
IN String route, <br>
IN String routeType, <br>
OUT UpdateMessageRouteDto updateMessageRouteDto,   <br>
);
<br>

###### Parameters:

<table>
  <tr>
    <td>in</td>
    <td>UpdateMessageRouteDto  </td>
    <td> It consists of UpdateMessageRouteDto
 </td>
  </tr>
  <tr>
    <td>out</td>
    <td>String </td>
    <td>Response will be a string </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns a string ‘’Message Route updated successfully’’ <br>
For failure, returns error code and error message. 
<br>
<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messageroute/route/{route}/routetype/{routeType} </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>PUT </td>
  </tr>
  <tr>
    <td>API request</td>
    <td>{<br>
  "msgTypeId": integer,<br>
  "route": "string",<br>
  "routeType": "string",<br>
  "updatedBy": "string"<br>
}<br>

</td>
  </tr>

  <tr>
    <td>API success response</td>
  <td>“Message Route updated successfully”
  </td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td> { <br>
“errorCode": "10033", <br>
" errorMessage ": “route not found” <br>
} <br>
{ <br>
    "errorCode": "10029", <br>
    " errorMessage ": " msgTypeId cannot be blank found" <br>
} <br>
{ <br>
"errorCode": "10027", <br>
" errorMessage ": “route type should be either stream or queue” <br>
} <br>
{ <br>
    "errorCode": "10024", <br>
    " errorMessage ": " updated by cannot be blank" <br>
} <br>
  <br>
{ <br>
    "errorCode": "10024", <br>
    " errorMessage ": " updated by cannot be blank" <br>
} <br>

 </td>
  </tr>
</table>  <br><br>

***updateMessageRouteStatus(String route, String routeType,Boolean routeAvailable) – To update message route status***

 When end point for updateMessageRouteStatus(String route,String routeType,Boolean routeAvailable) is called, it is first routed to MessageRoute Controller. It will update the status of message route in given route and routeType .     <br>

###### Prototype:


updateMessageRouteStatus    <br>
 (<br>
 IN String route ,<br>
IN String routeType, <br>
Boolean routeAvailable ,<br>
OUT UpdateMessageRouteDto ,<br>updateMessageRouteDto); <br>
<br>

###### Parameters:

<table>
<tr>
<td>in</td>
<td>route </td>
</tr>
<tr>
<td>in</td>
<td>routeType </td>
</tr>
<tr>
    <td>out</td>
    <td>String <ApplicationRouteDto> </td>
    <td>Response will be a String </td>
  </tr>
</table>
<br>

###### Returns:

On success, returns a string “Successfully updated route status” <br>
For failure, returns error code and error message. 
   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/applicationroute/changestatus/?route={route}&routeType={routeType}/
 </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>PUT </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> ‘Successfully updated route status’ 
 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10033", <br>
"errorMessage": “route not found” <br>
} 
</td>
  </tr>
</table>  <br><br>

 </td>
  </tr>
</table>  

***deleteMessageRoute(integer msgTypeId, String route, String routeType) – Delete message route***

 When deleteMessageRoute (integer msgTypeId, String route, String routeType) is called message route will be deleted. t_message_route table has msg_type_id,route and routeType as composite primary key.     <br>

###### Prototype:


deleteMessageRoute     <br>
 (<br>
 IN integer msgTypeId <br>
IN String route <br>
IN String routeType <br>
OUT String <br>
);   
<br>

###### Parameters:

<table>
<tr>
<td>in</td>
<td>msgTypeId</td>
</tr>
<tr>
<td>in</td>
<td>route </td>
</tr>
<tr>
<td>in</td>
<td>routeType </td>
</tr>
<tr>
    <td>out</td>
    <td>String <ApplicationRouteDto> </td>
    <td>Response will be a String </td>
  </tr>
</table>
<br>

###### Returns:

On success, return ‘’Message Route deleted successfully’’ <br>
For failure, returns error code and error message. 
   
<br>

<table>
  <tr>
    <td>URL</td>
    <td>/v1.0/messageroute/{msgTypeId}/{route}/{routeType} </td>
  </tr>
  <tr>
    <td>Method</td>
    <td>DELETE </td>
  </tr>
  <tr>
    <td>API success response</td>
    <td> ‘‘Message Route deleted successfully’’  
 
</td>
  </tr>
  <tr>
    <td>API  
Failure response 
</td>
     <td>{ <br>
"errorCode": "10033", <br>
"errorMessage": “route not found” <br>
} 
</td>
  </tr>
</table>  <br><br>

**Logging Mechanism:**

All the projects are having a common logging framework which is implemented in the module c2c_base_common. Entry and exit log will be logged by this module for every public method. Trace id and span id is injected to all logs. Along with-it identifiers like message type, message id etc. is also logged in every line.

**Security:**

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

   
**Error Handling:**

The exceptions are handled smoothly. Custom exceptions are used. 

*	ResourceNotFoundException: A custom exception which extends exception. ResourceNotFoundException is thrown when application, message type or route does not exist. 

*	RequestValidationException: A custom exception which extends exception class. Request Validation Exception is thrown when validation of mandatory fields failed. i.e., when mandatory field is empty or null or when the message type or application already exists or when id, route and route type combination already exist in route configuration. 

*	BaseCommonInvalidException: BaseCommonInvalidException is thrown when authentication header not matching, API key not matching, x-requestor is empty, incorrect bytes in API key. 
List of all platforms wide error codes and their respective description are listed in the table below. Based on the error code, a consumer can take an action based on the severity of the error.
List of all platforms wide error codes and their respective description are listed in the table below. Based on the error code, a consumer can take an action based on the severity of the error.



## <a id="_Howto"></a>7. How to

NA


  

| Acronym or term|   Definition |  
| :------------- | :------------ |
| C2DSender | Cloud to Device Sender |     
| MD |  Message Dispatcher|   
| MSP |  Message Storage Processor | 
|ack|   acknowledgment|  
| IoT | Internet of Things |
| S3 | Simple Storage Service |  
| C2C | Cloud to Cloud |
