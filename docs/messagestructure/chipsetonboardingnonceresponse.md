## Onboarding Nonce Response
**Message Name** - Chipset Onboarding Nonce Response<br>
**Description** - Response for the NONCE message with all attestation details and application data.<br>
**Source Application** - Device<br>
**Target Application** - Cloud<br>
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
	"source_id": "c2c-edge",						
	"target_id": "c2c-cloud",						
	"message_type": "CHIPSET_ONBOARDING_NONCE_RESPONSE",
	"time": 1620891851,							
	"ttl": -1,		
    "status": "SUCCESS",
	"property_bag": {
		"body_encoding_type":1
	},
	"body":  // Below object will be base64 Encoded String
	{
		// Any additional nonce related data here
		"msg_type":8, 										/* ONBOARDING_ATTESTATION_REPORT with additional data, */
		"t_len":<token length>,           					// Example: 1156
		"trans_id": <transaction id>,   					/* match id received in ATTESTATION_REQUEST */
		"token"   : <token>,            				/* base64 encoded string */  
		"result":"SUCCESS",
		"name":"mdm_1",
		"qwes_version":"1.0"
	}
}
```

**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|msg_type|String|Yes| |Value = 8 |
|t_len|String|Yes| |Length of token.|
|token|String|Yes| |token message |
|trans_id|String|Yes| |match id received in ATTESTATION_REQUEST .|
|result|String|Yes| |Attestation operation result.|
|name|String|No| |Intended chipset name / Sequence in the given device.|
|qwes_version|String|No| |QWES version to be called|


