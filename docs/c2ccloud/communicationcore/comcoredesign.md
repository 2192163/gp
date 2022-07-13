---
title: Design Document Title
---

# ** *Design Document Title* **

<p style="page-break-after: always;">&nbsp;</p>

NOTE :: Remove all the information blocks after details are added for the section. 

## <a id="_Introduction"></a>1. Introduction 

```
Give a detailed introduction and purpose of the component.
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

## <a id="_Architecture"></a>2. Architecture

### <a id="_HLD"></a>2.1 High level software design

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

### <a id="_Sequence"></a>2.2 Sequence diagram
```
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


**NOTE** :: Acronyms and terms or concepts can be added in below section and it will be rendered as a tooltip in the document. 
```
    * Abide to the below style to add a Acronyms and terms or concepts
```
*[\<abbrevation>]: Definition


## Communication Core

| Component Name|   Summary |  |   
| :------------- | :------------ | :------------: |    
| C2D Sender |  |  [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}CommunicationCore/C2DSender/){ target="_blank"} |    
| C2D Request API |  | [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}CommunicationCore/C2DSenderAPI/){  target="_blank"} |   
| Message Dispatcher |  | [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}CommunicationCore/MessageDispatcher/){  target="_blank"} | 
| Message Storage Processor |  | [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}CommunicationCore/StorageProcessor/){  target="_blank"} | 
| Route Config API |  | [:material-microsoft-teams: Open]({{ c2cdocuments.repositoryBase }}{{ c2cdocuments.cloudComponents }}CommunicationCore/RouteConfigAPI/){  target="_blank"} |
