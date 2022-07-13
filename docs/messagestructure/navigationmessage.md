# Navigation telemetry message</br>

**Message Name** - Navigation telemetry message. <br>
**Description** - This message is a will provide the location telemetry of the vehicle. <br>
**Source Application** - Device<br>
**Target Application** - Cloud<br>
**Structure** - Json<br>
**Frequency** - every 1sec.


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
    "source_id": "telematics",
    "target_id": "c2c-cloud",
    "message_type": "NAVIGATION",
    "time": 1624515332856,
    "ttl": -1,
    "status": "SUBMIT",
    "property_bag": {
        "body_encoding_type": 1
    },
    "body": { // Datatype string, below object will be base64 Encoded String.
        // information about the vehicle navigation. Facility to buffer the data and send across hence defined as array.
        "navigation": 
        {
            "accuracy": 16, // meters.  In some implementations may be a placeholder value.
            "altitude": 5, // meters.  In some implementations may be a placeholder value.
            "bearing": 176, // degrees clockwise from north; can be negative
            "realtimenanos": 113472076192778, // nanoseconds
            "latitude": 32.7197681803864, // latitude in degrees north
            "longitude": -117.162922969187, // longitude in degrees east
            "provider": "FILE", // source of the GPS or GPS provider. In this demo use case this will mostly be TELEMATICS.
            "speed": 16.98752, // vehicle speed in meters/second
            "timestamp": 1456468126881 // milliseconds
        }
    }
}

```

### **Body**

Navigation - This object represents the Navigation data associated with vehicle movement.

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
| accuracy| Numeric| Yes| |meters. In some implementations may be a placeholder value. |
| altitude| Numeric| Yes| |meters. In some implementations may be a placeholder value. |
| bearing| Numeric| Yes| |degrees clockwise from north; can be negative |
| realtimenanos| Numeric| Yes| |nanoseconds |
| latitude| Numeric| Yes| |latitude in degrees north |
| longitude| Numeric| Yes| |longitude in degrees east |
| provider| String| Yes| |source of the GPS or GPS provider. In this demo use case this will mostly be    TELEMATICS. |
| speed| Decimal| Yes| |vehicle speed in meters/second |
| timestamp| Numeric| Yes| |milliseconds |
