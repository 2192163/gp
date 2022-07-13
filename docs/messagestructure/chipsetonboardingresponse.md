## Onboarding Response
**Message Name** - Chipset Onboarding Response<br>
**Description** - Message containing confirmation of the Chipset onboarding in the system. This message will be triggered for every chiset getting onboarded.<br>
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
	"message_type": "CHIPSET_ONBOARDING_RESPONSE",
	"time": 1620891851,							
	"ttl": -1,		
    "status": "SUCCESS",
	"property_bag": {
		"body_encoding_type":1
	},
	"body":  // Below object will be base64 Encoded String
	{
		"state"		   : "REGISTERED",
		"name"         : "mdm/1",
		"id"           : "xxxxxx",           			//Need to mock this for short term with random id for the chipset.
		"error_flag":false							// In case true we can add the error code any specific handling require?			
	}
}
```

**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|state|String|Yes| |State of chipset onboarding|
|name|String|Yes| |name / sequence of the chipset maintained inside the device.|
|id|String|Yes| |Need to mock this for short term usage.|
|error_flag|Boolean|Yes| |Error flag.|



