
## SKU Service Message Types
|Value | Description|
| :---- | :----- |
| 1 | nonce | 
| 2 | attestation_report | 
| 3 | license |
| 4 | install_status |
| 5 | delete_license |
| 6 | delete_status |
| 7 | onboarding_nonce |
| 8 | onboarding_attestation_report |
| 9 | update_license |
| 10 | update_license_status |
| 12 | license_status |


## Operation status
|Value | Description|
| :---- | :----- |
| 0 | SUCCESS |
| 1 | EXPIRED_OR_NOTYETVALID |
| 2 | INVALID_CERT |
| 3 | INVALID_DEVICEID |
| 4 | INVALID_HWVERSION |
| 5 | INTERNAL_ERROR |
| 6 | DELETE_LICENSE_FAILED |
| 7 | INSTALL_LICENSE_FAILED |
