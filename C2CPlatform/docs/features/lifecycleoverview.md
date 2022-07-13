### Overview

Lifecycle Management is a holistic approach to managing the different states of the vehicle and its underlying entities (device, chipsets)  during the process of device registration and provisioning. It manages the synchronization of various states of the entities between cloud and device so that they are in sync if there is any transition in the life cycle.. 

#### Entities in C2C Platform
1.	Vehicle - Each vehicle has Gateway Hardware Unit. This hardware unit contains one or more sub-systems such as Entertainment, Display, Navigation Systems, etc. Which is unique to vehicle make and model. This gateway hardware unit is manufactured by Tier-1/Tier-2 OEM and assembled by Automotive OEM.
2.	Device - Each "Sub-system" has one or more ECU. ECUs are of 3 types. TCU: Telematics Control Unit IVI: In-Vehicle Infotainment ADAS: Advanced Driver Assistance System
3.	Chipset - Each ECU (Electronic Control Unit) have one or more chipsets.
