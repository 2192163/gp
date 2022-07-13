# DevOps Details
	
All endpoints are secured via Bastion server. To get access to the below DevOps tools, please connect with [DevOps team](mailto:QCC2CDevOPS@cognizant.com) 
<QCC2CDevOPS@cognizant.com>.

1. JIRA - <https://team-1608713224871.atlassian.net/>{target=_blank} <br/>
2. GitHub - <https://github.com/Github-Enterpirse-India>{target=_blank} <br/>
3. Sonar Qube <https://sonar.car2cloudapps.com/sessions/new?return_to=%2F>{target=_blank}  <br/>
4. Graphana - Grafana dashboard can be viewed from Rancher Tool
5. Prometheus - Prometheus dashboard can be viewed from Rancher Tool

<hr />
## **Database Connection commands**
<hr />

To connect to any Database , open a command prompt and use one of the below commands. Update the username in the command. Replace \<USERNAME\> with your username in bastion host.

RDS:

| Environment       | Command                                                                                                                                  |
| :---------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| CTS-QA-GBL        | ``` ssh -L 5433:c2c-use2-qa-gbl-dm-rds-psql-db.coacnza0vbnw.us-east-2.rds.amazonaws.com:5432 <USERNAME>@3.225.60.109 ```                 |
| CTS-QA-REG        | ``` ssh -L 5433:c2c-usw2-qa-reg-dm-rds-psql-db.c8rxnxgb1nnl.us-west-2.rds.amazonaws.com:5432 <USERNAME>@3.225.60.109 ```                 |
| CTS-QA-REG-mysql  | ``` ssh -L 3307:c2c-usw2-qa-reg-dm-rds-mysql-db-v2.c8rxnxgb1nnl.us-west-2.rds.amazonaws.com:3306 <USERNAME>@3.225.60.109 ```               |
| QC-DEV-GBL        | ``` ssh -L 5433:c2c-usw1-dev-gbl-dm-rds-database-psql.cgjvx6pc9lyq.us-west-1.rds.amazonaws.com:5432 <USERNAME>@184.72.35.230 ```         |
| QC-DEV-REG        | ``` ssh -L 5433:c2c-usw2-dev-reg-dm-rds-database-psql.ct8gr6jszrlb.us-west-2.rds.amazonaws.com:5432 <USERNAME>@184.72.35.230 ```         |
| QC-DEV-REG-mysql  | ``` ssh -L 3307:c2c-usw2-dev-reg-dm-rds-database-mysql-v2.ct8gr6jszrlb.us-west-2.rds.amazonaws.com:3306 <USERNAME>@184.72.35.230 ```    |
| QC-QA-GBL         | ``` ssh -L 5433:c2c-usw1-qa-gbl-dm-rds-database-psql.c94pkaqk5jgw.us-west-1.rds.amazonaws.com:5432 <USERNAME>@50.18.242.69 ```           |
| QC-QA-REG         | ``` ssh -L 5433:c2c-usw2-qa-reg-dm-rds-database-psql.castoaxbaykb.us-west-2.rds.amazonaws.com:5432 <USERNAME>@50.18.242.69 ```           |
| QC-QA-REG-mysql   | ``` ssh -L 3307:c2c-usw2-qa-reg-dm-rds-database-mysql-v2.castoaxbaykb.us-west-2.rds.amazonaws.com:3306 <USERNAME>@50.18.242.69 ```       |
| QC-PERF-GBL       | ``` ssh -L 5433:c2c-use1-perf-gbl-dm-rds-database-psql.co0vsmnvys1x.us-east-1.rds.amazonaws.com:5432 <USERNAME>@50.18.242.69 ```         |
| QC-PERF-REG1      | ``` ssh -L 5433:c2c-use2-perf-reg1-dm-rds-database-psql.cc7vzardqfqp.us-east-2.rds.amazonaws.com:5432 <USERNAME>@50.18.242.69 ```        |
| QC-PERF-REG-mysql | ``` ssh -L 3307:c2c-use2-perf-reg1-dm-rds-database-mysql-v2.cc7vzardqfqp.us-east-2.rds.amazonaws.com:3306 <USERNAME>@50.18.242.69 ```    |
| QC-PERF-REG2      | ``` ssh -L 5433:c2c-use2-perf-reg2-dm-rds-database-psql.cir3qmuuwiri.us-east-2.rds.amazonaws.com:5432 <USERNAME>@50.18.242.69 ```        |
| QC-PERF-REG3      | ``` ssh -L 5433:c2c-use2-perf-reg3-dm-rds-database-psql.ctw535w67bou.us-east-2.rds.amazonaws.com:5432 <USERNAME>@50.18.242.69 ```        |
| QC-IOT-GBl        | ``` ssh -L 5433:c2c-usw1-demostg-gbl-dm-rds-database-psql.cvyqqvk3gp5l.us-west-1.rds.amazonaws.com:5432 <USERNAME>@18.144.110.1 ```      |
| QC-IOT-REG        | ``` ssh -L 5433:c2c-usw2-demostg-reg-dm-rds-database-psql.cj5gshkrxdui.us-west-2.rds.amazonaws.com:5432 <USERNAME>@18.144.110.1 ```      |
| QC-Demo-GBl       | ``` ssh -L 5433:c2c-usw1-demo-gbl-dm-rds-database-psql.cqmrsirislq5.us-west-1.rds.amazonaws.com:5432 <USERNAME>@13.56.248.119 ```        |
| QC-Demo-REG       | ``` ssh -L 5433:c2c-usw2-demo-reg-dm-rds-database-psql.cs6mqypzluxa.us-west-2.rds.amazonaws.com:5432 <USERNAME>@13.56.248.119 ```        |
| QC-DEMO-REG-mysql | ``` ssh -L 3307:c2c-usw2-demo-reg-dm-rds-database-mysql-v2.cs6mqypzluxa.us-west-2.rds.amazonaws.com:3306 <USERNAME>@13.56.248.119 ```    |



