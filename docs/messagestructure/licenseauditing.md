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
    "source_id": "mdm_1",
    "target_id": "c2c-cloud",
    "message_type": "LICENSE_HEALTH_CHECK",
    "time": 1620891851,
     "ttl": -1,
    "status": "SUBMIT",
    "property_bag": {
        "body_encoding_type": 1
    },
    "body": // Below object will be base64 Encoded String
    {
       "msg_type": int(12),
       "license_list": [
                          {
                            "serial_num" : string: 64 ,
                            "feature_id_list": array[int, int ..]             
                            "license_expiry":[string: 24("YYYY:MM:DD HH:MM:SS UTC"), string: 24 ("YYYY:MM:DD HH:MM:SS UTC")],
                            "type": string: 8 ("platform"),
                            "meta": [
                                                       {"mismatch_codes": int},
                                                      {"rectification_codes": int}
                                            ]
                          },

                          {
                            "serial_num" : string:64,
                            "feature_id_list": array[109,110],                 
                            "license_expiry":[string:24("YYYY:MM:DD HH:MM:SS UTC"), string:24 ("YYYY:MM:DD HH:MM:SS UTC")],
                            "type": string:8("device"),
                            "meta": [
                                                            {"mismatch_codes": int},
                                                            {"rectification_codes": int}
                                           ]
                          }  
                   ]
                   “trans_id” : -1
   }
}
```
**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|msg_type|String|Yes|17 |Type of the message (12) |
|license_list|List of Objects|Yes| |List Of license details |
|trans_id|String|Yes| |Transaction Id|
|serial_num|String|Yes|Unique id(license id) for a license|
|feature_id_list|List of integer|Yes| Feature id list from device|

