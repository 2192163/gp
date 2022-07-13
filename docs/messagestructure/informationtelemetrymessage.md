# Information message</br>

!!! attention
    This message type is defined for the demo purpose only. 

**Message Name** - Information message. <br>
**Description** - This message is a structure to transfer the entity / thing information details to cloud. It provides the details of the entity. All static values / non-frequent changing values will be reported in this object, relevant to the underlying entity. Entity can be Vehicle / Bike / Things / Devices. <br>
**Source Application** - Device<br>
**Target Application** - Cloud<br>
**Structure** - Json<br>
**Frequency** - Typically only once.


### Message
```json

{
    "message_id": "msg-cld-uniqueid",
    "correlation_id": "",
    "version": "v1",
    "system_id": "c2c-sys-uniqueid",
    "sub_system_id": "c2c-sub-uniqueid",
    "vin": " **vehicle identifier**",
    "device_id": "**device identifier **",
    "ecu_type": "**ecu type**",
    "source_id": "c2c-edge",
    "target_id": "c2c-cloud",
    "message_type": "INFO",
    "time": 1624515332856,
    "ttl": -1,
    "status": "SUBMIT",
    "property_bag": {
        "body_encoding_type": 1
    },
    "body": { // Datatype string, below object will be base64 Encoded String.
        "info": { // Information object - to provide the details of the entity. All static values / non-frequent changing values will be reported in this object, relevant to the underlying entity. Entity can be Vehicle / Bike / Things / Devices.
            "ivi": { // information about IVI unit.
                "skuid": "",
                "packagename":"",
    		    "surveillance":true //true or false if its subscribed or not.
            },
            "tcu": { // information about TELEMATICS unit
                    "skuid": "",
                    "swversion": "",
                    "carriername":  "", 
                    "hotspot": 0, // 0-off, 1-on
                    "ulbitrate": 0.0,  //double value Kbps
                    "dlbitrate": 0.0, //double value Kbps
                    "rat":"", //Current Radio Access Technology
                    "signalstrength":-65, 
                    "signalquality" : 10
                }
            }
        }
    }

```

**Body**

1. info.IVI - This object represents information of IVI device.
       
    |Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
    | :------------- | :------------ |:------------ |:------------: |:------------ |
    | skuid| String| No| | SKU Identifier for chipset for Device type.|
    | packagename| String| No| | Package name|
    | surveillance| String| No| |true or false if its subscribed or not|
   
2. info.TCU / Telematics - This object represents information of TCU/Telematics device.

    |Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
    | :------------- | :------------ |:------------ |:------------: |:------------ |
    | skuid| String| No| | SKU Identifier for chipset for Device type.|
    | swversion| String| No| | Software version / model of IVI components|
    | carriername| String| | | Carrier name.|
    | hotspot| Numeric| | | 0-off, 1-on|
    | ulbitrate| Decimal| | | |
    | dlbitrate| Numeric| | | |
    | rat| Numeric| | | Current Radio Access Technology|
    | signalstrength| Numeric| | | Signal strength|
    | signalquality| Numeric| | | Signal quality|

