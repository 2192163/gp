<center>

# **Software Design Document** 

</center>

<p style="page-break-after: always;">&nbsp;</p>

## Table of Contents

[1. Introduction](#_Introduction)     
[1.1 Purpose](#_Purpose)      
[1.2 Scope](#_Scope)      
[1.3 Conventions](#_Conventions)      
[2. Feature definition](#_FeatureDefinition)     
[2.1 Product requirements](#_ProductRequirements)   
[2.2 Feature overview](#_FeatureOverview)    
[2.2.1 Use cases](#_UseCases)       
[2.2.2 Operating enviornment](#_OperatingEnviornment)   
[2.3 Design and software implementation requirements](#_DesignAndSoftware)   
[2.3.1 Requirements summary](#_RequirementsSummary)    
[2.4 External/internal component dependencies](#_ExternalInternalComponent)  
[2.4.1 Backend dependencies](#_BackendDependencies)   
[2.4.2 Frontend dependencies](#_FrontendDependencies)   
[2.5 Assumptions](#_Assumptions)              
[3. Architecture/highlevel design/detailed design](#_ArchitectureDesign)  
[3.1 High-level software design](#_HighLevelSoftwareDesign)  
[3.1.1 List of various layers, software components/modules](#_ListOfVariousLyaers)  
[3.1.2 Sequence/state machine/interaction diagram](#_SequenceDiagram)   
[3.1.3 Software module interface diagram](#_SoftwareModuleInterfaceDesign)    
[3.1.4 Requirements to SW modules and use case traceability matrix](#_SWModules)  
[3.1.5 API](#_API)   
[3.1.6 Performance – analysis and KPIs](#PerformnaceAnalysisandKPI)   
[3.2 Low-level software design](#_LowLevelSoftwareDesign)  
[3.2.1  Lowlevel design sequence/interaction diagram ](#_LowLevelDesignSequenceDiagram)  
[3.2.2 Security](#_Security)  
[3.2.3 Error handling](#_ErrorHandling)  
[3.2.4 Logging mechanism](#_LoggingMechanism)  
[4. Verification](#_Verification)  
[4.1 Software design verification mechanism](#_SoftwareDesignVerificationMechanism)     
[4.1.1 Description](#_Description)   
[4.1.2 Requirements to SW unit test traceability](#_SWUnitTest)  
[4.2 Unit test plan procedure](#_SWUnitTestPlan)    
[4.3 Test strategy recommendation](#_TestStrategy)    
[5. Requirements traceability summary ](#_RequirementsTraceability) 

<p style="page-break-after: always;">&nbsp;</p>

## <a id="_Introduction"></a>1. Introduction 


### <a id="_Purpose"></a>1.1 Purpose
The purpose of C2C Unified Dashboard is to provide visualization based on gathered data from vehicles to identify trends and patterns to help OEMs target specific features. All the unified filters are applied on the collected data to get the patterns and trends of the vehicles feature(s).

### <a id="_Scope"></a>1.1 Scope
This document is for the software developer implementing the All the unified filters are applied on the collected data to get the patterns and trends of the vehicles feature/features to ensure compliance with feature requirements and software design requirements. This document also is intended to assist the test engineer with designing All the unified filters are applied on the collected data to get the patterns and trends of the vehicles feature test plans.

### <a id="_Conventions"></a>1.1 Conventions

* Class names start with an uppercase letter, and it will be a meaningful name
* Method names start with a lowercase letter. If the name contains multiple words, it starts with a lowercase letter it is separated by an underscore (_) and all words are in lowercase letter.  
* Variable names also start with a lowercase letter and if it has multiple words it starts with a lowercase letter it is separated by an underscore (_) and all words are in lowercase letter.  
* Constants are all in uppercase and if contains multiple words it is separated by an underscore (_). 
* Backend APIs are in python and follow rules from black, flake8 and UI use prettier and TSlint rules for auto-formatting and linting.

## <a id="_FeatureDefinition"></a>2. Feature definition 

### <a id="_ProductRequirements"></a>2.1 Product requirement 

The user story requirements for the product are given in section 5 with links to each user story. It describes the functionalities required for the unified analytics console. It also describes the flow of the working of this unified analytics mod. 

Refer Section 5 – click here 

### <a id="_FeatureOverview"></a>2.2 Feature overview 

C2C Unified Dashboard solution is to provide data visualization by curating aggregated data into a form easier to understand, highlighting the trends and patterns of in- vehicle data collected through campaigns. Unified view helps OEM understand network and processor performance, infotainment applications usage, driving statistic, user behavior, data consumption etc. targeting interested sections of dashboards by applying filters and drill-down of data.
OEM end users of the vehicle can experience new features, utilize the applications, and control various vehicle functionalities through the infotainment unit of the vehicle. Vehicle should stay connected with high quality network connectivity for the purpose of improving overall driving and ownership experience. 

OEMs can leverage this information to provide better in-vehicle experiences, troubleshoot issues, and target/segment customers for new services, applications, and content offerings, ultimately extracting value through continuous engagement with consumers. 

Connected vehicles generate data streams from infotainment units, fuel systems, advanced driver assistance systems (ADAS) and other systems that monitor vehicle operations. Hidden in the data are valuable clues regarding the performance and health of vehicles. Analysis of data reveals meaningful trends and patterns that can help provide a better user/driver experience, improve vehicle connectivity, quality, and reliability. The result is a stronger competitive position and new revenue opportunities. 

 

Unified Analytics Dashboard solution provided by C2C Platform provides the users with the following benefits: 

* Provides patterns or trends within the information collected by the vehicle. Various performance metrics of the vehicle are captured 

 
* Analytics Dashboard helps the users/OEMs to gain insights into customer behavior to provide a more personalized experience and thus take decisions in which all areas they need to improve to have growth in the automotive industry. 

* It helps to improve areas like processor performance, connectivity performance, understand end users for offering trial services, understand driver/user behavior to improve the road safety, performance/mileage etc. 

* It also entails applying data patterns towards effective decision-making. It involves sifting through massive data sets to discover, interpret, and share new insights and knowledge which helps to leverage the OEMS to the next level. 

Unified dashboard is collection of multiple sections like user behavior, network and processor performance, application usage, smartphone usage etc. Unified view of aggregated vehicle data provides OEMs with better understanding of their customer needs as well as vehicle performance. 

With the help of this information, OEMs can provide cohesive suites of products for enabling secure services—entertainment subscriptions, navigation, and driver assistance. Services can help car manufacturers improve value, offer superior user experiences, and create service revenue opportunities throughout each stage of a vehicle’s lifecycle as customers unlock additional features or purchase new applications.  

Data collection campaigns are scheduled to collect infotainment and TCU in-vehicle data through various android data loggers. These logged modem and android data files are then loaded into raw/staging tables which are further extracted, transformed, and aggregated using necessary logic/algorithms and loaded into reporting tables to be used for data visualization by C2C unified platform. 

OEMs can target a subset of vehicle campaign data applying unified filters on all the reports of dashboard and create a segment. This segment metadata is then sent back to CCM for a new targeted vehicle data collection campaign to study and get more insights into user behavior as well as vehicle performance. 

 

Analytics provides many ways to access, organize, and visualize the data to suit the business needs. It also helps to analyze data quickly and encourage collaboration with an easy-to-use interface. 

Unified Analytic Solution offers the following features- 

* Segments Creation - Analytic solution helps the user to create segments/Vehicle groups, to supervise and organize vehicles for monitoring various performance metrices in a moment. Based on distinct categories like user behavior, Connectivity, performance OEMs can target small set of data applying unified filters on each category and creating a segment (user behavior, Connectivity, performance metrics and Car information). This segment information is then sent back to SMP for new data collection campaign to get more insights into targeted features. 

* User Behavior - User behavior section helps OEM to get answers for questions like - What is the daily average drive time of a user? What is the average speed or distance travelled? What are the top models used by customers? To retain customers, companies need to provide customizable experiences through OTA updates that fit individual needs. OTA updates can allow people to pay for features on demand, ranging from enhanced telematics and infotainment solutions to safety features such as driver assistance technologies. 

* Application Data utilization - Monitoring of the Utilization of Apps consumed by infotainment units inside the vehicle helps the OEM to offer new/trial services. OEMs can monitor applications’ data consumption of in-vehicle infotainment unit to study how data is being used – top used applications, audio/video customer preference etc. OEMs can leverage such information to understand customer demands and offer superior user experiences providing entertainment service packages with the car while providing consumers more choices for upgrades 

* Connectivity performance - With the continued roll-out of 5G, coupled with access to 4G LTE services, the connected car will transform once again and become a software-defined, network-aware, ultra-connected car that will transmit data and “interact” with the road and every other vehicle around it. It tracks connectivity % of vehicle throughout the drive time. Automakers can also be strategic about their partnerships, prioritizing work with mobile network providers and technology partners who will provide reliable global connectivity ensuring a smooth user experience 

* Processor Performance - The processors power in-vehicle infotainment (IVI) and advanced driver assistance systems (ADAS). Specialized processors, including an energy-efficient quad-core CPU, a powerful GPU, and dedicated audio, video, and image processors deliver the ability to handle more sensors and tasks. Using Analytic Solutions OEM can assess the trend of processor/CPU/GPU performance through graphical representations, based on which decisions can be made whether to provide SKU upgrades. 

**Use cases** 

Typical use case

* Segment creation 

    The user should be able to create segments/Vehicle groups, to supervise and organize vehicles for monitoring various performance metrices. Based on distinct categories like user behavior, connectivity, performance metrics and Car information, users can analyze the vehicle data easily. The C2C Unified Analytics console should validate the user request against a set of constraints previously defined for segment creation. Following is a list of constraints. 

* Duplicate name validation   
    Duplicate filter criteria validation

* Unified filters 

    The user should be able to get a list of filter values which can be used as a payload to the API endpoints, and it can be used to filter out the results.  

    Following is the list of filters. 

    1. Avg. Daily Drive Time 

    2. Avg. Daily Drive Distance 

    3. Avg. Daily Drive Speed 

    4. SMP vehicle group creation 

    Unified analytics is integrated with SMP portal so that the segments created via analytics can be seen on configuration/updates tab of SMP.  

* Segment retrieval 

    The user should be able to see the list of segments which were created earlier. SMP retrieves the VINs associated with an analytics group from analytics. Analytics will provide an interface to enable the SMP to retrieve the latest set of VINs associated with any group that has been provided by analytics 

* Data monitoring 

    The user should be able to see the list of SKU group updates for a vehicle group. This data is fetched from the SMP for each segment. Users can view a list of updates upon selecting a segment.  

* Analytics Dashboard 

    Helps the users/OEMs to gain insights into customer behavior to provide a more personalized experience and thus take decisions in which all areas they need to improve to have growth in the automotive industry 
     

* Performance metrics of the vehicle 

    Provides patterns or trends within the information collected by the vehicle. Various performance metrics of the vehicle are captured, and it helps to improve areas like processor performance, connectivity performance, understand end users for offering trial services, understand driver/user behavior to improve the road safety, performance/mileage etc. It also entails applying data patterns towards effective decision-making. It involves sifting through massive data sets to discover, interpret, and share new insights and knowledge which helps to leverage the OEMS to the next level. 

* Operating environment 

    The web-based system is designed to work on all operating systems. The system is accessible through any laptop and desktop that is connected to the analytics server. It is always accessible. 

### <a id="_Conventions"></a>2.3 Design and software implementation requirements

Requirements for this feature are as follows: 

1. SMP server  
2. Meta database server   
3. Analytics database server   
4. Requirements summary   
See Chapter 5 – Requirements traceability summary. 

### <a id="_ExternalInternalComponent"></a>2.4 External/internal component dependencies 

### <a id="_BackendDependencies"></a>2.4.1 Backend dependencies

**External dependencies:** 

* Flask is the Python server that we chose to implement, as it has a large user base, as well as an assortment of server extensions to help implement secure features. These features range from logging in and session tracking. 

* Flask-SQLAlchemy is an extension for Flask that adds support for SQLAlchemy to your application. It aims to simplify using SQLAlchemy with Flask by providing useful defaults and extra helpers that make it easier to accomplish common tasks 

* psycopg2-binary is the most popular PostgreSQL database adapter for Python. 

* Docker is a virtualized platform that will house the operational. Flask server when moved to AWS ECS. 

* Requests is an elegant and simple HTTP library for Python. Requests allow you to send HTTP/1.1 requests extremely easily 

* Flask-Marshmallow is a thin integration layer for Flask and marshmallow an object serialization/deserialization library that adds additional features to marshmallow, including URL and Hyperlinks fields. 

**Internal dependencies:**

* SMP: The communication process between Analytics console and SMP server. 

### <a id="_FrontendDependencies"></a>2.4.2 Frontend dependencies

**External dependencies:**

* ANTD is an open-source UI library which is used for creating UI components. It’s backed by Alibaba & has very wide documentation for development. 

* Bizcharts is an opensource graph & widgets library which is backed from Alibaba.  

### <a id="_Assumptions"></a>2.5 Assumptions 

NA

## <a id="_ArchitectureDesign"></a>3 Architecture/highlevel design/detailed design

### <a id="_HighLevelSoftwareDesign"></a>3.1 High-level software design     

Unified Analytics Architecture

<figure>
<img src="../../../assets/unifiedanalytics/SMP_specific_architecture.png" width="900" />
<figcaption>Unified Analytics Architecture</figcaption>
</figure>

Unified Analytics High Level Architecture 

<figure>
<img src="../../../assets/unifiedanalytics/unified_analytics_hl_architecture.png" width="900" />
<figcaption>Unified Analytics High Level Architecture</figcaption>
</figure>


### <a id="_ListOfVariousLyaers"></a>3.1.1     List of various layers, software components/modules  
<table>
  <tr>
    <th colspan="2">Tech Stack</th>
    <th></th>
  </tr>
  <tr>
    <td rowspan="3">Backend</td>
    <td>Python</td>
    <td>Language</td>
  </tr>
  <tr>
    <td>Flask</td>
    <td>Python web application framework </td>
  </tr>
  <tr>
    <td>SQLAlchemy</td>
    <td>Python object-relational mapping framework</td>
  </tr>
  <tr>
    <td rowspan="4">Frontend</td>
    <td>TypeScript</td>
    <td>Language</td>
  </tr>
  <tr>
    <td>React</td>
    <td>JavaScript UI library</td>
  </tr>
   <tr>
    <td>Redux</td>
    <td>UI state manager</td>
  </tr>
   <tr>
    <td>Ant Design</td>
    <td>UI components library </td>
  </tr>

  <tr>
    <td rowspan="3">Cloud Infrastructure </td>
    <td>AWS ECS </td>
    <td>Linux web server environment </td>
  </tr>
  <tr>
    <td>AWS Relational DB Service (RDS) </td>
    <td>PostgreSQL and Redshift Database </td>
  </tr>
  <tr>
    <td>AWS Secrets Manager </td>
    <td>Secure Credentials Storage </td>
  </tr>
</table> 

### <a id="_SequenceDiagram"></a>3.1.2 Sequence/state machine/interaction diagram 
     
SKU - Create Vehicle Group (SMP)

### <a id="_SoftwareModuleInterfaceDesign"></a>3.1.3 Software module interface diagram
     
N/A 

### <a id="_SWModules"></a>3.1.4 Requirements to SW modules and use case traceability matrix

N/A 

### <a id="_API"></a>3.1.5 API

### 3.1.5.1 Parameters
<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>avg_drive_time</td>
    <td>It contains the min and max value of the drive time </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>avg_drive_distance</td>
    <td>It contains the min and max value of the drive distance </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>avg_drive_speed</td>
    <td>It contains the min and max value of the drive speed </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>vehicle_types</td>
    <td>It contains the list of vehicle types </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>vehicle_years</td>
    <td>It contains the min and max of the vehicle years </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>model_names</td>
    <td>List of vehicle model names</td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>data_volume</td>
    <td>It contains the mina and max of the vehicle years </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>cities</td>
    <td>List of cities </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>service_type_apps </td>
    <td>List of apps with distinct categories </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>Bluetooth </td>
    <td>It contains the min and max value of Bluetooth </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>Carplay </td>
    <td>It contains the min and max value of the carplay </td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>TCU </td>
    <td>It contains the min and max value of the TCU</td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>a2dp_avrcp  </td>
    <td>Boolean – True or False</td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>cpu_threshold  </td>
    <td>List of CPU threshold values</td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>downLinkCategory  </td>
    <td>Modem downlink performance</td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>upLinkCategory  </td>
    <td>Modem uplink performance</td>
</tr>
<tr>
    <td> &lt;in&gt; </td>
    <td>hfp  </td>
    <td>Boolean – True or False </td>
</tr>
</table>

### 3.1.5.2 get_unified_filters( ) – Get the list of unified filters 
&nbsp;&nbsp;&nbsp;&nbsp;User should be able to get the list of unified filters. User can apply these filters to see the desired results on Unified Analytics console
    UnifiedFiltersResponse – API response

<table>
<tr><th> Attribute Name </th><th> Data Type </th></tr>
<tr><td> <b>avg_drive_distance</b>  </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>avg_drive_speed</b>  </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>avg_drive_time</b>   </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>cities</b>  </td><td> <span style="font-family: Courier New;">List</span> </td></tr>
<tr><td> <b>cpu_threshold</b>   </td><td> <span style="font-family: Courier New;">List</span> </td></tr>
<tr><td> <b>data_volume</b>   </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>Bluetooth</b>  </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>Carplay</b>  </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>TCU</b> </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>a2dp_avrcp</b>  </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>cpu_threshold</b> </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>data_volume</b> </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>downLinkCategory</b> </td><td> <span style="font-family: Courier New;">String</span> </td></tr>
<tr><td> <b>hfp</b> </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td> <b>model_names</b>  </td><td> <span style="font-family: Courier New;">List</span> </td></tr>
<tr><td> <b>service_type_apps</b> </td><td> <span style="font-family: Courier New;">List</span> </td></tr>
<tr><td> <b>upLinkCategory</b>  </td><td> <span style="font-family: Courier New;">String</span> </td></tr>
<tr><td> <b>vehicle_types</b>  </td><td> <span style="font-family: Courier New;">List</span> </td></tr>
<tr><td> <b>vehicle_years</b>  </td><td> <span style="font-family: Courier New;">Dict</span> </td></tr>
</table>

### Prototype
### < 
#### get_unified_filters 

<span style="font-family: Courier New;">
(
OUT UnifiedFiltersResponse
);
</span>

### >

### Parameters 
<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr><td> &lt;out&gt; </td><td>UnifiedFiltersResponse</td><td> The response contains all unified filters.</td></tr>
</table>

### Returns

On success, returns the list of unified filters. 

For failure, returns error code and error message.  


### 3.1.5.3 get_analytics_group_list() – Retrieve the list of saved segments
&nbsp;&nbsp;&nbsp;&nbsp; This endpoint returns the list of saved segments. Users can save the filters which they applied on the unified analytics console. Those saved segments can be retrieved later using this endpoint. 

AnalyticsGroupListResponse - API response 

<table>
<tr><th> Attribute Name </th><th> Data Type </td></tr>
<tr><td><b> ID </b> </td><td> <span style="font-family: Courier New;">Int</span> </td></tr>
<tr><td> <b>name</b> </td><td> <span style="font-family: Courier New;">String</span> </td></tr>
</table>

### Prototype
### < 
#### get_analytics_group_list 

<span style="font-family: Courier New;">
(
OUT AnalyticsGroupListResponse
);
</span>

### >

### Parameters
<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr><td> &lt;out&gt; </td><td>AnalyticsGroupListResponse</td><td> The response contains all saved segments. </td></tr>
</table>

### Returns

On success, returns the list of saved segments earlier. 

For failure, returns error code and error message. 

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
    <td><b>URL</b></td>
    <td>/unifiedAnalyticsGroups</td>
</tr>
<tr>
    <td><b>Method</b></td>
    <td>GET</td>
</tr>
<tr>
    <td><b>Content-Type</b></td>
    <td>Application/json</td>
</tr>
<tr>
    <td><b>API Success Response</b></td>
    <td>

```json
    [
        {
            "id": 1, 
            "name": "sample_segment" 
        }, 
        … 
    ]
```
</td>
</tr>
<tr>
   <tr><td><b>API failure Response </b> </td> 
<td>

```json
{"errors": "error message in detail"}
```

</td> 
</tr>
</table>

### 3.1.5.4 get_vin_groups() – retrieve the data for map widget
&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting total vins, cities, application, data volume and the map data containing the total number of vins each city. 

UnifiedFilters – API payload 

<table>
<tr><th>Attribute Name </th><th>Data Type </th></tr><tr>
<tr><td><b>avg_drive_distance</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>avg_drive_speed</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>avg_drive_time</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>cities</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>cpu_threshold</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>data_volume</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>Bluetooth</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>Carplay</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>TCU</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>a2dp_avrcp</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>cpu_threshold</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>data_volume</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>downLinkCategory</b> </td><td><span style="font-family: Courier New;">String</span> </td></tr>
<tr><td><b>hfp</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
<tr><td><b>model_names</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>service_type_apps</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>upLinkCategory</b> </td><td><span style="font-family: Courier New;">String</span> </td></tr>
<tr><td><b>vehicle_types</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>vehicle_years</b> </td><td><span style="font-family: Courier New;">Dict</span> </td></tr>
</tr>
</table>

VinGroupsResponse - API response 
<table>
<tr><th>Attribute Name</th> <th>Data Type </th> </tr>
<tr><td><b>applications_count</b></td> <td><span style="font-family: Courier New;">Int</span> </td> </tr>
<tr><td><b>cities_count</b></td> <td><span style="font-family: Courier New;">Int</span> </td> </tr>
<tr><td><b>data_volume</b></td> <td><span style="font-family: Courier New;">Dict</span> </td> </tr>
<tr><td><b>vins_count</b></td> <td><span style="font-family: Courier New;">Int</span> </td> </tr>
<tr><td><b>map_data</b></td> <td><span style="font-family: Courier New;">List</span></td> </tr>
</table>

### Prototype
### < 
#### get_vin_groups 

<span style="font-family: Courier New;">
(
IN UnifiedFilters 
OUT VinGroupsResponse 
);
</span>

### >

### Parameters

For &lt;in&gt; parameters refer section 3.1.5.1 

<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
<td>&lt;out&gt;</td>
<td>VinGroupsResponse</td>
<td>Response will consist of the count of app, vin, and cities also the data volume and the map data.</td>
</tr>
</table>

### Returns

On success, returns the data containing map data with application, data volume, vins and cities. 

For failure, returns error code and error message
<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
    <td><b>URL</b></td>
    <td>/unifiedAnalyticsGroups</td>
</tr>
<tr>
    <td><b>Method</b></td>
    <td>GET</td>
</tr>
<tr>
    <td><b>Header</b></td>
    <td>Application/json</td>
</tr>
<tr>
    <td><b>API request</b></td>
    <td>

```json
{
    "service_type_apps": [ 
        { 
            "VOIP": [ 
                "Facetime" 
            ] 
        }, 
        { 
            "Video": [ 
                "Disney Plus" 
            ] 
        }, 
        { 
            "Audio Streaming": [ 
                "Pandora" 
            ] 
        }, 
        { 
            "Browsing": [ 
                "Chrome" 
            ] 
        }, 
        { 
            "Others": [ 
                "Candy Crush" 
            ] 
        } 
    ], 
    "cities": [ 
        { 
            "name": "Springfield" 
        } 
    ], 
    "data_volume": { 
        "max": 4000, 
        "min": 0 
    }, 
    "avg_drive_time": { 
        "min": 1, 
        "max": 39 
    }, 
    "avg_drive_distance": { 
        "min": 0, 
        "max": 76 
    }, 
    "avg_drive_speed": { 
        "min": 1, 
        "max": 119 
    }, 
    "vehicle_types": [ 
        { 
            "name": "SUV" 
        } 
    ], 
    "vehicle_years": { 
        "min": 2018, 
        "max": 2019 
    }, 
    "model_names": [ 
        { 
            "name": "Civic" 
        } 
    ], 
    "start_date": "2022-01-29", 
    "end_date": "2022-02-28" 
} 
```


</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "applications_count": 21,
    "cities_count": 117,
    "data_volume": {
        "max": 131036,
        "min": 88021
    },
    "map_data": [
        {
            "city": "Springfield",
            "count": 2,
            "latitude": 42.1014831,
            "longitude": -72.589811
        },
        {
            "city": "Laredo",
            "count": 3,
            "latitude": 27.5305671,
            "longitude": -99.4803241
        }
    ],
    "vins_count": 250
}
```

</td>
</tr>
<tr>
<tr><td><b>API failure Response </b> </td> 
<td>

```json
{"errors": "error message in detail"}
```

</td> 
</tr>
</table>

### 3.1.5.5 get_users_behaving() – retrieve the data for user’s behaving widget

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of avg of daily drive time, daily drive speed and daily drive distance. We are taking the daily drive, distance and speed min and max values to create 5 bars which need to plot on the bar graph. Calculating the percentage of time for each of the drive, distance, and speed ranges. 

UnifiedFilters – API payload 

Refer section 3.1.5.4 for the request payload 

UsersBehaviourResponse – API response

<table>
<tr><th>Attribute Name</th> <th> Data Type  </th> </tr>
<tr><td><b>avg_data</b> </td> <td> <span style="font-family: Courier New;">Dict</span>  </td> </tr>
<tr><td><b>daily_drive_distance</b> </td> <td> <span style="font-family: Courier New;">List</span>  </td> </tr>
<tr><td><b>daily_drive_speed</b> </td> <td> <span style="font-family: Courier New;">List</span>  </td> </tr>
<tr><td><b>daily_drive_time</b> </td> <td> <span style="font-family: Courier New;">List</span> </td> </tr>
</table>

### Prototype
### < 
#### get_users_behaving 

<span style="font-family: Courier New;">
(
IN UnifiedFilters 
OUT UsersBehaviourResponse 
);
</span>

### >

### Parameters

&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1

<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr><td>&lt;out&gt;</td><td>UsersBehaviourResponse</td><td>Response will consist of avg of daily drive time, daily drive speed and daily drive distance.</td></tr>
</table>

### Returns 

On success, returns the data containing of avg of daily drive time, daily drive speed and daily drive distance. 

For failure, returns error code and error message. 

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr><td><b>URL</b>  </td> <td> /userBehavior  </td> </tr>
<tr><td><b>Method</b>  </td> <td> POST   </td> </tr>
<tr><td><b>Content-Type</b>  </td> <td> Application/json   </td> </tr>
<tr><td><b>API request</b>  </td> <td> Refer section 3.1.5.3 for the request payload  </td> </tr>
<tr><td><b>API Success Response</b>  </td> <td> 

```json
{
    "avg_data": {
        "daily_drive_distance": 19,
        "daily_drive_speed": 59,
        "daily_drive_time": 20
    },
    "daily_drive_distance": [
        {
            "percent_records": 49.06,
            "total_records": "0 - 15"
        },
...
    ],
    "daily_drive_speed": [
        {
            "percent_records": 19.9,
            "total_records": "1 - 24"
        },
...
    ],
    "daily_drive_time": [
        {
            "percent_records": 17.87,
            "total_records": "1 - 8"
        },
...
    ] 
}
```
</td> </tr>
<tr>
<tr><td><b>API failure Response </b> </td> 
<td>

```json
{"errors": "error message in detail"}
```

</td> 
</tr>
</table>

### 3.1.5.6 vehicle_type_widget() - retrieve the data for user’s behaving widget

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of top 5 models and different vehicle type percentage. 

UnifiedFilters – API payload 

Refer section 3.1.5.4 for the request payload 

UsersBehaviourVehicleResponse – API response
 
<table>
<tr><th>Attribute Name </th> <th>Data Type </th> </tr>
<tr><td><b>model_data</b> </td> <td><span style="font-family: Courier New;">List</span> </td> </tr>
<tr><td><b>type_data</b> </td> <td><span style="font-family: Courier New;">List</span></td> </tr>
</table>

### Prototype
### < 
#### vehicle_type_widget 

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT UsersBehaviourVehicleResponse
);
</span>

### >

### Parameters

&lt;in&gt; values are same as described on section 3.1.5.1
<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr><td>&lt;out&gt;</td><td>UsersBehaviourVehicleResponse</td><td>Response will consist of avg of top 5 models and different vehicle type percentage. </td></tr>
</table>

### Returns 
<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr><td><b>URL</b>  </td> <td>/vehicleType </td> </tr>
<tr><td><b>Method</b>  </td> <td>POST  </td> </tr>
<tr><td><b>Content-Type</b>  </td> <td>Application/json  </td> </tr>
<tr><td><b>API request</b>  </td> <td>Refer section 3.1.5.3 for the request payload</td> </tr>
<tr><td><b>API Success Response</b>  </td> <td>

```json
{
    "model_data": [
        {
            "count": 16,
            "model": "F-Series",
            "percent_records": 6.4
        },
        {
            "count": 9,
            "model": "Camry",
            "percent_records": 3.6
        },
...
...
    ],
    "type_data": [
        {
            "percent_records": 69.2,
            "type": "SUV"
        },
        {
            "percent_records": 27.6,
            "type": "Sedan"
        },
...
...
    ]
}
```
</td> </tr>
<tr>
<tr><td><b>API failure Response </b> </td> 
<td>

```json
{"errors": "error message in detail"}
```

</td> 
</tr>
</table>
 
### 3.1.5.7 get_data_utilized() – retrieve the data being utilized per application

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of top 5 applications based on the average data consumption and the average time utilization.  

UnifiedFilters – API payload 

Refer section 3.1.5.4 for the request payload 

AppUtilizationResponse – API response 
<table>
<tr><th>Attribute Name </td> <th>Data Type </th> </tr>
<tr><td><b>app_utilized_graph</b> </td> <td><span style="font-family: Courier New;">Dict</span> </td> </tr>
<tr><td><b>data_consumed_graph</b> </td> <td><span style="font-family: Courier New;">Dict</span> </td> </tr>
</table>

### Prototype
### < 
#### get_data_utilized 

<span style="font-family: Courier New;">
(
IN UnifiedFilters 
OUT AppUtilizationResponse
);
</span>

### >

### Parameters

&lt;in&gt; values are same as described on section 3.1.5.1
<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr><td>&lt;out&gt;</td><td>AppUtilizationResponse </td><td>Response will consist of top 5 applications based on the average data consumption and the average time utilization. </td></tr>
</table>

### Returns 

On success, returns the data consisting of the top 5 applications based on the average data consumption and the average time utilization.  

For failure, returns error code and error message. 

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr><td><b>URL</b>  </td> <td>/dataUtilized </td> </tr>
<tr><td><b>Method</b>  </td> <td>POST  </td> </tr>
<tr><td><b>Content-Type</b>  </td> <td>Application/json  </td> </tr>
<tr><td><b>API request</b>  </td> <td>Refer section 3.1.5.3 for the request payload </td> </tr>
<tr><td><b>API Success Response</b>  </td> <td>

```json
{
    "app_utilized_graph": {
        "Audio Streaming": [
            {
                "application": "Spotify",
                "consumption": 983,
                "time_utilized": 29.61
            },
...
...
        ],
        "Browsing": [
            {
                "application": "Chrome",
                "consumption": 899,
                "time_utilized": 57.16
            },
...
...
        ],
        "Others": [
            {
                "application": "Candy Crush",
                "consumption": 819,
                "time_utilized": 65.1
            },
...
...
        ],
        "VOIP": [
            {
                "application": "Facetime",
                "consumption": 894,
                "time_utilized": 45.5
            },
...
...
        ],
        "Video": [
            {
                "application": "Netflix",
                "consumption": 961,
                "time_utilized": 40.97
            },
...
...
        ]
    },
    "data_consumed_graph": {
        "Audio Streaming": [
            {
                "application": "Spotify",
                "created": "Wed, 09 Feb 2022 00:00:00 GMT",
                "data_volume": 1081
            },
            {
                "application": "Disney Plus",
                "created": "Mon, 14 Feb 2022 00:00:00 GMT",
                "data_volume": 763
            },
...
...
        ]
    }
}
``` 
</td> </tr>
<tr>
<tr><td><b>API failure Response </b> </td> 
<td>

```json
{"errors": "error message in detail"}
```

</td> 
</tr>
</table>

### 3.1.5.8 modem_throughput_data() – retrieve the throughput downlink and uplink data for both LTE and 5G

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of different record groups and their corresponding throughput. Overall avg throughput is also included in the response. The list of record groups is given below: 

<table>
<tr><th>Category </th><th>Range </th></tr>
<tr><td>No service< </td><td>0 </td></tr>
<tr><td>Substandard </td><td>0 – 1 </td></tr>
<tr><td>Moderate </td><td>1 – 10 </td></tr>
<tr><td>Good</td><td>>10</td></tr>
</table>

 UnifiedFilters – API payload 

Refer section 3.1.5.4 for the request payload and have additional two values.

<table>
<tr><th>Attribute Name </th><th>Data Type </th></tr>
<tr><td><b>tech</b> </td><td><span style="font-family: Courier New;">String</span> </td></tr>
<tr><td><b>type</b></td><td><span style="font-family: Courier New;">String</span></td></tr>
</table>

ModemThroughputResponse – API response 
<table>
<tr><th>Attribute Name </th><th>Data Type </th></tr>
<tr><td><b>avg_tput</b> </td><td><span style="font-family: Courier New;">Int</span> </td></tr>
<tr><td><b>record_groups</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>throughput_data</b></td><td><span style="font-family: Courier New;">List</span></td></tr>
</table> 

### Prototype
### < 
#### modem_throughput_data 

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT ModemThroughputResponse
);
</span>

### >

### Parameters

&lt;in&gt; values are same as described on section 3.1.5.1 and have additional two values. 

<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr><td>&lt;in&gt; </td><td>tech </td><td>It indicates the throughput tech LTE or 5G. Allowed values LTE | 5G </td></tr>
<tr><td>&lt;in&gt; </td><td>type </td><td>It indicates the throughput type Uplink or Downlink. Allowed values Uplink | Downlink </td></tr>
<tr><td>&lt;out&gt;</td><td>ModemThroughputResponse</td><td>Response will consist of different record groups and their corresponding throughput. Overall avg throughput is included in the response.</td></tr>
</table> 

### Returns 

On success, returns the data consisting of different record groups and their corresponding throughput. Overall avg throughput is also included in the response.  

For failure, returns error code and error message. 

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr><td><b>URL</b>  </td> <td>/modemThroughput </td> </tr>
<tr><td><b>Method</b>  </td> <td>POST  </td> </tr>
<tr><td><b>Content-Type</b>  </td> <td>Application/json  </td> </tr>
<tr><td><b>API request</b>  </td> <td>Refer section 3.1.5.3 for the request payload. It also contains the additional two values mentioned in the attribute table.</td> </tr>
<tr><td><b>API Success Response</b>  </td> <td>

```json
{ 
    "avg_tput": 12.0, 
    "record_groups": [ 
        { 
            "category": "No service", 
            "percent_records": 0, 
            "range": "0" 
        }, 
        { 
            "category": "Substandard", 
            "percent_records": 19.22, 
            "range": "0 - 1" 
        }, 
        { 
            "category": "Moderate", 
            "percent_records": 64.8, 
            "range": "1 - 10" 
        }, 
        { 
            "category": "Good", 
            "percent_records": 15.97, 
            "range": "> 10" 
        } 
    ], 
    "throughput_data": [ 
        { 
            "latitude": 39.953, 
            "longitude": -75.165, 
            "throughput": 14.99 
        }, 
        { 
            "latitude": 32.736, 
            "longitude": -97.108, 
            "throughput": 11.52 
        }, 
... 
... 
    ] 
} 
```

</td> </tr>
<tr>
<tr><td><b>API failure Response </b> </td> 
<td>

```json
{"errors": "error message in detail"}
```

</td> 
</tr>
</table>
  
### 3.1.5.9 get_analytics_group_summary() – retrieve the clock ticks, CPU and GPU utilization

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of average clock ticks, CPU and GPU utilization. 

UnifiedFilters – API payload 

Refer section 3.1.5.4 for the request payload  

analyticsGroupSummaryResponse – API response 

<table>
<tr><th>Attribute Name </th><th>Data Type </th></tr>
<tr><td><b>clock_ticks</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>cpu</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
<tr><td><b>gpu</b> </td><td><span style="font-family: Courier New;">List</span> </td></tr>
</table>

### Prototype
### < 
#### get_analytics_group_summary 

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT analyticsGroupSummaryResponse
);
</span>

### >

### Parameters

&lt;in&gt; values are same as described on section 3.1.5.1 

<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
<td>
&lt;out&gt;
</td>
<td>
analyticsGroupSummaryResponse 
</td>
<td>
The response contains average of clock ticks, CPU and GPU utilization. 
</td>
</tr>
</table>

### Returns 

On success, returns the data consisting of average clock ticks, CPU and GPU utilization.  

For failure, returns error code and error message. 

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr><td><b>URL</b>  </td> <td>/softSku/analyticsGroupSummary </td> </tr>
<tr><td><b>Method</b>  </td> <td>POST  </td> </tr>
<tr><td><b>Content-Type</b>  </td> <td>Application/json</td> </tr>
<tr><td><b>API request</b>  </td> <td>Refer section 3.1.5.3 for the request payload</td> </tr>
<tr><td><b>API Success Response</b>  </td> <td>

```json
{ 
    "clock_ticks": [ 
        { 
            "clock_ticks": 562.57, 
            "field_value": "Tue, 01 Feb 2022 00:00:00 GMT" 
        }, 
        { 
            "clock_ticks": 545.84, 
            "field_value": "Wed, 02 Feb 2022 00:00:00 GMT" 
        }, 
... 
... 
    ], 
    "cpu": [ 
        { 
            "starttime": "Tue, 01 Feb 2022 00:00:00 GMT", 
            "utilization": 65.61 
        }, 
        { 
            "starttime": "Wed, 02 Feb 2022 00:00:00 GMT", 
            "utilization": 64.94 
        }, 
... 
... 
    ], 
    "gpu": [ 
        { 
            "starttime": "Thu, 03 Feb 2022 00:00:00 GMT", 
            "utilization": 70.61 
        }, 
        { 
            "starttime": "Mon, 21 Feb 2022 00:00:00 GMT", 
            "utilization": 69.02 
        }, 
... 
... 
    ] 
} 
```

</td> 
</tr>

<tr><td><b>API failure Response </b> </td> 
<td>

```json
{"errors": "error message in detail"}
```

</td> 
</tr>
</table>

 <style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
</style>

### 3.1.5.10 model_conditions_stats()[LTE] – retrieve the modem conditions

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of modem conditions such as downlink BLER, uplink BLER and MIMO utilizations. It is returning the avg of those utilizations. The list of conditions is given below:

MIMO Utilization

<table>
<tr>
<th>Category</th><th>Range</th>
</tr>
<tr>
<td>Substandard</td><td>< 10%</td>
</tr>
<tr>
<td>Moderate</td><td>10 – 50 %</td>
</tr>
<tr>
<td>Good</td><td> 50%</td>
</tr>
</table>

Average DL BLER and Average UL BLER

<table>
<tr>
<th>Category</th><th>Range</th>
</tr>
<tr>
<td>Substandard</td><td>> 10%</td>
</tr>
<tr>
<td>Moderate</td><td>1 – 10 %</td>
</tr>
<tr>
<td>Good</td><td>< 1%</td>
</tr>
</table>


UnifiedFilters – API payload

&nbsp;&nbsp;&nbsp;&nbsp;Refer section 3.1.5.4 for the request payload and have additional one value.


<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>tech</b></td>
<td><span style="font-family: Courier New;">String</span></td>
</tr>
</table>

ModemChannelStatConditionResponse – API response

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>dl_data</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>avg_bler</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>avg_mimo</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>ul_data</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
</table>

### Prototype
### < 
#### modem_condition_stats

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT ModemChannelStatConditionResponse
);</span>

### >

### Parameters
&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1 and have additional one values.


<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
<td> &lt;in&gt; </td><td>tech</td><td>It indicates the throughput tech LTE or 5G. Allowed values LTE | 5G</td>
</tr>
<tr>
<td> &lt;out&gt; </td><td>ModemChannelStatConditionResponse</td><td>It contains the modem conditions such as downlink BLER, uplink BLER and MIMO utilizations. It is returning the avg of those utilizations</td>
</tr>
</table>

### Returns

On success, returns the data consisting of modem conditions such as downlink BLER, uplink BLER and MIMO utilizations. It is returning the avg of those utilizations. 

For failure, returns error code and error message.

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/modemConditionStats</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.3 for the request payload. It also contains the additional one value mentioned in attribute table.
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "dl_data": {
        "avg_bler": 14.07,
        "avg_mimo": 32.52
    },
    "ul_data": {
        "avg_bler": 14.05
    }
}
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>


### 3.1.5.11  model_channel_condition_data() – retrieve the modem channel condition data

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of modem channel conditions such as downlink channel condition (RSRQ vs. RSRP) and uplink transmit power distribution. There are two API requests for LTE, one for uplink and one for downlink.

UnifiedFilters – API payload

&nbsp;&nbsp;&nbsp;&nbsp;Refer section 3.1.5.4 for the request payload and have additional two value.

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>tech</b></td>
<td><span style="font-family: Courier New;">String</span></td>
</tr>
<tr>
<td><b>type</b></td>
<td><span style="font-family: Courier New;">String</span></td>
</tr>
</table>

ModemChannelConditionResponse – API response

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>percent_records</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>range_start</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>range_start2</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
</table>

### Prototype
### < 
#### modem_condition_stats

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT ModemChannelConditionResponse
);</span>

### >

### Parameters
&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1 and have additional two values.

<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
<td> &lt;in&gt; </td><td>tech</td><td>It indicates the throughput tech LTE or 5G. Allowed values LTE | 5G</td>
</tr>
<tr>
<td> &lt;in&gt; </td><td>type</td><td>It indicates the throughput type Uplink or Downlink. Allowed values Uplink | Downlink</td>
</tr>
<tr>
<td> &lt;out&gt; </td><td>ModemChannelConditionResponse</td><td>Response will be consisting of modem channel conditions such as Downlink channel condition (RSRQ vs. RSRP) and Uplink Transmit Power Distribution.</td>
</tr>
</table>

### Returns

On success, returns the data consisting of modem channel conditions such as downlink channel condition (RSRQ vs. RSRP) and uplink transmit power distribution.

For failure, returns error code and error message.
 
<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/modemChannelCondition</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.4 for the request payload.
It also contains the additional two value mentioned in request payload attribute table.

{"type": "Uplink", "tech": "LTE"}
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
[
    {
        "percent_records": 32.0,
        "range_start": "-50 - -26",
        "range_start2": -50
    },
    {
        "percent_records": 32.0,
        "range_start": "-26 - -2",
        "range_start2": -26
    },
    {
        "percent_records": 34.0,
        "range_start": "> -2",
        "range_start2": -2
    }
]
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td></td>
</tr>
</table>



<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/modemChannelCondition</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.4 for the request payload.
It also contains the additional two value mentioned in request payload attribute table.
{"type": "Downlink", "tech": "LTE"}
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
[
    {
        "count": 1,
        "rsrp": -107.44,
        "rsrq": -9.08
    },
    {
        "count": 1,
        "rsrp": -102.5,
        "rsrq": -14.77
    },
    {
        "count": 1,
        "rsrp": -80.18,
        "rsrq": -9.1
    },
	...
	...
]
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>

#### 3.1.5.12 model_conditions_stats()[5G] – retrieve the modem conditions

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of modem conditions such as downlink BLER, uplink BLER, MIMO utilizations, DL MCS, UL PUSCH MCS and DL NR Rank. It is returning the avg of those utilizations.

The list of conditions is given below:

MIMO Utilization

<table>
<tr>
<th>Category</th><th>Range</th>
</tr>
<tr>
<td>Substandard</td><td>< 10%</td>
</tr>
<tr>
<td>Moderate</td><td>10 – 50 %</td>
</tr>
<tr>
<td>Good</td><td> 50%</td>
</tr>
</table>

Average NR DL BLER and Average NR UL BLER

<table>
<tr>
<th>Category</th><th>Range</th>
</tr>
<tr>
<td>Substandard</td><td>> 10%</td>
</tr>
<tr>
<td>Moderate</td><td>1 – 10 %</td>
</tr>
<tr>
<td>Good</td><td>< 1%</td>
</tr>
</table>

UnifiedFilters – API payload

&nbsp;&nbsp;&nbsp;&nbsp;Refer section 3.1.5.4 for the request payload and have additional one value. 

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>tech</b></td>
<td><span style="font-family: Courier New;">String</span></td>
</tr>
</table>

ModemChannelStatCondition5GResponse – API response9

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>dl_data</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>avg_bler</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>avg_mcs</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>avg_mimo</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>avg_nr_rank</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>ul_data</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>avg_pusch_mcs</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
</table>

### Prototype
### < 
#### modem_condition_stats

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT ModemChannelStatCondition5GResponse
);
</span>

### >

### Parameters
&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1 and have additional one value.

<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
<td> &lt;in&gt; </td><td>tech</td><td>It indicates the throughput tech LTE or 5G. Allowed values LTE | 5G</td>
</tr>
<tr>
<td> &lt;out&gt; </td><td>ModemChannelStatCondition5GResponse</td><td>The response contains the modem conditions such as downlink BLER, uplink BLER and MIMO utilizations</td>
</tr>
</table>

### Returns

On success, returns the data consisting of modem conditions such as downlink BLER, uplink BLER and MIMO utilizations. It is returning the avg of those utilizations.

For failure, returns error code and error message.

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/modemConditionStats</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.4 for the request payload.
It also contains the additional one value mentioned in the request payload attribute table.
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "dl_data": {
        "avg_bler": 14.31,
        "avg_mcs": 13.46,
        "avg_mimo": 32.52,
        "avg_nr_rank": 3.50
    },
    "ul_data": {
        "avg_bler": 14.23,
        "avg_pusch_mcs": 13.51
    }
}
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>

### 3.1.5.13 model_rlf_data() – retrieve the modem RLF data

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of average of RLF and RLF data.

The list of RLF status is given below:

MIMO Utilization

<table>
<tr>
<th>Category</th><th>Range</th>
</tr>
<tr>
<td>Substandard</td><td>< 5%</td>
</tr>
<tr>
<td>Moderate</td><td>1 – 5 %</td>
</tr>
<tr>
<td>Good</td><td>> 1%</td>
</tr>
</table>

UnifiedFilters – API payload

&nbsp;&nbsp;&nbsp;&nbsp;Refer section 3.1.5.4 for the request payload and have additional one value.
failure_causes
- RACH_PROBLEM
- NONE
- HO_FAILURE
- RLF
- CFG_FAILURE

ModemRLFdataResponse – API response

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>dl_data</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>avg_bler</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>avg_mimo</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>ul_data</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
</table>

### Prototype
### < 
#### modem_rlf_data

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT ModemRLFdataResponse
);
</span>

### >

### Parameters
&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1 and have additional one value.


<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
<td> &lt;in&gt; </td><td>causes</td><td>It specifies the list of modem RLF failure causes.</td>
</tr>
<tr>
<td> &lt;out&gt; </td><td>ModemRLFdataResponse</td><td>Response data consisting of average of RLF and RLF data.</td>
</tr>
</table>

### Returns

On success, returns the data consisting of average of RLF and RLF data.

For failure, returns error code and error message.

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/modemConditionStats</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.3 for the request payload with may have the additional failure causes.
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "avg_rlf": 3.89,
    "rlf_data": [
        {
            "failure_cause": "RACH_PROBLEM",
            "failure_count": 168,
            "latitude": 34.0520000000,
            "longitude": -118.2440000000
        },
        {
            "failure_cause": "CFG_FAILURE",
            "failure_count": 764,
            "latitude": 34.0520000000,
            "longitude": -118.2440000000
        },
        {
            "failure_cause": "NONE",
            "failure_count": 0,
            "latitude": 34.0520000000,
            "longitude": -118.2440000000
        },
        ...
        ...
        
    ]
}
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>


### 3.1.5.14  get_analytics_group_buckets() – retrieve the CPU and GPU utilization time

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of CPU and GPU utilization ranges with the total time it is consumed. We are calculating the percentage of time in each of CPU and GPU utilization bucket. Taking 5 CPU and GPU utilization bars from the min and max utilization values.

The list of RLF status is given below:

UnifiedFilters – API payload

&nbsp;&nbsp;&nbsp;&nbsp;Refer section 3.1.5.4 for the request payload

AnalyticsGroupBucketsResponse – API response

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>cpu_utilization_bucket</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>gpu_utilization_bucket</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>cpu_utilization_percent </b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>percent_records</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
</table>

### Prototype
### < 
#### modem_rlf_data

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT AnalyticsGroupBucketsResponse
);
</span>

### >

### Parameters
&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1

### Returns

On success, returns the data consisting of CPU and GPU utilization ranges (5 bars will be created from the min and max of the CPU and GPU utilization) with the total time it is consumed.

For failure, returns error code and error message.

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/softSku/analyticsGroupBuckets</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.3 for the request payload
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "cpu_utilization_bucket": [
        {
            "cpu_utilization_percent": "70",
            "percent_records": 100.00
        }
    ],
    "gpu_utilization_bucket": [
        {
            "gpu_utilization_percent": "58",
            "percent_records": 19.81
        },
        {
            "gpu_utilization_percent": "64",
            "percent_records": 19.53
        }
    ]
}
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>

### 3.1.5.15  get_analytics_group() – retrieve the clock ticks, CPU and GPU utilization and data volume

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of average of clock ticks, CPU and GPU utilization and data volume. If user selected all apps from all categories, then top 5 apps will be selected from the clock ticks and data volume result. We are finding the average of the clock ticks and data volume by applying the unified filters. CPU and GPU utilization is application independent, and we are calculating the average across the selected date range. Default would be 30 days. If user selected only specific apps in the unified filters, then we will pick whatever apps user selected from the clock ticks and data volume results. 

UnifiedFilters – API payload

&nbsp;&nbsp;&nbsp;&nbsp;Refer section 3.1.5.4 for the request payload

AnalyticsGroupResponse – API response

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>avg_cpu_utilization</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>avg_gpu_utilization</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>clock_ticks</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>cpu</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>gpu</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>data_volume</b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
</table>

### Prototype
### < 
#### get_analytics_group

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT AnalyticsGroupResponse
);
</span>

### >

### Parameters
&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1

### Returns

On success, returns the data consisting of average of clock ticks, CPU and GPU utilization and data volume.

For failure, returns error code and error message.

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/softSku/analyticsGroupSummary</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.3 for the request payload
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "clock_ticks": [
        {
            "clock_ticks": 562.57,
            "field_value": "Tue, 01 Feb 2022 00:00:00 GMT"
        },
        {
            "clock_ticks": 545.84,
            "field_value": "Wed, 02 Feb 2022 00:00:00 GMT"
        },
	...
	...
    ],
    "cpu": [
        {
            "starttime": "Tue, 01 Feb 2022 00:00:00 GMT",
            "utilization": 65.61
        },
        {
            "starttime": "Wed, 02 Feb 2022 00:00:00 GMT",
            "utilization": 64.94
        },
	...
	...
    ],
    "gpu": [
        {
            "starttime": "Thu, 03 Feb 2022 00:00:00 GMT",
            "utilization": 70.61
        },
        {
            "starttime": "Mon, 21 Feb 2022 00:00:00 GMT",
            "utilization": 69.02
        },
	...
	...
    ]
}
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>

### 3.1.5.16  get_app_utlization_by_date () – retrieve the application utilization for both data volume and time with respect to each service type category

&nbsp;&nbsp;&nbsp;&nbsp;This endpoint will return the data consisting of utilization trends and utilization summary data. In utilization trends we were calculating the average of the time each application utilized on each day in the provided date.
In utilization summary data we were calculating the percentage of time each application utilized in the given date range.
 

UnifiedFilters – API payload

&nbsp;&nbsp;&nbsp;&nbsp;Refer section 3.1.5.4 for the request payload. It also contains additional one value.

<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>type</b></td>
<td><span style="font-family: Courier New;">String</span></td>
</tr>
</table>

AppUtilDrillDownResponse – API response

<service_category> : Values

- VOIP
- Video
- Application Streaming
- Browsing
- Others


<table>
<tr>
<th>Attribute Name</th><th>Data Type</th>
</tr>
<tr>
<td><b>utilization_summary</b></td>
<td><span style="font-family: Courier New;">Dict</span></td>
</tr>
<tr>
<td><b>utilization_trends</b></td>
<td><span style="font-family: Courier New;">Dict</span></td>
</tr>
<tr>
<td><b>application</b></td>
<td><span style="font-family: Courier New;">String</span></td>
</tr>
<tr>
<td><b>data_volume_utilized</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>field_value</b></td>
<td><span style="font-family: Courier New;">String</span></td>
</tr>
<tr>
<td><b> < service_category > </b></td>
<td><span style="font-family: Courier New;">List</span></td>
</tr>
<tr>
<td><b>utilization</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
<tr>
<td><b>time_utilized</b></td>
<td><span style="font-family: Courier New;">Int</span></td>
</tr>
</table>

### Prototype
### < 
#### get_app_utlization_by_date 

<span style="font-family: Courier New;">
(
IN UnifiedFilters
OUT AppUtilDrillDownResponse
);
</span>

### >

### Parameters
&nbsp;&nbsp;&nbsp;&nbsp; &lt;in&gt; values are same as described on section 3.1.5.1 and have additional one value.

<table>
<tr>
    <th> in/out </th>
    <th>Parameter</th>
    <th>Description </th>
</tr>
<tr>
<td> &lt;in&gt; </td>
<td>type</td>
<td>It specifies the type of application utilization data needed. It has only two values it is “data” or “time.”</td>
</tr>
<tr>
<td> &lt;out&gt; </td>
<td>AppUtilDrillDownResponse</td>
<td>Response contains the data consisting of utilization trends and utilization summary data.</td>
</tr>
</table>

### Returns

On success, returns the data consisting of utilization trends and utilization summary data.

For failure, returns error code and error message.

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/applicationUtilization</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.3 for the request payload and additional one value
{“type”:” time”}
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "utilization_summary": {
        "VOIP": [
            {
                "application": "Facetime",
                "utilization": 44.33
            },
            ...
            ...
        ]
    },
    "utilization_trends": {
        "VOIP": [
            {
                "application": "Facetime",
                "field_value": "Sat, 26 Feb 2022 00:00:00 GMT",
                "time_utilized": 3
            },
            ...
            ...
        ]
    }
}
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>

<table>
<tr>
    <th colspan="2" style="text-align:center;">API Details</th>
</tr>
<tr>
<td><b>URL</b></td> 
<td><b>/applicationUtilization</b></td>
</tr>
<tr>
<td><b>Method</b></td> 
<td>POST</td>
</tr>
<tr>
<td><b>Content-Type</b></td> 
<td>Application/json</td>
</tr>
<tr>
<td><b>API request</b></td> 
<td>Refer section 3.1.5.3 for the request payload and additional one value
{“type”:”data”}
</td>
</tr>
<tr>
<td><b>API Success Response</b></td>
<td>

```json
{
    "utilization_summary": {
        "VOIP": [
            {
                "application": "Facetime",
                "utilization": 48.84
            },
           ...
           ...
        ]
    },
    "utilization_trends": {
        "VOIP": [
            {
                "application": "Facetime",
                "data_volume_utilized": 847,
                "field_value": "Sat, 26 Feb 2022 00:00:00 GMT"
            },
            ...
            ...
        ]
    }
}
```
</td>
</tr>
<tr>
<td><b>API failure Response</b></td> 
<td>

```json
{"errors": "error message in detail"}
```
</td>
</tr>
</table>



### <a id="PerformnaceAnalysisandKPI"></a>3.1.6 Performance – analysis and KPIs

N/A

### <a id="_LowLevelSoftwareDesign"></a>3.2 Low-level software design

N/A

### <a id="_LowLevelDesignSequenceDiagram"></a>3.2.1 Lowlevel design sequence/interaction diagram

N/A

### <a id="_Security"></a>3.2.2 Security
     
* Validates input 

* Does not allow dynamic construction of queries using user-supplied data 

* Signed to verify the authenticity of its origin 

* Does not use predictable session identifiers 

* Does not hard-code secrets inline 

* Does not cache credentials 

* Handles exceptions explicitly 

* Does not disclose too much information in its errors 

* Does not use weak cryptographic algorithms 

* Uses randomness in the derivation of cryptographic keys 

* Stores cryptographic keys securely 

* Does not use banned APIs or unsafe functions

### <a id="_ErrorHandling"></a>3.2.3 Error handling

Functional safety: 

* Usage of try catch blocks in every important method so that the processor will not get terminated even if one method fails. Exceptions are caught and logged properly 

* Validating the allowed values for the payload fields and return error if it is not valid. 

* Request payload validation and internal API invocation errors will be catches and return to the user 

* In case of Json processing exception, the exceptions are caught and logged properly.

### <a id="_LoggingMechanism"></a>3.2.4 Logging mechanism
All the projects are having a common logging framework which is implemented in the module c2c_analytics_api. Execution time is logged for every method which uses @entry_exit_log decorator. Entry and exit log will be logged by this module for every public method. Id is injected to all logs. Along with-it identifiers like message type, message id etc. is also logged in every line.

## <a id="_Verification"></a>4 Verification

### <a id="_SoftwareDesignVerificationMechanism"></a>4.1 Software design verification mechanism

N/A

### <a id="_Description"></a>4.1.1 Description

N/A

### <a id="_SWUnitTest"></a>4.1.2 Requirements to SW unit test traceability

N/A

### <a id="_SWUnitTestPlan"></a>4.2 Unit test plan procedure

Unified Analytics APIs unit test cases: 

We write unit test for all APIs. All API unite test function will start with ‘test_<method name>’. These unit test will verify the request payload and response are valid. 

* test_unified_filters 

* test_user_behaviour 

* test_vehicle_type 

* test_data_utilized 

* test_soft_sku_analytics_group 

* test_analytics_group_buckets 

* test_analytics_group_summary 

* test_apps_utilization_data 

* test_apps_utilization_time 

* test_vin_groups 

* test_modem_rlf 

* test_modem_channel_downlink_cond 

* test_modem_channel_uplink_cond 

* test_modem_throughput 

* test_modem_condition_stats 

* test_unified_analytics_group 

* test_analytics_group_get 

* test_analytics_group_id 

* test_vin_info 

* test_error_handler 

* test_segment_selection 

* test_analytics_group_post 

* test_data_monitor_list 

* test_data_monitor_results 

All the above test cases will fire request to the server, and it validates the request payload and the response.

Unified Analytics API - Sonar Report

<figure>
<img src="../../../assets/unifiedanalytics/sonar_qube.png" width="900" />
<figcaption>Unified Analytics API - Sonar Report</figcaption>
</figure>

### <a id="_TestStrategy"></a>4.3 Test strategy recommendation

N/A

## <a id="_Conventions"></a>5 Requirements traceability summary

<table>
  <tr>
    <th>#</th>
    <th>Type of requirement</th>
    <th>Architecture/ design tag </th>
    <th>Reference PR #</th>
    <th>ER #</th>
    <th>Applicable ASIL level (for FuSa only)</th>
    <th>ER requirement specification</th>
  </tr>
  <tr>
    <td>1</td>
    <td>Functional</td>
    <td>AUTORFI-14774</td>
    <td></td>
    <td>AUTORFI-14774</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should be able to create a documentation based on the given template. </td>
  </tr>
  <tr>
    <td>2</td>
    <td>Functional</td>
    <td>AUTORFI-14773</td>
    <td></td>
    <td>AUTORFI-14773</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should be able to support the QA testing for Unified analytics so that the feature validation completes on time. </td>
  </tr>
   <tr>
    <td>3</td>
    <td>Functional</td>
    <td>AUTORFI-13821</td>
    <td></td>
    <td>AUTORFI-13821</td>
    <td>N/A </td>
    <td>As a unified analytics user, I should be able to see the selected filters if an updated date is selected in data monitoring dropdown. </td>
  </tr>
  <tr>
    <td>4</td>
    <td>Functional</td>
    <td>AUTORFI-13820</td>
    <td></td>
    <td>AUTORFI-13820</td>
    <td>N/A </td>
    <td>As a unified analytics user, I want to see the applications under “Other” category if they do not fit into any one of “Audio”, “Video”, “Browsing” or “VOIP”. </td>
  </tr>
  <tr>
    <td>5</td>
    <td>Functional</td>
    <td>AUTORFI-13819</td>
    <td></td>
    <td>AUTORFI-13819</td>
    <td>N/A </td>
    <td>As a unified analytics user, I want to see the impacted vehicle details when an update date is selected. </td>
  </tr>
  <tr>
    <td>6</td>
    <td>Functional</td>
    <td>AUTORFI-13818</td>
    <td></td>
    <td>AUTORFI-13818</td>
    <td>N/A </td>
    <td>As a unified analytics user, I want to differentiate the “No service” category among other values in the throughput map.</td>
  </tr>
  <tr>
    <td>7</td>
    <td>Functional</td>
    <td>AUTORFI-13817</td>
    <td></td>
    <td>AUTORFI-13817</td>
    <td>N/A </td>
    <td>As a unified analytics developer, I want to make sure that the created segment is unique and there are no existing segments created with the same set of filter criteria. </td>
  </tr>
  <tr>
    <td>8</td>
    <td>Functional</td>
    <td>AUTORFI-13783</td>
    <td></td>
    <td>AUTORFI-13783</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should be able to support the QA testing for Unified analytics so that the feature validation completes on time </td>
  </tr>
  <tr>
    <td>9</td>
    <td>Functional</td>
    <td>AUTORFI-13761</td>
    <td></td>
    <td>AUTORFI-13761</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should be able to write unit testcases to improve the test coverage of unified analytics UI </td>
  </tr>
  <tr>
    <td>10</td>
    <td>Functional</td>
    <td>AUTORFI-13092</td>
    <td></td>
    <td>AUTORFI-13092</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should make sure that there is no Blocker, Critical and Major code violations in Sonar analysis </td>
  </tr>
  <tr>
    <td>11</td>
    <td>Functional</td>
    <td>AUTORFI-12940</td>
    <td></td>
    <td>AUTORFI-12940</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should be able to support the QA testing for Unified analytics so that the feature validation completes on time </td>
  </tr>
  <tr>
    <td>12</td>
    <td>Functional</td>
    <td>AUTORFI-12939</td>
    <td></td>
    <td>AUTORFI-12939</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should be able to write unit testcases to improve the test coverage of unified analytics UI</td>
  </tr>
   <tr>
    <td>13</td>
    <td>Functional</td>
    <td>AUTORFI-12938</td>
    <td></td>
    <td>AUTORFI-12938</td>
    <td>N/A </td>
    <td>As a C2CPlatform developer I should be able to write unit testcases to improve the test coverage of analytics APIs</td>
  </tr>
</table>