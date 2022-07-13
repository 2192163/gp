**C2C Analytics Design Document**

*V 1.0*

March 2022

# Table of Contents

[1. Introduction](#introduction)

[1.1 Purpose](#purpose)

[1.2 C2C Analytics High-level Flow Diagram](#c2c-analytics-high-level-flow-diagram)

[2. Unified Analytics Dashboard](#unified-analytics-dashboard)

[3. Unified Analytics Modules Design](#unified-analytics-modules-design)

[3.1 Data mapping and Calculations](#data-mapping-and-calculations)

[3.2 ETL Process](#etl-process)

[3.2.1 Android Data Pipeline](#android-data-pipeline)

[3.2.2 CA pipeline](#ca-pipeline)

[3.2.3 Modem Data Pipeline](#modem-data-pipeline)

[3.2.4 Unified Data Analytics Pipeline](#unified-data-analytics-pipeline)

# <a id="introduction"></a>**Introduction**

## <a id="purpose"></a>**1.1 Purpose** 

The purpose of C2C Unified Dashboard solution is, to provide data
visualization by curating aggregated data into a form easier to
understand, highlighting the trends and patterns of in- vehicle data
collected through campaigns. Unified view helps OEM understand network
and processor performance, infotainment applications usage, driving
statistic, user behavior, data consumption etc. targeting interested
sections of dashboards by applying filters and drill-down of data.

OEMs can leverage this information to provide better in-vehicle
experiences, troubleshoot issues, and target/segment customers for new
services, applications, and content offerings, ultimately extracting
value through continuous engagement with consumers.

## <a id="c2c-analytics-high-level-flow-diagram"></a>**1.2 C2C Analytics High-level Flow Diagram**

<img src="../../../assets/analyticspipeline/C2C_Analytics_high_level_flow_diagram.png" style="width:7.40586in;height:4.40016in"
alt="A picture containing diagram Description automatically generated" />

# <a id="unified-analytics-dashboard"></a>**Unified Analytics Dashboard**

> Unified dashboard is collection of multiple sections like user
> behavior, network and processor performance, application usage,
> smartphone usage etc. Unified view of aggregated vehicle data provides
> OEMs with better understanding of their customer needs as well as
> vehicle performance.
>
> With the help of this information, OEMs can provide cohesive suites of
> products for enabling secure services—entertainment subscriptions,
> navigation, and driver assistance. Services can help car manufacturers
> improve value, offer superior user experiences, and create service
> revenue opportunities throughout each stage of a vehicle’s lifecycle
> as customers unlock additional features or purchase new applications. 
>
> Data collection campaigns are scheduled to collect infotainment and
> TCU in-vehicle data through various android data loggers. These logged
> modem and android data files are then loaded into raw/staging tables
> which are further extracted, transformed, and aggregated using
> necessary logic/algorithms and loaded into reporting tables to be used
> for data visualization by C2C unified platform.
>
> OEMs can target subset of vehicle campaign data applying unified
> filters on all the reports of dashboard and create a segment. This
> segment metadata is then sent back to CCM for new targeted vehicle
> data collection campaign to study and get more insights into user
> behavior as well as vehicle performance.
>
> Unified dashboard sections:

1.  **User Behavior -** User behavior section helps OEM to get answers
    for questions like - What is the daily average drive time of a user?
    What is the average speed or distance travelled? What are the top
    models used by customers? To retain customers, companies need to
    provide customizable experiences through OTA updates that fit
    individual needs. OTA updates can allow people to pay for features
    on demand, ranging from enhanced telematics and infotainment
    solutions to safety features such as driver assistance technologies.

2.  **Application Data utilization –** OEMs can monitor applications’
    data consumption of in-vehicle infotainment unit to study how data
    is being used – top used applications, audio/video customer
    preference etc. OEMs can leverage such information to understand
    customer demands and offer superior user experiences providing
    entertainment service packages with the car while providing
    consumers more choices for upgrades.

3.  **Connectivity performance –** It tracks connectivity % of vehicle
    throughout the drive time. Automakers can also be strategic about
    their partnerships, prioritizing work with mobile network providers
    and technology partners who will provide reliable global
    connectivity ensuring a smooth user experience.

4.  **Processor Performance -** The processors power in-vehicle
    infotainment (IVI) and advanced driver assistance systems (ADAS).
    Specialized processors, including an energy-efficient quad-core CPU,
    a powerful GPU, and dedicated audio, video, and image processors
    delivers the ability to handle more sensors and tasks. Using
    Analytic Solutions OEM can assess the trend of processor/CPU/GPU
    performance through graphical representations, based on which
    decisions can be made whether to provide SKU upgrades.

# <a id="unified-analytics-modules-design"></a>**Unified Analytics Modules Design**

Unified dashboard uses vehicle data fed by analytics modules which run
on daily basis to extract, transform, aggregate and load data into
report tables. Analytics modules written in SQL/Spark source data from
raw/staging modem and android tables. These report tables provide
necessary dimensions and aggregated measures to visualize information on
unified dashboards.

Report tables:

1.  **Application_data_utilization –** Application data utilization
    report table KPIs can help OEMs to understand user needs and
    behavior. KPIs – Data volume, drive speed, drive distance, drive
    distance etc.

2.  **Modem_performance –** Modem performance report table includes
    dimensions that provides vehicle information like model, year, type
    and, KPIs – LTE/NR uplink/downlink performance, LTE/NR throughput,
    DL/UL BLER, MIMO, RSRP, RSRQ, Rank indicator, D/UL MCS, RLF Rate,
    Failure count etc. to help understand network performance.

3.  **Processor_performance -** Processor performance report table KPIs
    help OEMs to track processor performance of the vehicles. KPIs –
    CPU/GPU Utilization, clockticks etc.

    1.  ## <a id="data-mapping-and-calculations"></a>**Data mapping and Calculations**

Data Mapping and calculations used in analytics scripts are available in
below excel sheet–

![](media/image2.png)
<iframe width="700" height="900" frameborder="0" scrolling="no" src="https://qualcomm.sharepoint.com/teams/Car-to-CloudCollateralProject/_layouts/15/Doc.aspx?sourcedoc={ffd88a4d-f41a-4ada-bd3f-c51cc2630978}&action=embedview&wdAllowInteractivity=False&wdHideGridlines=True&wdHideHeaders=True&wdDownloadButton=True&wdInConfigurator=True&wdInConfigurator=True"></iframe>
 
## <a id="etl-process"></a>**ETL Process**

Data collection campaigns are scheduled to collect infotainment and TCU
in-vehicle data through various android data loggers. These logged modem
and android data files are then loaded into raw/staging tables which are
further extracted, transformed, and aggregated using analytics modules
and loaded into reporting tables to be used for data visualization by
C2C unified platform.

Data Flow:

### <a id="android-data-pipeline"></a>**3.2.1 Android Data Pipeline**

This pipeline is used to load android data from files to raw tables in
staging area.

### <a id="ca-pipeline"></a>**3.2.2 CA pipeline**

CA pipeline runs in cloud to load modem data from logcode files to json
files in S3 buckets.

<https://confluence.qualcomm.com/confluence/display/CAN/HLD>

### <a id="modem-data-pipeline"></a>**3.2.3 Modem Data Pipeline**

Modem data pipeline runs in cloud spinning EMR clusters. Analytics Spark
scripts are executed on EMR nodes to extract JSON files from S3 buckets,
perform aggregation and load into parquet format in target S3 buckets.
Amazon glue is used to create crawler jobs to identify and create
schemas from these parquet files. These parquet files are then read
using redshift spectrum as an external table with the help of schema
created in Amazon glue.

Config file includes pre-requisite services needed to create EMR cluster
–

<https://github.qualcomm.com/x-cloud/x-cloud_Analytics_Modules/blob/master/config.txt>

Analysis scripts-

<https://github.qualcomm.com/x-cloud/x-cloud_Analytics_Modules/tree/master/spark_scripts>

Scripts to create and run EMR cluster –

<https://github.qualcomm.com/x-cloud/x-cloud_Analytics_Modules/tree/master/scripts>

Data pipeline –

<https://us-east-1.console.aws.amazon.com/datapipeline/home?region=us-west-2#ExecutionDetailsPlace:pipelineId=df-02561581XKJ72KZ2WV35&show=latest>

### <a id="unified-data-analytics-pipeline"></a>**3.2.4 Unified Data Analytics Pipeline**

Unified analytics pipeline runs the SQL scripts which extract raw
android and modem data, aggregates and loads into report tables.

Analytics scripts –

<https://github.qualcomm.com/x-cloud/x-cloud_Analytics_Modules/tree/master/SQL>

Data pipeline –

<https://us-east-1.console.aws.amazon.com/datapipeline/home?region=us-west-2#ExecutionDetailsPlace:pipelineId=df-01083452UZIRZOY6WJFO&show=latest>
