---
title: Provisioning Plan
---

# **C2C Platform Infrastructure Provisioning Plan** 

- [Introduction](#introduction)      
    - [Overview](#overview)        
    - [In Scope](#in-scope)      
    - [Out of scope](#out-of-scope)      
    - [Dependencies](#dependencies)      
    - [Assumptions](#assumptions)      
- [Solution](#solution)      
    - [Cloud Infrastructure provision solution](#cloud-infrastructure-provision-solution)      
    - [Cloud Security solution](#cloud-security-solution)      
- [Provisioning Details](#provisioning-details)      
    - [Environments & hosting regions](#environments--hosting-regions)      
    - [Naming convention](#naming-convention)      
    - [VPC, Network and Subnets](#vpc-network-and-subnets)      
    - [Kubernetes](#kubernetes)      
      - [API](#api)      
    - [IoT Core](#iot-core)      
    - [Message Brokers](#message-brokers)      
    - [Storage](#storage)      
      - [S3](#s3)      
      - [Relational Database](#relational-database) 
      - [Non-Relational Database](#Non-relational-database)       
- [References](#references)      
- [Change Log](#change-log)      



## Introduction

### Overview

### In Scope
This document limits itself to the deployment architecture and its various AWS components, this document explains about Global and Regional deployments.

### Out of scope
The application architecture of Global and Regional is out of scope of this document, this is only deployment document. 

### Dependencies
    
### Assumptions
    

### Solution

#### Cloud Infrastructure provision solution
Infrastructure provisioning using terraform (infrastructure as code).

#### Cloud Security solution
Provisioning databases in private subnets, applying kms to encrypt data at rest, keeping S3 bucket as private, running Kubernetes services in private subnets, security groups not opening to public and allowing only the required traffic, using Cognito, Lambda as authorizers at API Gateway level

### Provisioning Details

#### Environments & hosting regions
<br/>

| **Environments** | **Regions**  |
| :-----------  | :---------- |
| Dev Global   | us-east-1  |
| Dev Regional | us-west-1	|
| QA Global	   | us-east-2	|
| QA Regional  | us-west-2	|
| Demo Global  | eu-west-1  |
| Demo Regional| eu-west-2  |
<br />

#### Naming convention
<hr/>

Resource Name Syntax : {_domain_}-{_region_}-{_Environment_}-{_Partition Type_}-{_Project_}-{_ResourceType_}-({_Role_}) |                  
Example: c2c-use1-dev-reg-commc-sqs-senderinput 

Below is the list of abbrevations and elements used in the name formation.

| **Domain**	   | **Abbreviation** 
| :-----------  | :---------- |
| QualcommC2C  | c2c |
| **Environment**  |  | 
| Development  | dev | 
| Test	       | tst | 
| Staging	   | stg | 
| Production     |prd | 
| Demo         | demo| 
| **Partition Type** |	 | 
| Global	| gbl | 
| Regional	| reg | 
| **Region** 	 |  |  
| us-east-1	| use1 |  
| us-east-2	| use2 |  
| us-west-1	 | usw1 |  
| us-west-2	|usw2 |
| eu-west-1 |euw1 |
|eu-west-2  |euw2 |
| **Project**          |  | 
| C2CCommunicationCore	| commc | 
| DeviceManagement	    | devicm | 
| CertificateManagement	| cmrtm | 
| SKUManagement	 | skuma | 
| **AWS Resource Type** |	|  
| SQS | sqs |  
| SNS |	sns |  
| S3  |	s3b |   
| EKS Cluster |	eksc |  
| EKS Node Group |	eksng |  
| Kinesis |	kins | 
| Dynamo DB | dydb |

#### Tags

|**Tag Name**|**Value**|
| :-----------  | :---------- |
| ApplicationAcronym|C2C |
| Environment |Development/Testing/Demo |
| FunctionalArea | DeviceManagement/Core/Base |
| Owner | \<Owner name> |
| OwnerEmail | \<Email of owner> |
| Partition|Global/Regional |
<br />

#### VPC, Network and Subnets

<br />

| **Environment** |	**Virtual Network Name** | **CIDR Range** | **Subnet name** | **IP Address range** |
| ----------- | ----------- | -----------  | ---------- |  ---------- |
| Dev Global |	c2c_eu1_dev_gbl_vpc	| 10.165.64.0/20 | DEV_ENV-us-east-1a-public-subnet <br />DEV_ENV-us-east-1a-private-subnet <br />DEV_ENV-us-east-1b-public-subnet <br />DEV_ENV-us-east-1b-private-subnetsubnet <br />| 10.165.64.0/24<br />10.165.66.0/24<br />10.165.65.0/24<br />10.165.67.0/24<br /> |
| Dev regional | c2c_wu1_dev_rg_vpc	| 10.164.48.0/20  |	dev-regional-us-west-1c-public-subnet<br />dev-regional-us-west-1b-public-subnet<br />dev-regional-us-west-1c-private-subnet<br />dev-regional-us-west-1b-private-subnet<br /> | 10.164.52.0/24<br />10.164.51.0/24<br />10.164.50.0/24<br />10.164.49.0/24<br /> |
| QA Global	| c2c-kuberenetes-qa | 10.162.48.0/20 |	subnet-0380c65b0adb4a556<br />subnet-00f966a2e4c874130<br />subnet-096c89f56a421a8f7<br /> subnet-02e22d25eb7eed27b<br /> | 10.162.52.0/24<br /> 10.162.49.0/24<br />10.162.50.0/24<br />10.162.51.0/24 <br />|
| QA Regional |	c2c-kubernetes-qa-regional | 10.163.48.0/20 | subnet-0efa168146b25c0fc <br />subnet-0d1f4a100fe75cd5e <br />subnet-0dbca44661f0f0c10 <br />subnet-0373d9f85e88bb890<br /> | 10.163.49.0/24<br />10.163.51.0/24<br /> 10.163.52.0/24 <br />10.163.50.0/24 <br />|
| DEMO Global |	c2c_euw1_demo_gbl_vpc | 10.0.0.0/16 | subnet-0e7323a857367c5e8 <br />subnet-0d42fb8add658fdf2 <br />subnet-0ff72964e99666b36 <br />subnet-030eb44c46dec97cc<br /> | 10.0.32.0/20<br />10.0.48.0/20<br /> 10.0.0.0/20 <br />10.0.16.0/20 <br />|
| DEMO Regional |	c2c_euw2_demo_reg_vpc | 10.1.0.0/16 | subnet-0ac145c6c9bbb29d2 <br />subnet-0a52eea19057a46f2 <br />subnet-0a0008de90c81eb34 <br />subnet-0e863b96980ce617b<br /> | 10.1.16.0/20<br />10.1.48.0/20<br /> 10.1.32.0/20 <br />10.1.0.0/20 <br />|

<br />

### Kubernetes

#### API

| **Environment** |  | **Environment** | | **Environment** | 
|:--------|:---------|:--------|:--------|:--------|
| Parameter Name| Dev Global Value | QA Global Values | Dev Regional Values | QA Regional Values | Demo Global Value | Demo Regional Value |
| Cluster name | c2c-kuberenetes | c2c-kuberenetes-qa | c2c-kubernetes-dev-regional | c2c-kubernetes-qa-regional | c2c-euw1-demo-gbl-eks-cluster | c2c-euw2-demo-reg-eks-cluster |
| Operating System | Amazon Linux AMIs type AL2_x86_64  | Amazon Linux AMIs type AL2_x86_64   | Amazon Linux AMIs type AL2_x86_64   | Amazon Linux AMIs type AL2_x86_64   | Amazon Linux AMIs type AL2_x86_64 | Amazon Linux AMIs type AL2_x86_64 |
| Location | US East (N. Virginia)us-east-1  | US East (Ohio)us-east-2 | US West (N. California)us-west-1| US West (Oregon)us-west-2   | Europe (Ireland)eu-west-1 | Europe (London)eu-west-2 |
| Node type| t3.medium   | t3.medium   | t3.medium   | t3.medium   | m5.large | m5.large |
| Node count   | 6   | 6   | 3   | 4   | 4   | 4   |
| VM size  | 2 vCPU, 4GB mem | 2 vCPU, 4GB mem | 2 vCPU, 4GB mem | 2 vCPU, 4GB mem | 2 vCPU, 8GB mem | 2 vCPU, 8GB mem |
| Reliability tier | | | | |
| Virtual network name | c2c_eu1_dev_gbl_vpc | c2c_eu2_qa_gbl_vpc  | c2c_wu1_dev_rg_vpc  | c2c_wu2_qa_rg_vpc   | c2c_euw1_demo_gbl_vpc  | c2c_euw2_demo_reg_vpc  |
| CIDR Range   | 10.165.64.0/20  | 10.162.48.0/20  | 10.164.48.0/20  | 10.163.48.0/20  | 10.0.0.0/16 | 10.1.0.0/16 |
| Subnet Name  | subnet-092e0b97f277e0a92<br /> subnet-03d571c5ef1c095ed<br /> subnet-00911e9cb9f0a4118<br /> subnet-00b2a54011db5de81<br />  |                 subnet-0380c65b0adb4a556<br /> subnet-00f966a2e4c874130<br /> subnet-096c89f56a421a8f7<br /> subnet-02e22d25eb7eed27b<br />  |                 subnet-081ef0d6bc871e77c<br /> subnet-0eb4319e2484cf35d<br /> subnet-01d67973f8d6ca272<br /> subnet-0101128823757d077<br />  |                 subnet-0efa168146b25c0fc<br /> subnet-0d1f4a100fe75cd5e<br /> subnet-0dbca44661f0f0c10<br /> subnet-0373d9f85e88bb890<br />  |                 subnet-0e7323a857367c5e8<br />subnet-0d42fb8add658fdf2 <br />subnet-0ff72964e99666b36 <br />subnet-030eb44c46dec97cc<br />   |                 subnet-0ac145c6c9bbb29d2<br />subnet-0a52eea19057a46f2 <br />subnet-0a0008de90c81eb34 <br />subnet-0e863b96980ce617b<br />   |
| Subnet IP Range  | 10.165.67.0/24<br /> 10.165.65.0/24<br />  10.165.66.0/24<br /> 10.165.64.0/24 | 10.162.52.0/24<br />  10.162.49.0/24<br />  10.162.50.0/24<br /> 10.162.51.0/24<br />   | 10.164.52.0/24<br /> 10.164.51.0/24<br />  10.164.50.0/24,<br /> 10.164.49.0/24 <br />  | 10.163.49.0/24<br /> 10.163.51.0/24<br /> 10.163.52.0/24<br /> 10.163.50.0/24 <br /> | 10.0.32.0/20<br />10.0.48.0/20<br /> 10.0.0.0/20 <br />10.0.16.0/20 <br />| 10.1.16.0/20<br />10.1.48.0/20<br /> 10.1.32.0/20 <br />10.1.0.0/20 <br />|

### IoT Core

| Environment   | Dev Global Value| QA Global Values   | Dev Regional Values | QA Regional Values  | Demo Global Value | Demo Regional Values
|:-----------|:-----------|:-----------|:-----------|:-----------| :-----------| :-----------|
| IOT Rule Name | c2c_eus_dev_gbl_cc_d2c_iot_rule | c2c_eu2_qa_gbl_cc_d2c_iot_rule | c2c_wus_dev_reg_cc_d2c_iot_rule | c2c_usw2_qa_reg_cc_d2c_iot_rule | c2c_euw1_demo_gbl_cc_d2c_iot_rule | c2c_euw2_demo_reg_cc_d2c_iot_rule |

### Message Brokers

### Storage


#### S3

| Environment| Dev Global Value | QA Global Values   | Dev Regional Values| QA Regional Values | Demo Global Value | Demo Regional Value
|:-----------|:-----------|:-----------|:-----------|:-----------| :-----------|:-----------|
| S3 Bucket Name | c2c-eus-dev-gbl-cc-s3-d2c-invalid-messages<br />c2c-eus-dev-gbl-cc-s3-c2c-messages<br />c2c-eus-dev-gbl-cc-s3-d2c-raw-msg<br />c2c-eus1-dev-gbl-dm-s3-queuemsg<br /> destmessagestorage<br />sourcemessagestorage <br />c2c-eus-dev-gbl-s3-config-server<br /> | c2c-eu2-qa-gbl-cc-s3-c2c-messages <br />c2c-eu2-qa-gbl-cc-s3-d2c-invalid-messages<br /> c2c-eu2-qa-gbl-cc-s3-d2c-raw-msg<br /> c2c-eu2-qa-gbl-dm-s3-queuemsg <br />c2c-eu2-qa-gbl-s3-config-server<br /> | c2c-wus-dev-reg-cc-s3-d2c-invalid-messages<br /> c2c-wus-dev-reg-cc-s3-c2c-messages <br />c2c-wus-dev-reg-cc-s3-d2c-raw-msg<br /> c2c-wus-dev-reg-dm-s3-queuemsg<br /> | c2c-wu2-qa-reg-cc-s3-c2c-messages <br />c2c-wu2-qa-reg-cc-s3-d2c-invalid-messages <br />c2c-wu2-qa-reg-cc-s3-d2c-raw-msg<br /> c2c-wu2-qa-reg-dm-s3-queuemsg <br />| c2c-euw1-demo-gbl-cc-s3-c2c-messages<br />c2c-euw1-demo-gbl-cc-s3-d2c-invalid-messages<br /> c2c-euw1-demo-gbl-cc-s3-d2c-raw-msg<br /> c2c-euw1-demo-gbl-s3-config-server<br /> | c2c-euw2-demo-reg-cc-s3-c2c-messages<br /> c2c-euw2-demo-reg-cc-s3-d2c-invalid-messages<br /> c2c-euw2-demo-reg-cc-s3-d2c-raw-msg<br /> c2c-euw2-demo-reg-dm-s3-queuemsg<br />c2c-euw2-demo-reg-cc-s3-smp-src<br /> c2c-euw2-demo-reg-s3-config-server<br />|


#### Relational Database

Using AWS PostgreSQL and MySQL as relation database

| **Environment**| Dev Global Value| QA Global Values  | Dev Regional Values  | QA Regional Values | Demo Global Value | Demo Regional Value |
|:-----------|:-----------|:-----------|:-----------|:-----------| :-----------| :-----------|
| **PSQL-Parameter Name** | c2c-eus-dev-gbl-dm-rds-database | c2c-use2-qa-gbl-dm-rds-psql-db | c2c-wus-dev-reg-dm-rds-database-psql | c2c-usw2-qa-reg-dm-rds-psql-db | c2c-euw1-demo-gbl-dm-rds-database-psql | c2c-euw2-demo-reg-dm-rds-database-psql |
| **MYSQL-Parameter Name** | NA | NA | c2c-usw1-dev-reg-dm-rds-mysql-db | c2c-usw2-qa-reg-dm-rds-mysql-db-v2 | NA | c2c-euw2-demo-reg-dm-rds-database-mysql-v2 |

####	Non-Relational Database
Using Amazon DynamoDB as non-Relational database, Amazon DynamoDB is fully manager NoSQLservice from Amazon
| **Environment**| Dev Global Value| QA Global Values  | Dev Regional Values  | QA Regional Values | Demo Global Value | Demo Regional Value |
|:-----------|:-----------|:-----------|:-----------|:-----------| :-----------| :-----------|
| **DYNAMODB-Tables-Parameter Name** | c2c_eus_dev_gbl_cc_c2c_c2d_kinesis_storage_stream<br />c2c_eus_dev_gbl_cc_c2c_d2c_kinesis_storage_stream<br />c2c_eus_dev_gbl_cc_c2c_kinesis_storage_stream_123abcd<br />c2c_eus_dev_gbl_cc_c2c_kinesis_storage_stream_123abcde<br />c2c_eus_dev_gbl_cc_c2c_kinesis_storage_stream_abcd123<br />c2c_eus_dev_gbl_cc_c2c_kinesis_storage_stream_dev<br />c2c_eus_dev_gbl_cc_d2c_inbound_stream<br />c2capplicationName | c2c_eu2_qa_gbl_cc_c2c_c2d_kinesis_storage_stream<br />c2c_eu2_qa_gbl_cc_c2c_d2c_kinesis_storage_stream<br />GenericTable<br />StreamClient<br />c2c_eu2_qa_gbl_cc_c2c_kinesis_storage_stream_dev<br />c2c_eu2_qa_gbl_cc_d2c_inbound_stream<br />c2c_eu2_qa_gbl_cc_d2c_inbound_stream_dev<br />c2c_eu2_qa_gbl_cc_d2c_inbound_stream_local<br />c2cmessage_details<br />|	c2c-euw1-demo-reg-dydb-telemetry<br />c2c-usw1-dev-reg-dydb-geofence<br />c2c-usw1-dev-reg-dydb-loctel<br />c2c-usw1-dev-reg-dydb-notification<br />c2c-usw1-dev-reg-dydb-telemetry<br />c2c-usw1-dev-reg-dydb-threshold<br />c2c-usw1-dev-reg-dydb-threshold-notification<br />c2c_eus_dev_reg_cc_c2c_c2d_kinesis_storage_stream<br />c2c_eus_dev_reg_cc_c2c_d2c_kinesis_storage_stream<br />c2c_wus_dev_reg_cc_c2c_kinesis_storage_stream_dev<br />2c_wus_dev_reg_cc_d2c_inbound_stream_dev<br />c2capplicationName<br />c2capplicationName1<br />c2capplicationName2<br />c2cwebsocket<br />processor<br />| c2c-euw1-demo-reg-dydb-telemetry<br />c2c-usw1-dev-reg-dydb-geofence<br />c2c-usw1-dev-reg-dydb-loctel<br />c2c-usw1-dev-reg-dydb-notification<br />c2c-usw1-dev-reg-dydb-telemetry<br /> c2c-usw1-dev-reg-dydb-threshold<br />	c2c-usw1-dev-reg-dydb-threshold-notification<br />	c2c_eus_dev_reg_cc_c2c_c2d_kinesis_storage_stream<br />	c2c_eus_dev_reg_cc_c2c_d2c_kinesis_storage_stream<br />	c2c_wus_dev_reg_cc_c2c_kinesis_storage_stream_dev<br />	c2c_wus_dev_reg_cc_d2c_inbound_stream_dev<br />	c2capplicationName<br />c2capplicationName1<br />	c2capplicationName2	<br />c2cwebsocket<br />processor<br />	resilience_kins_messages_dummy_application | c2c_euw1_demo_gbl_cc_c2c_kinesis_storage_stream_demo<br />c2c_euw1_demo_gbl_cc_d2c_inbound_stream_demo<br />|c2c-euw2-demo-reg-dydb-telemetry<br />c2c-euw2-demo-reg-dydb-threshold<br />c2c-euw2-demo-reg-dydb-threshold-notification<br />c2c_euw2_demo_reg_cc_c2c_kinesis_storage_stream<br />
c2c_euw2_demo_reg_cc_d2c_inbound_stream<br />c2capplicationName<br />|

!!! info "Reference"
    [Paas components](https://cognizantonline-my.sharepoint.com/:x:/g/personal/242989_cognizant_com/EYOkqpvyAjhIveOZS1Ed14wBKLkHFMIwMbwr1I5RkQo11w)<br />
    [Demo environment](https://cognizantonline-my.sharepoint.com/:x:/g/personal/279231_cognizant_com/EX1Hi7P14CJAohTTPeqkpzwBFBo4SWoxFxa2WQ5X38hNPA)<br />
    [QA environment](https://cognizantonline-my.sharepoint.com/:x:/g/personal/944123_cognizant_com/ETzun2S1J8FHn-ro5lgsN44BmyBJJy2cU90flQFudVzTVQ)

# Change Log

|  Version No. | Date <br/> (MMM-DD-YYYY) |Author |Changes Made |   
|:----------|:-------------:|:------|:------|   
| 1.0| ________|  ________|Baseline|  
