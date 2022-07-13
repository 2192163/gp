## Activate Chipset Message
**Message Name** - Activate Chipset<br>
**Description** - Message sent to device for activation after license install.<br>
**Source Application** - Cloud<br>
**Target Application** - Device<br>
**Structure** - Json<br>

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
	"source_id": "onboarding_service",						
	"target_id": "<chipset_name>", //e.g mdm_1
	"message_type": "ACTIVATE_CHIPSET",
	"time": 1620891851,							
	"ttl": -1,		
    "status": "SUCCESS",
	"property_bag": {
		"body_encoding_type":1
	},
	"body":  // Below object will be base64 Encoded String
	{
		"state"		   : "ACTIVE",
		"name"         : "mdm/1",
		"id"           : "xxxxxx" //chipset id			
	}
}
```

**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|state|String|Yes| |Active state|
|name|String|Yes| |name / sequence of the chipset maintained inside the device.|
|id|String|Yes| |Chipset id.|



