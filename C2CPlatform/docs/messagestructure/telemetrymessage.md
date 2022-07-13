# Telemetry message</br>

!!! attention
    This message type is defined for the demo purpose only. Device component will acept the data on various topics on internal broker. Not all contents of body may be sent every time. Whatever data is available it will be sent to cloud by wrapping it in the C2C Message.  

**Message Name** - Telemetry message. <br>
**Description** - This message is a generalized structure to transfer the various types of vehicle data, information, events and other details to cloud. <br>
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
    "message_type": "TELEMETRY",
    "time": 1624515332856,
    "ttl": -1,
    "status": "SUBMIT",
    "property_bag": {
        "body_encoding_type": 1
    },
    "body": { // Datatype string, below object will be base64 Encoded String.
        "hvac": 
        {
            "timestamp": 121212,
            "airflow": 1, //  0 - off, 1 - Downward, 2 - Upward, 3 - Upward & downward
            "fanstatus": 1, // 0 - off, 1 - on
            "circulation": 1, // 0 - inside, 1 - outside
            "front": 1, // 0 - off, 1 - on
            "rear": 1, // 0 - off, 1 - on
            "autoclimate": 1, // 0 - off, 1 - on
            "zone": 1, // 0-vehicle, 1-driver, 2-passenger, 3-rearleft, 4-rearright
            "target_temp": 74
        }
    }
}

```

### **Body**

1. Telemetry - This object represents the telemetry / events data sent by the vehicle.
       
    |Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
    | :------------- | :------------ |:------------ |:------------: |:------------ |
    | **hvac**| Array| No| | Represents array of hvac temperature objects|
    | zone| Numeric| Yes| | Value will be always zero (0) for vehicle level. 1-front_left, 2-front_right, 3-rearleft, 4-rearright|
    | airflow| Numeric| No| | 0 - off, 1 - Downward, 2 - Upward, 3 - Upward & downward|
    | fanstatus| Numeric| No| | 0 - off, 1 - on|
    | circulation| Numeric| No| | 1 - inside, 2 - outside|
    | front| Numeric| No| | 0 - off, 1 - on|
    | rear| Numeric| No| | 0 - off, 1 - on|
    | autoclimate| Numeric| No| | 0 - off, 1 - on|
    | target_temp| Numeric| Yes| | Targetted temperature for the respective zone|
    

