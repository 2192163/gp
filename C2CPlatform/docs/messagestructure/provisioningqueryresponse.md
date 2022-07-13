## Provision Query Response
**Message Name** - Provisioning Query Response <br>
**Description** - Provisioning query response containing details of the regional details for the device. <br>
**Source Application** - Cloud <br>
**Target Application** - Device <br>
**Structure** - Json <br>

**Message**

```json
{
	"message_id": "msg-dev-uniqueid",
	"correlation_id" :"msg-cld-uniqueid",
	"version": "v1", 
	"system_id":"c2c-sys-uniqueid",
	"sub_system_id":"c2c-sub-uniqueid",
	"vin": " **vehicle identifier**",							
	"device_id": "**device identifier **",					
	"ecu_type": "**ecu type**",								
	"source_id": "c2c-cloud",						
	"target_id": "c2c-edge",						
	"message_type": "PROVISION_QUERY_RESPONSE",
	"time": 1620891851,							
	"ttl": -1,		
    "status": "SUBMIT",
	 "property_bag": {
	  "body_encoding_type":1
	 },
	 "body":            // Below object will be base64 Encoded String
	 {
		  "iot_gateway_endpoint":"avyq8mqx1md7m-ats.iot.us-east-1.amazonaws.com", // Regional Partition URL
		  "smqendpoint":"",        // Not applicable now
		  "otaendoint":"" ,        // Not applicable now
		  "lifecyclestate":"PROVISION_PENDING_REGIONAL" // Indentification that to initiate
	 }
}
```

**Body**


|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|iot_gateway_endpoint|String|Yes| 100 |Regional Partition URL|
|smqendpoint|String|Yes| 100 |Not applicable. Future use|
|otaendoint|String|Yes| 100 |Not applicable. Future use|
|lifecyclestate|String|Yes|  |State of the device. Refer Lifecycle state list in C2C Message format page.|
