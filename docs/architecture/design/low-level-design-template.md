---
title: Design Document Title
template: documenttemplate.html
---



**Low Level Design Document**
<center>

# **Design Document Title** 

</center>

<p style="page-break-after: always;">&nbsp;</p>

## Table of Contents

[1. Introduction](#_Introduction)     
[1.1 Scope](#_Scope)      
[1.2 Out of Scope](#_OutofScope)      
[1.3 Assumption](#_Assumption)      
[2. Design](#_Design)     
[2.1 Class Diagram](#_ClassDiagram)      
[2.2 Interface Details](#_InterfaceDetails)      
[3. Libraries and Dependencies](#_LibrariesandDependencies)     
[4. Database design](#_Databasedesign)     
[5. Application configuration](#_Applicationconfiguration)     
[6. Additional Details](#_AdditionalDetails)     
[7. How to](#_Howto)     

<p style="page-break-after: always;">&nbsp;</p>


NOTE :: Remove all the information blocks after details are added for the section. 

### <a id="_Introduction"></a>1. Introduction 

```
Give a detailed introduction about the component. 
```

### <a id="_Scope"></a>1.1 Scope 

```
Focus on below details:
  * Functional 
  * Non functional
```

### <a id="_OutofScope"></a>1.2 Out of Scope 

```
Focus on below details:
  * Functional 
  * Non functional
```

### <a id="_Assumption"></a>1.3 Assumption 
```
List all the assumptions considered for the development in bulleted format.
```


## <a id="_Design"></a>2. Design

```
Give a detailed description of the architecture / design of the components. 
    * Attach the architecture diagram and explain the major flows and components.
    * If you have sequence diagram that should also do but explain it in detailed manner. 

Approach and Rationale behind the desing should get depicted here in the section.

"How to insert images" - See below steps.
	1. Copy the image to the same folder where this document will be uploaded.
	2. use syntax as 
		<figure>
				<img src="../imagenamewithextension" width="300" />
				<figcaption>Image caption</figcaption>
		</figure>
```


### <a id="_ClassDiagram"></a>2.1 Class Diagram
```
Give a detailed description, role and responsibility of the every item in the class diagram of the components. 
    * Attach the class diagram and explain the major flows and components. 

Approach and Rationale behind the desing should get depicted here in the section.

"How to insert images" - See below steps.
	1. Copy the image to the same folder where this document will be uploaded.
	2. use syntax as 
		<figure>
				<img src="../imagenamewithextension" width="300" />
				<figcaption>Image caption</figcaption>
		</figure>
```


### <a id="_InterfaceDetails"></a>2.2 Application Interface Details
```
Give a detailed description of the interface. Explain every interface function exposed by the interface. 
    
```

## <a id="_LibrariesandDependencies"></a>3. Libraries and Dependencies
```
Give a detailed list of the dependecies and libraries used by the component.
    
```

## <a id="_Databasedesign"></a>4. Database design
```
If the component has database component, then make sure to provide data base design and explain it in detail. 
Also provide the data dictionary for the datatables and fields. 

If the component does not have database, mark it as NA.
    
```

## <a id="_Applicationconfiguration"></a>5. Application configuration
```
Provide details of the all the elements those are part of configuration file and mention purpose, list of values and data type of every elements mentioned in the Configuration file.
   
```
 
## <a id="_AdditionalDetails"></a>6. Additional Details
```
Please provided additional details for hte component covering and not restricted to 
   * Logging & monitoring.
   * Authentication and Authorization
   * Scalability and Performance.
   * Reporting  
   
```

## <a id="_Howto"></a>7. How to
```
If the component is reusable component, e.g. like SQS adapteror Logger, make sure to provide a detailed description, steps and integration details on how to consume the component.

If the component is an independent component, mark it as NA.

If the component is a UI, please add all the details.
    
```
