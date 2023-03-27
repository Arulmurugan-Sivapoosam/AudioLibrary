# AudioLibrary
A simple AudioLibrary application to download and listen songs

## Architecutre
**Name:** VIP (Clean Architecture)

**Layers of Architecture:**

**View Layer:** The application's user interface is represented by the view layer, which simply requests information from the domain layer and displays it.

**Domain Layer:** duties of the domain layer,

 - Application business logic is stored in the domain layer.
 
 - Respond to the request sent by the view layer and deliver the data layer the request.

 - Analyze the information obtained from the Data layer and deliver it back to the view layer.
 
**Data Layer:** There are two workers in the data layer: a local worker and a network worker. Local worker receives the request from Domain layer and responds with Data which stored locally (Usually from CoreData). As the name implies network worker hit the server with the given request and send the response to the domain layer.



## Code coverage
**Unit Test: 77.2 %** 
**UI Test: 45.5%**

## Working Sample

https://user-images.githubusercontent.com/46676192/227996120-f3d3f088-0266-43d0-b7e4-2c98701077e0.MP4

