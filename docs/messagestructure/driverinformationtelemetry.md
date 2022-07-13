# Driver Information message</br>

!!! attention
    This message type is defined for the demo purpose only. <br /> In C2C Platform current owner / possessor of the entity will be reported by Information message type only.

**Message Name** - Driver Information message. <br />
**Description** - This message is a structure to transfer the driver information details to cloud. It provides the details of the driver. All static values / non-frequent changing values will be reported in this object, relevant to the driver.<br />
**Source Application** - Device<br />
**Target Application** - Cloud<br />
**Structure** - Json<br />
**Frequency** - Typically when driver changes. <br /> 

### Message
```json

{
    "message_id": "msg-cld-uniqueid",
    "correlation_id": "",
    "version": "v1",
    "system_id": "c2c-sys-uniqueid",
    "sub_system_id": "c2c-sub-uniqueid",
    "vin": " **vehicle identifier**",
    "device_id": "** device identifier **",
    "ecu_type": "**ecu type**",
    "source_id": "c2c-edge",
    "target_id": "c2c-cloud",
    "message_type": "DRIVER_INFO",
    "time": 1624515332856,
    "ttl": -1,
    "status": "SUBMIT",
    "property_bag": {
        "body_encoding_type": 1
    },
    "body": { // Datatype string, below object will be base64 Encoded String.
        "driver": { // vehicle owner profile details
            "name": "", // mandatory
            "email": "", // mandatory
            "id": "", // mandatory
            "image": "" // mandatory
        }
    }
}

```

**Body**

1. driver - This object represents information of owner associated with vehicles.

    |Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
    | :------------- | :------------ |:------------ |:------------: |:------------ |
    | name| String| Yes| | Name of the profile.|
    | email| String| Yes| | Email id of the associated profile.|
    | id| String| Yes| | Unique id of the profile.|
    | image| String| Yes| | Image URL.|


