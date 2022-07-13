# ECU Device Registration

## Workflow


## Registration APIs

**Message Name** - Registration APIs<br>
**Description** -   <br>
**Source Application** - OEM Consumer application<br>
**Structure** - Json<br>

**APIs**

Below APIs will be used by the Consumer applicaiton to send . <br />

1.  __Endpoint__: https://{server}/device-request-processor/v1/device/registration <br>
    __Method__: POST <br>
    __Description__: 

    ```json title="Request" linenums="1"
    Headers: accept, content-type, content-length, authorization-token
    {

    }
    ```

    ```json title="Response" linenums="1"
    Headers: content-type, content-length
    
    {
        
    }
    ```

2.  __Endpoint__: https://{server}/device-registration-service/v1/registration/requests/{requestId} <br>
    __Method__: POST <br>
    __Description__: 

    ```json title="Response" linenums="1"
    Headers: content-type, content-length
    
    Response:
    {

    }
    ```

3.  __Endpoint__: https://{server}/device-registration-service/v1/registration/{requestId}/devices <br>
    __Method__: POST <br>
    __Description__: 

    ```json title="Response" linenums="1"
    Headers: content-type, content-length
    Response:
    {

    }
    ```


