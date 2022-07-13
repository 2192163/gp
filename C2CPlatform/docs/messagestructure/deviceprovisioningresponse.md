## Device Provision Response
**Message Name** - Device Provisioning Response <br>
**Description** - Message sent back to the device after chipset onboarding is completed. <br>
**Source Application** - Cloud <br>
**Target Application** - Device <br>
**Structure** - Json

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
	"source_id": "c2c-edge",						
	"target_id": "c2c-cloud",						
	"message_type": "DEVICE_PROVISION_RESPONSE",
	"time": 1620891851,							
	"ttl": -1,		
    "status": "SUCCESS",
	"property_bag": {
		"body_encoding_type":1
	},
	"body": 	// Below object will be base64 Encoded String
	{
		"lifecycyclestate": "PROVISIONED"
	}
}
```

**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|lifecycyclestate|String|Yes| |State of the ECU device post provisioning.|
