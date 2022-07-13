# Error Code Dictionary

List of all device wide error codes and its respective description. Every device components are provided with a set of defined range to be used for error and validation purposes.
Based on the error code, a consumer can take an action based on the severity of the error.

The error code should have 32 bits. C2C device send this error code as hex format to cloud with request/response message. Representation is given below,

| Category - 4 bits | Sub category - 8 bits | C2C Header Field ID - 8 bits | Error message - 4 bits | unused - 8 bits |
|-------------------|-----------------------|------------------------------|------------------------|-----------------|
| 0x0               | 0x00                  | 0x00                         | 0x0                    | 0x00            |


| category           | Corresponding Byte |
|--------------------|--------------------|
| [system error](#system-error)        | 0x1                |
| [configuration file](#configuration-file-errors)  | 0x2                |
| [connectivity](#connectivity-errors)        | 0x3                |
| [Business logic](#business-logic-errors)    | 0x4                |


## System Error

These error codes are common for all the system level errors like memory, i/o issues..etc. 
System error code Range is 0x10000000 to 0x1FFFFFFF.


| Category  (4 bits) | Sub Category ( 8 bits) | C2C Header Field ID (8 biits)                                                                               | Error Message (4 bits)                | unused (8 bits) | Error Code - hex value | Error Code - integer value | Remedial Action - <br/>Cloud |
|--------------------|------------------------|-------------------------------------------------------------------------------------------------------------|---------------------------------------|-----------------|------------------------|----------------------------|------------------------------|
| System Error : 0x1 | Success                |                                                                                                             |                                       |                 | 0x10000000             | 268435456                  |                              |
|                    | Memory :0x01           | Scope - Outside c2c code :0x01                                                                              | Memory (exceeds 80%) - 0x1            | 0x00            | 0x10101100             | 269488384                  | [Action1](#remedial-action)                      |
|                    |                        |                                                                                                             | Diskspace (Less than 10 MB) - 0x2     | 0x00            | 0x10101200             | 269488640                  | [Action1](#remedial-action)                      |
|                    |                        |                                                                                                             | CPU (CPU consumption exceeds 5%) -0x3 | 0x00            | 0x10101300             | 269488896                  | [Action1](#remedial-action)                      |
|                    |                        | Scope - Inside c2c code :0x02                                                                               | static array exceeds  - 0x4           | 0x00            | 0x10102400             | 269493248                  | [Action2](#remedial-action)                      |
|                    |                        |                                                                                                             | dynamic memory allocation fails -0x5  | 0x00            | 0x10102500             | 269493504                  | [Action1](#remedial-action)                      |
|                    |                        |                                                                                                             |                                       |                 |                        |                            |                              |
|                    | File - 0x02            | (first byte[MSB] for device and chipset name, 2nd byte [LSB] for the file name), check below table<br/>0x[XY](#xy-table) | Unable to read the file - 0x1         | 0x00            | 0x102[XY](#xy-table)100             | [Refer Table 1.1](#table-11)            | [Action 9](#remedial-action)                     |
|                    |                        |                                                                                                             | Unable to write the file -0x2         | 0x00            | 0x102[XY](#xy-table)200             | [Refer Table 1.2](#table-12)            | [Action 9](#remedial-action)                     |
|                    |                        |                                                                                                             | Unable to open file - 0x3             | 0x00            | 0x102[XY](#xy-table)300             | [Refer Table 1.3](#table-13)            | [Action 9](#remedial-action)                     |

<hr />

## Connectivity errors 

These error codes are common for all the c2c device connectivity issues like connection lost , mqtt issues, network issues ..etc. config error code Range is 0x30000000 to 0x3FFFFFFF.

| Category  (4 bits) | Sub Category ( 8 bits)   | C2C Header Field ID (8 biits) | Error Message (4 bits)                                                                     | unused (8 bits) | Error Code - hex value | Error code - integer value | Remedial Action - Cloud |
|--------------------|--------------------------|-------------------------------|--------------------------------------------------------------------------------------------|-----------------|------------------------|----------------------------|-------------------------|
| connectivity - 0x3 | Success                  |                               |                                                                                            |                 | 0x10000000             | 268435456                  |                         |
|                    | connection status - 0x01 | Cloud - 0x01                  | connection lost - 0x1                                                                      | 0x00            | 0x30101100             | 806359296                  | [Action 3](#remedial-action)                |
|                    |                          |                               | connection reconnect - 0x2                                                                 | 0x00            | 0x30101200             | 806359552                  | [Action 3](#remedial-action)                |
|                    |                          |                               | reconnect exceeds max limit - 0x3                                                          | 0x00            | 0x30101300             | 806359808                  | [Action 3](#remedial-action)                |
|                    |                          | Internal broker - 0x02        | connection lost - 0x1                                                                      | 0x00            | 0x30102100             | 806363392                  | [Action 3](#remedial-action)                |
|                    |                          |                               | connection reconnect - 0x2                                                                 | 0x00            | 0x30102200             | 806363648                  | [Action 3](#remedial-action)                |
|                    |                          |                               | reconnect exceeds max limit - 0x3                                                          | 0x00            | 0x30102300             | 806363904                  | [Action 2](#remedial-action)                |
|                    |                          |                               |                                                                                            |                 |                        |                            |                         |
|                    | Service - 0x02           | 0x00                          | No Range (External Network / LTE, 5G, DSRC,WLAN) - 0x1                                     | 0x00            | 0x30200100             | 807403776                  | [Action 3](#remedial-action)                |
|                    |                          | 0x00                          | C2C Cloud service not available / down - 0x2                                               | 0x00            | 0x30200200             | 807404032                  | [Action 3](#remedial-action)                |
|                    |                          | 0x00                          | Communication Link broken (Internal Network / Between TCU and IVI) - 0x3                   | 0x00            | 0x30200300             | 807404288                  | [Action 4](#remedial-action)                |
|                    |                          | 0x0[X](#x-table)                          | Service is not responding (ECU / Module Name)(Qualcomm SKU Service is not working,  )- 0x4 | 0x00            | 0x3020[X](#x-table)400             | [Refer Table 3](#table-3)              | [Action 2](#remedial-action)                |

<hr />

## Configuration file errors

These error codes are common for all the c2c device configuration file issues like file missing, corruption..etc. config error code Range is 0x20000000 to 0x2FFFFFFF.

| Category  (4 bits)       | Sub Category ( 8 bits)                                                                   | C2C Header Field ID (8 biits) | Error Message (4 bits)  | unused (8 bits) | Error Code- hex value | Error code - integer value | Remedial Action - Cloud |
|--------------------------|------------------------------------------------------------------------------------------|-------------------------------|-------------------------|-----------------|-----------------------|----------------------------|-------------------------|
| configuration file - 0x2 | Success                                                                                  |                               |                         |                 | 0x10000000            | 268435456                  |                         |
|                          | sideloaded.conf -0x01                                                                    | 0x00                          | File Missing - 0x1      | 0x00            | 0x20100100            | 537919744                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20100200            | 537920000                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | url_cloud - 0x01              | Invalid/NULL/Empty -0x3 | 0x00            | 0x20101300            | 537924352                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | CA_PATH - 0x02                |                         | 0x00            | 0x20102300            | 537928448                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | root_path - 0x03              |                         | 0x00            | 0x20103300            | 537932544                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | client_cert_path -0x04        |                         | 0x00            | 0x20104300            | 537936640                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | priv_key_path -0x05           |                         | 0x00            | 0x20105300            | 537940736                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | vehicle_state - 0x06          |                         | 0x00            | 0x20106300            | 537944832                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | system_id - 0x07              |                         | 0x00            | 0x20107300            | 537948928                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | deviceId - 0x08               |                         | 0x00            | 0x20108300            | 537953024                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | c2c.conf -0x02                                                                           | 0x00                          | File Missing - 0x1      | 0x00            | 0x20200100            | 538968320                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20200200            | 538968576                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | vin -0x01                     | Invalid/NULL/Empty -0x3 | 0x00            | 0x20201300            | 538972928                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | DOOR_LOCK - 0x02              |                         | 0x00            | 0x20202300            | 538977024                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | sub_system_id -0x03           |                         | 0x00            | 0x20203300            | 538981120                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | c2c_vehicle_conf - 0x04       |                         | 0x00            | 0x20204300            | 538985216                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | Comm_Protocol - 0x05          |                         | 0x00            | 0x20205300            | 538989312                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | Comm_Port - 0x06              |                         | 0x00            | 0x20206300            | 538993408                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | ecu_type - 0x07               |                         | 0x00            | 0x20207300            | 538997504                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | source_id - 0x08              |                         | 0x00            | 0x20208300            | 539001600                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | target_id - 0x09              |                         | 0x00            | 0x20209300            | 539005696                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | cloud_qos -0x0A               |                         | 0x00            | 0x2020A300            | 539009792                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | c2c_vehicle.json - 0x03                                                                  | 0x00                          | File Missing - 0x1      | 0x00            | 0x20300100            | 540016896                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20300200            | 540017152                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | Subsystem ID - 0x01           | Invalid/NULL/Empty -0x3 | 0x00            | 0x20301300            | 540021504                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | Device id - 0x02              |                         | 0x00            | 0x20302300            | 540025600                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | primary chipset - 0x03        |                         | 0x00            | 0x20303300            | 540029696                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | chipset count - 0x04          |                         | 0x00            | 0x20304300            | 540033792                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | region info - 0x05            |                         | 0x00            | 0x20305300            | 540037888                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | vehicle info - 0x06           |                         | 0x00            | 0x20306300            | 540041984                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | device info - 0x07            |                         | 0x00            | 0x20307300            | 540046080                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | softsku.conf - 0x04                                                                      | 0x00                          | File Missing - 0x1      | 0x00            | 0x20400100            | 541065472                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20400200            | 541065728                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | sub topic - 0x01              | Invalid/NULL/Empty -0x3 | 0x00            | 0x20401300            | 541070080                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | pub topic -0x02               |                         | 0x00            | 0x20402300            | 541074176                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | broker url - 0x03             |                         | 0x00            | 0x20403300            | 541078272                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | client id -0x04               |                         | 0x00            | 0x20404300            | 541082368                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | cacert.pem - 0x05                                                                        | 0x00                          | File Missing - 0x1      | 0x00            | 0x20500100            | 542114048                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20500200            | 542114304                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | clientcert.pem - 0x06                                                                    | 0x00                          | File Missing - 0x1      | 0x00            | 0x20600100            | 543162624                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20600200            | 543162880                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | private.pem - 0x07                                                                       | 0x00                          | File Missing - 0x1      | 0x00            | 0x20700100            | 544211200                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20700200            | 544211456                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | ota_session.json - 0x08                                                                  | 0x00                          | File Missing - 0x1      | 0x00            | 0x20800100            | 545259776                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20800200            | 545260032                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | ota.conf - 0x09                                                                          | 0x00                          | File Missing - 0x1      | 0x00            | 0x20900100            | 546308352                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20900200            | 546308608                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | sub topic - 0x01              | Invalid/NULL/Empty -0x3 | 0x00            | 0x20901300            | 546312960                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | pub topic -0x02               |                         | 0x00            | 0x20902300            | 546317056                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | broker url - 0x03             |                         | 0x00            | 0x20903300            | 546321152                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | client id -0x04               |                         | 0x00            | 0x20904300            | 546325248                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | (MSB[[X](#x-table)] using for identifying chipset name and device, check below table) dm.conf - 0x[X](#x-table)A | 0x00                          | File Missing - 0x1      | 0x00            | 0x2[X](#x-table)A00100            | [Refer Table 2](#table-2)              | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x2[X](#x-table)A00200            | [Refer Table 2](#table-2)               | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | sub topic - 0x01              | Invalid/NULL/Empty -0x3 | 0x00            | 0x2[X](#x-table)A01300            | [Refer Table 2](#table-2)               | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | pub topic -0x02               |                         | 0x00            | 0x2[X](#x-table)A02300            | [Refer Table 2](#table-2)               | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | broker url - 0x03             |                         | 0x00            | 0x2[X](#x-table)A03300            | [Refer Table 2](#table-2)              | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | chipset conf path -0x04       |                         | 0x00            | 0x2[X](#x-table)A04300            | [Refer Table 2](#table-2)              | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | client id -0x05               |                         | 0x00            | 0x2[X](#x-table)A05300            | [Refer Table 2](#table-2)              | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | device_id -0x06               |                         | 0x00            | 0x2[X](#x-table)A06300            | [Refer Table 2](#table-2)              | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | sub_system_id -0x07           |                         | 0x00            | 0x2[X](#x-table)A07300            | [Refer Table 2](#table-2)              | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          |                               |                         |                 |                       |                            |                         |
|                          | dm_chipset.conf - 0x0B                                                                   | 0x00                          | File Missing - 0x1      | 0x00            | 0x20B00100            | 548405504                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | 0x00                          | File Corrupted - 0x2    | 0x00            | 0x20B00200            | 548405760                  | [Action 9 & Comment 1](#remedial-action)    |
|                          |                                                                                          | device id - 0x01              | Invalid/NULL/Empty -0x3 | 0x00            | 0x20B01300            | 548410112                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | name - 0x02                   |                         | 0x00            | 0x20B02300            | 548414208                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | sku id - 0x03                 |                         | 0x00            | 0x20B03300            | 548418304                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | type - 0x04                   |                         | 0x00            | 0x20B04300            | 548422400                  | [Action 2 & Comment 1](#remedial-action)    |
|                          |                                                                                          | version - 0x05                |                         | 0x00            | 0x20B05300            | 548426496                  | [Action 2 & Comment 1](#remedial-action)    |

<hr />

## BUSINESS Logic Errors

These error codes are common for all the c2c device source code  issues like message contract violations, business logic module issues..etc. config error code Range is 0x40000000 to 0x4FFFFFFF.

| Category  (4 bits) | Sub Category ( 8 bits)        | C2C Header Field ID (8 biits) | Error Message (4 bits)                                                                                                                       | unused (8 bits) | Error Code - hex value | Error Code - integer value | Remedial Action - Cloud |
|--------------------|-------------------------------|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|-----------------|------------------------|----------------------------|-------------------------|
| Business - 0x4     | Success                       |                               |                                                                                                                                              |                 | 0x10000000             | 268435456                  |                         |
|                    | schema validation - 0x01      | 0x00                          | Payload exceeds limit - 0x1                                                                                                                  | 0x00            | 0x40100100             | 1074790656                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               | 0x00                          | Payload is invalid - 0x2                                                                                                                     | 0x00            | 0x40100200             | 1074790912                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               | 0x00                          | Message type is Invalid - 0x3                                                                                                                | 0x00            | 0x40100300             | 1074791168                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               | 0x00                          | Message expired by time - 0x4                                                                                                                | 0x00            | 0x40100400             | 1074791424                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               | message_id - 0x01             | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40101100             | 1074794752                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40101200             | 1074795008                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40101300             | 1074795264                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | correlation_id - 0x02         | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40102100             | 1074798848                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40102200             | 1074799104                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40102300             | 1074799360                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | message_type - 0x03           | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40103100             | 1074802944                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40103200             | 1074803200                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40103300             | 1074803456                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | target_id - 0x04              | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40104100             | 1074807040                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40104200             | 1074807296                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40104300             | 1074807552                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | source_id - 0x05              | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40105100             | 1074811136                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40105200             | 1074811392                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40105300             | 1074811648                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | version - 0x06                | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40106100             | 1074815232                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40106200             | 1074815488                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40106300             | 1074815744                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | device_id - 0x07              | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40107100             | 1074819328                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40107200             | 1074819584                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40107300             | 1074819840                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | ecu_type - 0x08               | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x40108100             | 1074823424                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x40108200             | 1074823680                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x40108300             | 1074823936                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | time - 0x09                   | Missing fields - 0x1                                                                                                                         | 0x00            | 0x40109100             | 1074827520                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x2                                                                                                                      | 0x00            | 0x40109200             | 1074827776                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | ttl - 0x0A                    | Missing fields - 0x1                                                                                                                         | 0x00            | 0x4010A100             | 1074831616                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x2                                                                                                                      | 0x00            | 0x4010A200             | 1074831872                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | status- 0x0B                  | Missing fields - 0x1                                                                                                                         | 0x00            | 0x4010B100             | 1074835712                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x2                                                                                                                      | 0x00            | 0x4010B200             | 1074835968                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | property_bag- 0x0C            | Missing fields - 0x1                                                                                                                         | 0x00            | 0x4010C100             | 1074839808                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x2                                                                                                                      | 0x00            | 0x4010C200             | 1074840064                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | body - 0x0D                   | Missing fields - 0x1                                                                                                                         | 0x00            | 0x4010D100             | 1074843904                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x2                                                                                                                      | 0x00            | 0x4010D200             | 1074844160                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Format issue (unable to encode Base64 format) - 0x3                                                                                          | 0x00            | 0x4010D300             | 1074844416                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Format issue (unable to decode Base64 format) - 0x4                                                                                          | 0x00            | 0x4010D400             | 1074844672                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | system_id - 0x0E              | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x4010E100             | 1074848000                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x4010E200             | 1074848256                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x4010E300             | 1074848512                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Not matching with conf file -0x4                                                                                                             | 0x00            | 0x4010E400             | 1074848768                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | sub_system_id - 0x0F          | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x4010F100             | 1074852096                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x4010F200             | 1074852352                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x4010F300             | 1074852608                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Not matching with conf file -0x4                                                                                                             | 0x00            | 0x4010F400             | 1074852864                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               | vin - 0x1F                    | Size exceeds  max limit -0x1                                                                                                                 | 0x00            | 0x4011F100             | 1074917632                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Missing fields - 0x2                                                                                                                         | 0x00            | 0x4011F200             | 1074917888                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Invalid data type - 0x3                                                                                                                      | 0x00            | 0x4011F300             | 1074918144                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               | Not matching with conf file -0x4                                                                                                             | 0x00            | 0x4011F400             | 1074918400                 | [Action 7 & Comment 1](#remedial-action)    |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    | Module status - 0x02          | 0x00                          | Business logic is not running (Module Name: C2C Hub/ DM/ SoftSKU Manager, OTA Manager) - 0x1                                                 | 0x00            | 0x40200100             | 1075839232                 | [Action 4](#remedial-action)                |
|                    |                               | 0x00                          | Fail to start module (Module Name: C2C Hub/ DM/ SoftSKU Manager, OTA Manager) - 0x2                                                          | 0x00            | 0x40200200             | 1075839488                 | [Action 4](#remedial-action)                |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    |                               |                               |                                                                                                                                              |                 |                        |                            |                         |
|                    | Message Retransmission - 0x03 | Provision query - 0x01        | Exceeeds retry limit , cloud not sending response - 0x1                                                                                      | 0x00            | 0x40301100             | 1076891904                 | [Action 8](#remedial-action)                |
|                    |                               |                               | Exceeeds retry limit , cloud sending failure response- 0x2                                                                                   | 0x00            | 0x40301200             | 1076892160                 |                         |
|                    |                               | Device Provision - 0x02       | Exceeeds retry limit ,cloud not sending response- 0x1                                                                                        | 0x00            | 0x40302100             | 1076896000                 | [Action 8](#remedial-action)                |
|                    |                               |                               | Exceeeds retry limit, cloud sending failure response - 0x2                                                                                   | 0x00            | 0x40302200             | 1076896256                 |                         |
|                    |                               | CPA - 0x03                    | not receiving the entire number of  CPA message from DM module or receiving failure message from Qualcomm sku service within a timeout - 0x1 | 0x00            | 0x40303100             | 1076900096                 | [Action 8](#remedial-action)                |
|                    |                               |                               | received CPA from DM , more than chipset count entered in c2c_vehicle.json - 0x2                                                             | 0x00            | 0x40303200             | 1076900352                 | [Action8](#remedial-action)                  |

<hr />

## Execution 

| Code | Error | Description |  
|:------:|:-------|:-------------|  
| | | |

<hr />

## Response to cloud 

| Code | Error | Description |  
|:------:|:-------|:-------------|  
| | | |

<hr />

## Remedial Action

| Remedial Action  | Action                                                                                                                                                                                 | Device/Cloud     |
|------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| Action 1         | Cloud resend the request up to n number of times. If it's not resolving the problem, cloud should send notification to the OEM                                                         | Cloud            |
| Action 2         | cloud should send notification to the OEM                                                                                                                                              | Cloud            |
| Action 3         | Internal to device, not sending this error code to cloud                                                                                                                               | Device           |
| Action 4         | Internal to device. Not implemented.                                                                                                                                                   | Device           |
| Action 5         | may be removed on later                                                                                                                                                                | Device           |
| Action 6         | may be added on later                                                                                                                                                                  | Device           |
| Action 7         | cloud should resend the message with proper correction, up to n number of times. If it's not resolving the problem, the cloud should send a notification to the OEM                    | Cloud            |
| Action 8         | This will happen before delivering the vehicle to the customer. So dealer should address this issue. The device sends the error to the cloud and the cloud notifies this error to OEM. | Cloud and device |
| Action 9         | Mostly used for device logging.Not sending to cloud now. This feature may be added on later. If cloud receives this error, send notification to oem.                                   | Cloud and device |
| Comment 1        |  It may change  after config file and message optimization.                                                                                                                            | Cloud and device |

## X Table

| chipset identifier | X |
|--------------------|---|
| TCU , vt           | 1 |
| TCU, mdm1          | 2 |
| IVI, 1             | 3 |
| IVI, 2             | 4 |
| IVI, 3             | 5 |
| IVI, 4             | 6 |
| ADAS,1             | 7 |
| ADAS,2             | 8 |
| ADAS,3             | 9 |
| ADAS,4             | A |

## Y Table

| file name         | Y |
|-------------------|---|
| side_loaded.conf  | 1 |
| c2c.conf          | 2 |
| c2c_vehicle.json  | 3 |
| softsku.conf      | 4 |
| cacert.pem        | 5 |
| clientcert.pem    | 6 |
| private.pem       | 7 |
| ota.conf          | 8 |
| ota_session.json  | 9 |
| dm.conf  for,     | A |

## XY Table

| [X(Column)](#x-table)/[Y(Row))](#y-table) | 1                                      | 2                               | 3                                       | 4                                   | 5                                 | 6                                     | 7                                  | 8                               | 9                                       | A                               |
|-----|----------------------------------------|---------------------------------|-----------------------------------------|-------------------------------------|-----------------------------------|---------------------------------------|------------------------------------|---------------------------------|-----------------------------------------|---------------------------------|
| 1   | Sideloaded.conf,<br/>TCU, vt device    | c2c.conf,<br/>TCU, vt device    | c2c_vehicle.json ,<br/>TCU, vt device   | softsku.conf ,<br/>TCU, vt device   | cacert.pem ,<br/>TCU, vt device   | clientcert.pem ,<br/>TCU, vt device   | private.pem ,<br/>TCU, vt device   | ota.conf ,<br/>TCU, vt device   | ota_session.json ,<br/>TCU, vt device   | dm.conf  ,<br/>TCU, vt device   |
| 2   | Sideloaded.conf,<br/> TCU, mdm1 device | c2c.conf,<br/> TCU, mdm1 device | c2c_vehicle.json,<br/> TCU, mdm1 device | softsku.conf,<br/> TCU, mdm1 device | cacert.pem,<br/> TCU, mdm1 device | clientcert.pem,<br/> TCU, mdm1 device | private.pem,<br/> TCU, mdm1 device | ota.conf,<br/> TCU, mdm1 device | ota_session.json,<br/> TCU, mdm1 device | dm.conf ,<br/> TCU, mdm1 device |
| 3   | Sideloaded.conf,<br/>IVI, 1 device     | c2c.conf,<br/>IVI, 1 device     | c2c_vehicle.json,<br/>IVI, 1 device     | softsku.conf,<br/>IVI, 1 device     | cacert.pem,<br/>IVI, 1 device     | clientcert.pem,<br/>IVI, 1 device     | private.pem,<br/>IVI, 1 device     | ota.conf,<br/>IVI, 1 device     | ota_session.json,<br/>IVI, 1 device     | dm.conf ,<br/>IVI, 1 device     |
| 4   | Sideloaded.conf,<br/>IVI, 2 device     | c2c.conf,<br/>IVI, 2 device     | c2c_vehicle.json,<br/>IVI, 2 device     | softsku.conf,<br/>IVI, 2 device     | cacert.pem,<br/>IVI, 2 device     | clientcert.pem,<br/>IVI, 2 device     | private.pem,<br/>IVI, 2 device     | ota.conf,<br/>IVI, 2 device     | ota_session.json,<br/>IVI, 2 device     | dm.conf ,<br/>IVI, 2 device     |
| 5   | Sideloaded.conf ,<br/>IVI, 3 device    | c2c.conf ,<br/>IVI, 3 device    | c2c_vehicle.json,<br/>IVI, 3 device     | softsku.conf ,<br/>IVI, 3 device    | cacert.pem ,<br/>IVI, 3 device    | clientcert.pem ,<br/>IVI, 3 device    | private.pem ,<br/>IVI, 3 device    | ota.conf ,<br/>IVI, 3 device    | ota_session.json ,<br/>IVI, 3 device    | dm.conf  ,<br/>IVI, 3 device    |
| 6   | Sideloaded.conf,<br/>IVI, 4 device     | c2c.conf,<br/>IVI, 4 device     | c2c_vehicle.json,<br/>IVI, 4 device     | softsku.conf,<br/>IVI, 4 device     | cacert.pem,<br/>IVI, 4 device     | clientcert.pem,<br/>IVI, 4 device     | private.pem,<br/>IVI, 4 device     | ota.conf,<br/>IVI, 4 device     | ota_session.json,<br/>IVI, 4 device     | dm.conf ,<br/>IVI, 4 device     |
| 7   | Sideloaded.conf<br/>ADAS, 1 device     | c2c.conf,<br/>ADAS, 1 device    | c2c_vehicle.json,<br/>ADAS, 1 device    | softsku.conf,<br/>ADAS, 1 device    | cacert.pem,<br/>ADAS, 1 device    | clientcert.pem,<br/>ADAS, 1 device    | private.pem,<br/>ADAS, 1 device    | ota.conf,<br/>ADAS, 1 device    | ota_session.json,<br/>ADAS, 1 device    | dm.conf ,<br/>ADAS, 1 device    |
| 8   | Sideloaded.conf ,<br/>ADAS, 2 device   | c2c.conf ,<br/>ADAS, 2 device   | c2c_vehicle.json,<br/>ADAS, 2 device    | softsku.conf,<br/>ADAS, 2 device    | cacert.pem,<br/>ADAS, 2 device    | clientcert.pem,<br/>ADAS, 2 device    | private.pem,<br/>ADAS, 2 device    | ota.conf,<br/>ADAS, 2 device    | ota_session.json,<br/>ADAS, 2 device    | dm.conf ,<br/>ADAS, 2 device    |
| 9   | Sideloaded.conf,<br/>ADAS, 4 device    | c2c.conf,<br/>ADAS, 4 device    | c2c_vehicle.json,<br/>ADAS, 4 device    | softsku.conf,<br/>ADAS, 4 device    | cacert.pem,<br/>ADAS, 4 device    | clientcert.pem,<br/>ADAS, 4 device    | private.pem,<br/>ADAS, 4 device    | ota.conf,<br/>ADAS, 4 device    | ota_session.json,<br/>ADAS, 4 device    | dm.conf ,<br/>ADAS, 4 device    |
| A   | Sideloaded.conf,<br/>ADAS, 5 device    | c2c.conf,<br/>ADAS, 5 device    | c2c_vehicle.json,<br/>ADAS, 5 device    | softsku.conf,<br/>ADAS, 5 device    | cacert.pem,<br/>ADAS, 5 device    | clientcert.pem,<br/>ADAS, 5 device    | private.pem,<br/>ADAS, 5 device    | ota.conf,<br/>ADAS, 5 device    | ota_session.json,<br/>ADAS, 5 device    | dm.conf ,<br/>ADAS, 5 device    |

## Table 1.1

- Unable to read the file - 0x102XY100

| X(coloumn)/Y(row) | Sideloaded.conf | c2c.conf  | c2c_vehicle.json | softsku.conf | cacert.pem | clientcert.pem | private.pem | ota.conf  | ota_session.json | dm.conf   |
|-------------------|-----------------|-----------|------------------|--------------|------------|----------------|-------------|-----------|------------------|-----------|
| TCU , vt          | 270602496       | 270606592 | 270610688        | 270614784    | 270618880  | 270622976      | 270627072   | 270631168 | 270635264        | 270639360 |
| TCU, mdm1         | 270668032       | 270672128 | 270676224        | 270680320    | 270684416  | 270688512      | 270692608   | 270696704 | 270700800        | 270704896 |
| IVI, 1            | 270668032       | 270737664 | 270741760        | 270745856    | 270749952  | 270754048      | 270758144   | 270762240 | 270766336        | 270770432 |
| IVI, 2            | 270799104       | 270803200 | 270807296        | 270811392    | 270815488  | 270819584      | 270823680   | 270827776 | 270831872        | 270835968 |
| IVI, 3            | 270864640       | 270868736 | 270872832        | 270876928    | 270881024  | 270885120      | 270889216   | 270893312 | 270897408        | 270901504 |
| IVI, 4            | 270930176       | 270934272 | 270938368        | 270942464    | 270946560  | 270950656      | 270954752   | 270958848 | 270962944        | 270967040 |
| ADAS,1            | 270995712       | 270999808 | 271003904        | 271008000    | 271012096  | 271016192      | 271020288   | 271024384 | 271028480        | 271032576 |
| ADAS,2            | 270995712       | 271065344 | 271069440        | 271073536    | 271077632  | 271081728      | 271085824   | 271089920 | 271094016        | 271098112 |
| ADAS,3            | 271126784       | 271130880 | 271134976        | 271139072    | 271143168  | 271147264      | 271151360   | 271155456 | 271159552        | 271163648 |
| ADAS,4            | 271192320       | 271196416 | 271200512        | 271204608    | 271208704  | 271212800      | 271216896   | 271220992 | 271225088        | 271229184 |


## Table 1.2

- Unable to write the file - 0x102XY200

| X(coloumn)/Y(row) | Sideloaded.conf | c2c.conf  | c2c_vehicle.json | softsku.conf | cacert.pem | clientcert.pem | private.pem | ota.conf  | ota_session.json | dm.conf   |
|-------------------|-----------------|-----------|------------------|--------------|------------|----------------|-------------|-----------|------------------|-----------|
| TCU , vt          | 270602752       | 270606848 | 270610944        | 270615040    | 270619136  | 270623232      | 270627328   | 270631424 | 270635520        | 270639616 |
| TCU, mdm1         | 270668288       | 270672384 | 270676480        | 270680576    | 270684672  | 270688768      | 270692864   | 270696960 | 270701056        | 270705152 |
| IVI, 1            | 270733824       | 270737920 | 270742016        | 270746112    | 270750208  | 270754304      | 270758400   | 270762496 | 270766592        | 270770688 |
| IVI, 2            | 270799360       | 270803456 | 270807552        | 270811648    | 270815744  | 270819840      | 270823936   | 270828032 | 270832128        | 270836224 |
| IVI, 3            | 270864896       | 270868992 | 270873088        | 270877184    | 270881280  | 270885376      | 270889472   | 270893568 | 270897664        | 270901760 |
| IVI, 4            | 270930432       | 270934528 | 270938624        | 270942720    | 270946816  | 270950912      | 270955008   | 270959104 | 270963200        | 270967296 |
| ADAS,1            | 270799360       | 271000064 | 271004160        | 271008256    | 271012352  | 271016448      | 271020544   | 271024640 | 271028736        | 271032832 |
| ADAS,2            | 271061504       | 271065600 | 271069696        | 271073792    | 271077888  | 271081984      | 271086080   | 271090176 | 271094272        | 271098368 |
| ADAS,3            | 271127040       | 271131136 | 271135232        | 271139328    | 271143424  | 271147520      | 271151616   | 271155712 | 271159808        | 271163904 |
| ADAS,4            | 271192576       | 271196672 | 271200768        | 271204864    | 271208960  | 271213056      | 271217152   | 271221248 | 271225344        | 271229440 |


## Table 1.3

- Unable to open the file - 0x102XY300

| X(coloumn)/Y(row) | Sideloaded.conf | c2c.conf  | c2c_vehicle.json | softsku.conf | cacert.pem | clientcert.pem | private.pem | ota.conf  | ota_session.json | dm.conf   |
|-------------------|-----------------|-----------|------------------|--------------|------------|----------------|-------------|-----------|------------------|-----------|
| TCU , vt          | 270603008       | 270607104 | 270611200        | 270615296    | 270619392  | 270623488      | 270627584   | 270631680 | 270635776        | 270639872 |
| TCU, mdm1         | 270668544       | 270672640 | 270676736        | 270680832    | 270684928  | 270689024      | 270693120   | 270697216 | 270701312        | 270705408 |
| IVI, 1            | 270734080       | 270738176 | 270742272        | 270746368    | 270750464  | 270754560      | 270758656   | 270762752 | 270766848        | 270770944 |
| IVI, 2            | 270799616       | 270803712 | 270807808        | 270811904    | 270816000  | 270820096      | 270824192   | 270828288 | 270832384        | 270836480 |
| IVI, 3            | 270865152       | 270869248 | 270873344        | 270877440    | 270881536  | 270885632      | 270889728   | 270893824 | 270897920        | 270902016 |
| IVI, 4            | 270930688       | 270934784 | 270938880        | 270942976    | 270947072  | 270951168      | 270955264   | 270959360 | 270963456        | 270967552 |
| ADAS,1            | 270996224       | 271000320 | 271004416        | 271008512    | 271012608  | 271016704      | 271020800   | 271024896 | 271028992        | 271033088 |
| ADAS,2            | 271061760       | 271065856 | 271069952        | 271074048    | 271078144  | 271082240      | 271086336   | 271090432 | 271094528        | 271098624 |
| ADAS,3            | 271127296       | 271131392 | 271135488        | 271139584    | 271143680  | 271147776      | 271151872   | 271155968 | 271160064        | 271164160 |
| ADAS,4            | 271192832       | 271196928 | 271201024        | 271205120    | 271209216  | 271213312      | 271217408   | 271221504 | 271225600        | 271229696 |


## Table 2

- Expected value  - dm.conf

| Device and Chipset Name(column)\Errors(row) | File Missing | File Corrupted | /NULL/empty/Invalid |           |            |                   |           |           |               |
|---------------------------------------------|--------------|----------------|---------------------|-----------|------------|-------------------|-----------|-----------|---------------|
|                                             |              |                | sub topic           | pub topic | broker url | chipset conf path | client id | Device_id | Sub_system_id |
| TCU , vt                                    | 564134144    | 564134400      | 564138752           | 564142848 | 564146944  | 564151040         | 564155136 | 564159232 | 564163328     |
| TCU, mdm1                                   | 580911360    | 580911616      | 580915968           | 580920064 | 580924160  | 580928256         | 580932352 | 580936448 | 580940544     |
| IVI, 1                                      | 597688576    | 597688832      | 597693184           | 597697280 | 597701376  | 597705472         | 597709568 | 597713664 | 597717760     |
| IVI, 2                                      | 614465792    | 614466048      | 614470400           | 614474496 | 614478592  | 614482688         | 614486784 | 614490880 | 614494976     |
| IVI, 3                                      | 631243008    | 631243264      | 631247616           | 631251712 | 631255808  | 631259904         | 631264000 | 631268096 | 631272192     |
| IVI, 4                                      | 648020224    | 648020480      | 648024832           | 648028928 | 648033024  | 648037120         | 648041216 | 648045312 | 648049408     |
| ADAS,1                                      | 664797440    | 664797696      | 664802048           | 664806144 | 664810240  | 664814336         | 664818432 | 664822528 | 664826624     |
| ADAS,2                                      | 681574656    | 681574912      | 681579264           | 681583360 | 681587456  | 681591552         | 681595648 | 681599744 | 681603840     |
| ADAS,3                                      | 698351872    | 698352128      | 698356480           | 698360576 | 698364672  | 698368768         | 698372864 | 698376960 | 698381056     |
| ADAS,4                                      | 715129088    | 715129344      | 715133696           | 715137792 | 715141888  | 715145984         | 715150080 | 715154176 | 715158272     |


## Table 3 

- Expected values

| Device and Chipset Name(column)\Errorsrow) | Service is not responding  |
|--------------------------------------------|----------------------------|
| TCU , vt                                   | 807408640                  |
| TCU, mdm1                                  | 807412736                  |
| IVI, 1                                     | 807416832                  |
| IVI, 2                                     | 807420928                  |
| IVI, 3                                     | 807425024                  |
| IVI, 4                                     | 807429120                  |
| ADAS,1                                     | 807433216                  |
| ADAS,2                                     | 807437312                  |
| ADAS,3                                     | 807441408                  |
| ADAS,4                                     | 807445504                  |