<hr />
## **RANCHER Tunnelling Commands**
<hr />

To connect to any Rancher , open a command prompt and use one of the below commands. Update the username only in the command. Replace \<USERNAME\> with your username in bastion host.

After tunnelling, access the url <https://localhost:8443/login> from browser.

| Environment | Command                                                     |
| :---------- | :---------------------------------------------------------- |
| CTS         | ``` ssh -L 8443:10.6.4.16:443 <USERNAME>@3.225.60.109 ```   |
| QC-DEV      | ``` ssh -L 8443:10.4.2.170:443 <USERNAME>@184.72.35.230 ``` |
| QC-QA       | ``` ssh <USERNAME>@50.18.242.69 -L8443:10.11.2.39:443 ```   |
| QC-IOT      | ``` ssh -L 8443:10.17.5.153:443 <USERNAME>@18.144.110.1 ``` |
| QC-Demo     | ``` ssh -L 8443:10.1.6.116:443 <USERNAME>@13.56.248.119 ``` |

<hr />
## **Qualcomm Join Lists**
<hr />

| Environment  | List name  |
| :------- | :------------- |
| QC Github / Git lab joining | https://lists.qualcomm.com/ListManager?id=github.waiting|
| QC Demo AWS Account         | https://lists.qualcomm.com/ListManager?id=AWS-ROLE-733790306378-SmlAppAD&query=AWS-ROLE-733790306378-SmlAppAD&type=list  |
| QC Dev AWS Account          | https://lists.qualcomm.com/ListManager?id=AWS-ROLE-552352098145-SmlAppAD&query=AWS-ROLE-552352098145-SmlAppAD&type=list  |
| QC QA AWS Account (Performance Env Global and Regional-1 is in this Account itself) | https://lists.qualcomm.com/ListManager?id=AWS-ROLE-115813820635-SmlAppAD&query=AWS-ROLE-115813820635-SmlAppAD&type=list  |
| QC Perf AWS Account        | QC Perf Environment has 1 Global and 3 regional deployments. Global deployment and Regional -1 is done in QC QC account only. For Regional -2 and Regional -3 , need to join below lists. <br /> https://lists.qualcomm.com/ListManager?action=view&query=AWS-ROLE-882809750339-SmlAppAD&field=default&match=eq <br /> https://lists.qualcomm.com/ListManager?action=view&query=AWS-ROLE-758039931311-SmlAppAD&field=default&match=eq <br /> |
| Qc Integration AWS Account  | https://lists.qualcomm.com/ListManager?id=AWS-ROLE-461421057757-SmlAppAD&query=AWS-ROLE-461421057757-SmlAppAD&type=list  |

<hr />
## **EFK - Elasticsearch Fluentbit Kibana Stack**
<hr />

