# AudioLibrary
A simple AudioLibrary application to download and listen songs

## Architecutre
**Name:** VIP (Clean Architecture)

**Layers of Architecture:**

**View Layer:** The application's user interface is represented by the view layer, which simply requests information from the domain layer and displays it.

**Domain Layer:** duties of the domain layer,
 1 Application business logic is stored in the domain layer.
 2 Respond to the request sent by the view layer and deliver the data layer the request.
 3 Analyze the information obtained from the Data layer and deliver it back to the view layer.
 
**Data Layer:** There are two workers in the data layer: a local worker and a network worker. Local worker receives the request from Domain layer and responds with Data which stored locally (Usually from CoreData). As the name implies network worker hit the server with the given request and send the response to the domain layer.
