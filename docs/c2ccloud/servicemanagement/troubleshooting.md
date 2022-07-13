1)      Create program for each chipset with standard/mid-tier/premium SKU in CFT
The SKU mix is decided by the end User.
At times very specific options have to be to set for features – e.g. 8295 need 00,02 as options.
 
2)      Setup Services in the Service table. The set of services are provided by User. This is a manual entry in the table. There is no ui option.
       User then creates necessary packages as per demo script.
 
Troubleshoot ->
 
a. Incase the services entered manually does not appear in UI, then check whether the status of each record is "ACTIVE" or not. Update each record    status as ACTIVE, in case it’s not.
 
3)      The chipsets are on boarded with mid-tier SKU.
        The prog sku id has to be shared with device team.
        This is got from program > program_version > program_version_chipset > program_version_chipset_sku_mapping table.
        In the new process if we do platform license then this is not required. Just the program id and sku id (sku table) is sufficient.
 
Troubleshoot ->
 
a.  Pick up the correct prog sku id depending on ecu/chipset.
b.  Also provide the correct Chipset and Chipset sp values to device and cross check it incase onboarding fails due to validation.
c. Check COP logs to debug out the cause if point a. and b. is correct.

 
4)      Support the testing by applying necessary  sku/feature updates.
 
5)      Debug license failures.
        Check vin_license table, check status of txn in lms_txn table, check LMS/SMP logs.
        This is adhoc.
 
Troubleshoot ->
 
a. This could be troubleshooted in following ways :
  
   i. Check SMP LOGS for correct call and response while sending the install/delete license message. If any problem occurs, check the url in filter.properties file for SMP and for SMP ADAPTER API the pod is running or not.
 
  ii. Check LMS LOGS for further processing of message with api calls to LMSC and CHIPSET API should be successful. If any issue persists check the properties file in config server s3 bucket for these corresponding urls.
 
iii. Check LMSC Api LOGS whether it correctly calls LMSQ API or not. If not then check the URLs present in properties file and debug out the cause.
 
  iv. Check LMSQ Api LOGS whether it behaves correctly or not.If not then check the URLs present in properties file and debug out the  cause. 
 
6)      At times device and SMP goes out of sync. The license for the device/vin has to be deleted from vin_license and the device. The reply fresh new from SMP.
