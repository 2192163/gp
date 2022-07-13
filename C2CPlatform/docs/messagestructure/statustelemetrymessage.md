# Body Status message</br>

!!! attention
    This message type is defined for the demo purpose only. 

**Message Name** - Body Status Telemetry message. <br>
**Description** - This message is a generalized structure to transfer the various statues of the body parts. <br>
**Source Application** - Device<br>
**Target Application** - Cloud<br>
**Structure** - Json<br>
**Frequency** - Depends on the content of the body object.

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
    "message_type": "BODY_STATUS",
    "time": 1624515332856,
    "ttl": -1,
    "status": "SUBMIT",
    "property_bag": {
        "body_encoding_type": 1
    },
    "body": { // Datatype string, below object will be base64 Encoded String.
        "body_status":{
            "part":"WINDOW", //DOOR,WINDOW,TRUNK,HOOD
            "position":"FRONT_LEFT", //FRONT_LEFT,FRONT_RIGHT,REAR_LEFT,REAR_RIGHT,NOT_APPLICABLE
            "status": 0 //OPEN (100) , CLOSED not locked (0) , LOCKED (-1)
        }
    }
}

```

### **Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
| part| String| Yes| | DOOR,WINDOW,TRUNK,HOOD|
| position| String| Yes| | FRONT_LEFT,FRONT_RIGHT,REAR_LEFT,REAR_RIGHT,NOT_APPLICABLE|
| status| Numeric| Yes| | OPEN (100) , CLOSED not locked (0) , LOCKED (-1)|
    