EFK is used as logging solution for applications running on Kubernetes pods.

EFK Portal usage :  

To view log  Navigate to Home->Observability -> Streams under logs (in left collapsible panel). 
This will list the logs of all EKS pods with timestamp

To filter logs of specific microservice use the below pattern in search bar (replace git repo name '_' with '-')
Example : kubernetes.pod_name : "c2c-state-operation-pro*"


To download logs Navigate to Home->Analytics->Discover.
Use the same seach filter as above , select the time frame you require , click search
click on share -> csv reports -> generate csv -> wait for csv file to be available for download

Access url to all environments EFK are mentioned below 

| Environment  | Command                                                                             |
| :----------- | :---------------------------------------------------------------------------------- |
| CTS-DEV-GBL  | http://a72a9621cb6f842968b8ef7cd769925e-231973660.us-east-1.elb.amazonaws.com:8080  |
| CTS-DEV-REG  | http://aa4cfc247142842f18f2a4ff3c6519a1-1622741900.us-west-1.elb.amazonaws.com:8080 |
| CTS-QA-GBL   | http://a41f15ff0cef74bdbaf27c70469e70c5-976191610.us-east-2.elb.amazonaws.com:8080  |
| CTS-QA-REG   | http://a338ccf8ddcb840e490def6cc037983d-201683187.us-west-2.elb.amazonaws.com:8080  |
| QC-DEV-GBL   | http://efk-devgbl.c2c-develop.qualcomm.com/                                         |
| QC-DEV-REG   | http://efk-devreg.c2c-develop.qualcomm.com/                                         |
| QC-QA-GBL    | http://efk-gbl.c2c-test.qualcomm.com/                                               |
| QC-QA-REG    | http://efk-reg.c2c-test.qualcomm.com/                                               |
| QC-PERF-GBL  | http://efkperfgbl.c2c-test.qualcomm.com:8080/ |
| QC-PERF-REG1 | https://perf-efk-reg.c2c-test.qualcomm.com/                                         |
| QC-PERF-REG2 | 										     |
| QC-PERF-REG3 |   										     |
| QC-Demo-GBl  | http://efk.gbl.c2c-demo-2.qualcomm.com/                                             |
| QC-Demo-REG  | http://efk.reg.c2c-demo-2.qualcomm.com/					     |


<hr />
## **Jenkins Jobs URL**
<hr />

Jenkins Job URL for the different ENV

| Environment | Jenkins Job URL | Jenkins Job Usage |
| :---------- | :------- | :------ |
| All QC Env | https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/build_deploy_java_ingress_both_part/ | Java ingress build and deploy |
| All QC Env | https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/build_deploy_python_ingress_both_part/ | Python ingress build and deploy |
| All QC Env | https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/build_deploy_reactjs_ingress_both_part/ | ReactJS ingress build and deploy |
| All Env | https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/c2c_kub_release_deploy/ | Deploy with existing Docker image in ECR |
| All Env | https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/c2c_maven_wrapper_build/ | Build job for wrappers |
| CTS Dev and QA | https://jenkins-1.car2cloudapps.com/job/abhi/job/c2c_devops_jenkins_deployment/ | Java Non-ingress build and deploy |
| All Env | https://jenkins-1.car2cloudapps.com/job/Utilities/job/restart_kube_pods/ | Kubernetes Pod restart|
| QC Env | https://jenkins-1.car2cloudapps.com/job/geo/job/SMP_API_ingress/ | SMP API QC Environments|
| QC Env | https://jenkins-1.car2cloudapps.com/job/geo/job/SMP_UI/ | SMP UI QC Environments|
| wiki publish| https://jenkins-1.car2cloudapps.com/job/DEPLOYMENT/job/c2c-doc-wiki-publish/ | legendary train publish pipeline |
| Blackduck Scan| https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/MavenBlackduckScan/ | Blackduck scan for Maven build |
| Blackduck Scan| https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/PythonBlackduckScan/ | Blackduck scan for Python |
| Blackduck Scan| https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/ReactJSBlackduckScan/ | Blackduck scan for React |
| Checkmarx Scan| https://jenkins-1.car2cloudapps.com/job/devops_cicd/job/CheckmarxScan/ | Checkmarx scan for all code |







<hr />
## **AWS Accounts**
<hr />

Please find AWS Accounts List Managed by DevOps Team.




