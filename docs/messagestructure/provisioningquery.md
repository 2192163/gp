## Provision Query
**Message Name** - Provisioning Query  <br>
**Description** - Message sent by the device to cloud Global Partition to understand the Regional Partition. This message will only be sent by the Primary device of the vehicle. <br>
**Source Application** - Device <br>
**Target Application** - Cloud  <br>
**Structure** - Json  <br>

** Message **
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
	"message_type": "PROVISION_QUERY",
	"time": 1620891851,							
	"ttl": -1,		
    "status": "SUBMIT",
	"property_bag": {
		"body_encoding_type":1				
	},	
	"body": 	// Datatype string, below object will be base64 Encoded String 
	{
		"system_id":"c2c-00000001",
		"sub_system_id":"c2c-sub-0000001",
		"vin": "vin-100",	
		"deviceId": "device-101",
		"ecu_type": "TCU",
		"primary":true,	
		"region_info": {
			"region_code": "NA",
			"country_code": "ca"
		}
	}
}
```

** Body ** 

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|system_id|String|Yes| 23 |A C2C platform specific unique id generated at time of Registration. Format is  c2c-sys-Unique id|
|sub_system_id|String|Yes| 10 |A C2C platform specific unique id generated at time of Registration. Format is  c2c-sub-Unique id|
|vin|String|Yes| 17 |Vehicle Identification number.vin is mandatory for appropriate homing|
|device_Id|String|Yes| 19 |Manufacturer unique serial no/device_id|
|ecu_type|String|Yes| 10 |Type of the ECU. Possible values are TCU, IVI, ADAS|
|primary|Boolean|Yes| |Defines which is primary Device|
|region_info:region_code|String|Yes| |Region code|
|region_info:county_code|String|Yes| |Country code|