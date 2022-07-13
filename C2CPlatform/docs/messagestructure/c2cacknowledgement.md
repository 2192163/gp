#C2C Acknowledgement
**Message Name** - C2C Acknowledgement.<br>
**Description** - Acknowledgement message sent by the receipient based on the flag set by the sender. <br>
**Structure** - Json<br>

## Message
  ```json
  {
    "message_id": "<source><UUID>",
    "correlation_id": "<source><UUID>",
    "version": "v1",
    "system_id": "sys<UUID>",
    "message_type": "{ORIGINALMESSAGETYPE}_ACK",
    "time": 1620891851,
    "body":  // Datatype string, below object will be base64 Encoded String
    {
  		"response": 0, 
      "error":111
    }
  }
  ```

 |Attribute Name|Datatype|Mandatory| Length (bytes) |Description|   
 | :------------- | :------------ |:------------ |:------------: |:------------ |    
 |message_id|String|Yes| | Identifier from the message which requested ACK.|    
 |version|String|Yes| |Message schema version|     
 |system_id|String|Yes| |Unique id generated at time of Registration for the system. Format is  c2csysUnique id|   
 |message_type|String|Yes| |Value of Message Type will ACK. |   
 |time|Numeric|Yes| |Message Creation Unix Timestamp. |     
 |body|String|Yes| |Encoded message.|  
 |body.response|Enum|Yes| |0 or 1.|    
 |body.error|Numeric|No| |If response is FAIL, check this field for specific error/cause.|   

 
 ##ACKResponseEnum
 {
     FAIL = 0,
     SUCCESS = 1
 }

