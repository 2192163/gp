## SMP to LMS Delete License Data
**Message Name** - Delete License Data<br>
**Description** - A message sent from SMP to LMS to delete the existing license. <br>
**Source Application** - Cloud<br>
**Target Application** - Cloud<br>
**Structure** - Json<br>

**Message**

```json
{
		"message_id": "msg-cld-7d0074a1-387a-11ec-9bbb-9d210368b60a",
		"correlation_id": null,
		"version": "v1",
		"system_id": "sysae4abd13332611ecb858",
		"sub_system_id": "subrOCsRvo",
		"vin": "SIMV1634900189468",
		"device_id": "simD_Xw9L56pUkF80G2",
		"ecu_type": "IVI",
		"source_id": "c2c_cloud",
		"target_id": "mdm_2",
		"message_type": "DELETE LICENSE",
		"time": 1635485927599,
		"ttl": -1,
		"status": "SUBMIT",
		"property_bag": {
		"body_encoding_type": 1
		},
    "body": "eyJkZWxldGVfbGljZW5zZV9kYXRhIjpbeyJ2aW4iOiJTSU1WMTYzNDkwMDE4OTQ2OCIsImVjdV90eXBlIjoiaXZpIiwic2t1X2lkIjoxMjc1LCJza3VfbmFtZSI6ImFyanVuX2l2aV9za3VfdjIwIiwiZGVsZXRlX3NlcmlhbHMiOlsiU2tuMzlUTWloUDlTIl0sImZlYXR1cmVfbGlzdCI6W3siaWQiOjE0MDAsIm5hbWUiOiJBdWRpbyBEU1AiLCJmZWF0dXJlX29wdGlvbiI6eyJtZXRhZGF0YSI6bnVsbCwib3B0aW9uX25hbWUiOm51bGx9LCJpc19idW5kbGVkIjpmYWxzZX1dLCJjaGlwc2V0X2luZm8iOnsiY2hpcHNldF9pZCI6IlMxMjQzNjM4MyIsImNoaXBzZXRfbmFtZSI6Im1kbV8yIiwiZWN1X2lkIjoxNDE3NTk1N30sInNvdXJjZV90eG5faWQiOiJVZVNzQ1l4NEYyVURrYjRPIiwidHhuX3R5cGUiOiJkZWxldGUiLCJzb3VyY2VfdHhuX3RzIjoxNjM1MTc4NDM1ODY1fV19",
		"trace_id": "cf4b6de0d5c2cddd",
		"span_id": "cf4b6de0d5c2cddd"
}
		
DECODED BODY :-
		
{
		    "delete_license_data": [{
		            "vin": "SIMV1634900189468",
		            "ecu_type": "ivi",
		            "sku_id": 1275,
		            "sku_name": "arjun_ivi_sku_v20",
		            "delete_serials": ["Skn39TMihP9S"],
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
		            "chipset_info": {
		                "chipset_id": "S12436383",
		                "chipset_name": "mdm_2",
		                "ecu_id": 14175957
		            },
		            "source_txn_id": "UeSsCYx4F2UDkb4O",
		            "txn_type": "delete",
		            "source_txn_ts": 1635178435865
		        }
		    ]
}

```

**Body**

|Attribute Name|Datatype|Mandatory| Length (bytes) |Description|
| :------------- | :------------ |:------------ |:------------: |:------------ |
|vin|String|Yes|17 |Vin number of the device |
|ecu_type|String|Yes| |Describes the type of ECU|
|chipset_info|Object|Yes| |ECU id, chipset id and chipset name details in chipset_info|
|sku_id|Integer|Yes| |Id of SKU|
|sku_name|String|Yes| |Name of SKU|
|delete_serials|Set of Strings|Yes| |List of delete searial numbers|
|feature_list|List of Objects|Yes| |List Of Features |
|source_txn_id|String|Yes| |Trasaction ID involved while calling LMS to install License|
|txn_type|String|Yes| |Describes the type of transaction. eg:install/Delete|
|source_txn_ts|Long|Yes| |Gives the current UTC Epoch value|


