## SMP to LMS Install License Data
**Message Name** - Install License Data<br>
**Description** - A message sent to LMS from SMP for installing license. <br>
**Source Application** - Cloud<br>
**Target Application** - Cloud<br>
**Structure** - Json<br>

**Message**

```json
{
		"message_id": "kU0VhiI26Umej6IS",
		"correlation_id": null,
		"version": "v1",
		"system_id": "sys693624ce37bf11ecb858",
		"sub_system_id": "CTS-TEST-SUB_101",
		"vin": "VINQCOMNAD0000999",
		"device_id": "CTS-Test-DEV_101",
		"ecu_type": "Telematics",
		"source_id": "c2c_cloud",
		"target_id": "mdm_2",
		"message_type": "INSTALL LICENSE",
		"time": 1635481940300,
		"ttl": -1,
		"status": "SUBMIT",
		"property_bag": null,
		"body": "eyJpbnN0YWxsX2xpY2Vuc2VfZGF0YSI6W3sidmluIjoidmluLXRlc3QtbW9kZWwtNDMiLCJmZWF0dXJlX2xpc3QiOlt7ImlkIjoxNDAwLCJuYW1lIjoiQXVkaW8gRFNQIiwiZmVhdHVyZV9vcHRpb24iOnsibWV0YWRhdGEiOm51bGwsIm9wdGlvbl9uYW1lIjpudWxsfSwiaXNfYnVuZGxlZCI6ZmFsc2V9XSwicHJvZ3JhbV9pbmZvIjp7InByb2dyYW1faWQiOjEwMywicHJvZ3JhbV92ZXJzaW9uIjozLCJwcm9ncmFtX25hbWUiOiJDb2duaXphbnQgRGV2IFBnbSB2MSJ9LCJjaGlwc2V0X2luZm8iOnsiY2hpcHNldF9pZCI6IlMxMjQzNjM4MyIsImNoaXBzZXRfbmFtZSI6Im1kbV8yIiwiZWN1X2lkIjoxNjczMTgxNn0sImVjdV90eXBlIjoiaXZpIiwic2t1X2lkIjoxMjc1LCJza3VfbmFtZSI6ImFyanVuX2l2aV9za3VfdjIwIiwic291cmNlX3R4bl9pZCI6IkphNlF5UlBFNDZ1Q2FMTkoiLCJ0eG5fdHlwZSI6Imluc3RhbGwiLCJzb3VyY2VfdHhuX3RzIjoxNjM1MTcxNDc0Nzg1fV19",
		"trace_id": "d27ce7477f8ccc7b",
		"span_id": "d27ce7477f8ccc7b"
}
		
DECODED BODY :-
		
{
		    "install_license_data": [{
		            "vin": "vin-test-model-43",
		            "feature_list": [{
		                    "id": 1400,
		                    "name": "Audio DSP",
		                    "feature_option": {
		                        "metadata": null,
		                        "option_name": null
		                    },
		                    "is_bundled": false
		                }
		            ],
		            "program_info": {
		                "program_id": 103,
		                "program_version": 3,
		                "program_name": "Cognizant Dev Pgm v1"
		            },
		            "chipset_info": {
		                "chipset_id": "S12436383",
		                "chipset_name": "mdm_2",
		                "ecu_id": 16731816
		            },
		            "ecu_type": "ivi",
		            "sku_id": 1275,
		            "sku_name": "arjun_ivi_sku_v20",
		            "source_txn_id": "Ja6QyRPE46uCaLNJ",
		            "txn_type": "install",
		            "source_txn_ts": 1635171474785
		        }
		    ]
}
```

**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|vin|String|Yes|17 |Vin number of the device |
|feature_list|List of Objects|Yes| |List Of Features |
|ecu_type|String|Yes| |Describes the type of ECU|
|chipset_info|Object|Yes| |ECU id, chipset id and chipset name details in chipset_info|
|sku_id|Integer|Yes| |Id of SKU|
|sku_name|String|Yes| |Name of SKU|
|program_info|Object|Yes| |Program id, program name and program version in program info|
|source_txn_id|String|Yes| |Trasaction ID involved while calling LMS to install License|
|txn_type|String|Yes| |Describes the type of transaction. eg:install/Delete|
|source_txn_ts|Long|Yes| |Gives the current UTC Epoch value|


