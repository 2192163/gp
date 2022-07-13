## Device Provision
**Message Name** - Device Provisioning <br>
**Description** - Provisioning message sent by device to the regional instance. <br>
**Source Application** - Device <br>
**Target Application** - Cloud <br>
**Structure** - Json <br>

**Message**

```json
{
    "message_id": "msg-dev-uniqueid",
    "correlation_id": "msg-cld-uniqueid",
    "version": "v1",
    "system_id": "c2c-sys-uniqueid",
    "sub_system_id": "c2c-sub-uniqueid",
    "vin": " **vehicle identifier**",
    "device_id": "**device identifier **",
    "ecu_type": "**ecu type**",
    "source_id": "c2c-edge",
    "target_id": "c2c-cloud",
    "message_type": "DEVICE_PROVISION",
    "time": 1620891851,
    "ttl": -1,
    "status": "SUCCESS",
    "property_bag": {
        "body_encoding_type": 1
    },

    "body": // Below object will be base64 Encoded String
    {
        "system_id": "c2c-sys-00000001",
        "sub_system_id": "c2c-sub-0000001",
        "vin": "vin-100",
        "vehicle_info": {
            "class": "F",
            "style": "Minivan",
            "model": "Camaro",
            "year": "2021"
        },
		"device_id":"",
		"device_info":{
				"ecu_model":"base-a",
				"ecu_make":"",
				"ecu_type": "TCU",
				"primary": true
		},
        "chipsets_count": 2, // This is mandatory
        "chipsets":
        [{
                "state": "UNREGISTERED",
                "name": "mdm_1",
                "id": "", //EMPTY initially // Unique ID // chip_id (To Be)
                "type": "8950", //  SA515
                "version": "8950A", //  SA515M.LE.2.1
                "sw_version": "va", // firmware version
                "hw_version": "hva",
                "program_sku_id": 667
            }, {

                "state": "UNREGISTERED",
                "name": "mdm_2",
                "id": "", //EMPTY initially // Unique ID // chip_id (To Be)
                "type": "8950", //  SA515
                "version": "8950A", //  SA515M.LE.2.1
                "sw_version": "va", // firmware version
                "hw_version": "hva",
                "program_sku_id": 667
            }
        ],
        "region_info": {
            "region_code": "NA",
            "country_code": "ca"
        },
        "SIMInfo": {},
        "communication_channel": [],
        "configuration": {},
        "privacyFlag": false,
        "lifecycyclestate": "PROVISION_PENDING_REGIONAL"
    }
}
```

**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|system_id|String|Yes| 23 |Unique id generated at time of Registration for the system. Format is  c2c-Unique id|
|sub_system_id|String|Yes| 10 |Unique id generated at time of Registration for the sub system. Format is  c2c-sub-Unique id|
|vin|String|No| 17 |Vehicle Identification number.vin is mandatory for appropriate homing|
|vehicle_info | Object | Yes | | Information pertaining to the vehicle to which the device belongs. |
|device_id|String|Yes| 19 |Manufacturer unique serial no/device_id.|	
|chipsets_count| Numeric| Yes| | Total no. of chipset present in the provided device_id.|
|chipsets |Array | No | | List of chipset containing all required details. |
|region_info:region_code|String|Yes| |Region code|
|region_info:county_code|String|Yes| |Country code|
|SIMInfo|Object|No| |If available update in the database.|
|communication_channel|Array|No| |List of communicatin channel details. Vin and address is mandatory for appropriate homing. Communication_channel is Not mandatory|
|configuration|Object|No| |Manufacturer unique serial no/device_id. Not mandatory|
|privacyFlag|Boolean|No| |If available store it. |
|lifecycyclestate|String|No| |Life cycle state of the device. This can be ignored while sending this message. |
