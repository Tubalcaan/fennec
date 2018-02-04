![Fennec Logo](fennec.png)

# Fennec
Fennec is a light and portable implementation of Entity-Component System

# Purpose of Fennec
Fennec is intended to enhance your data objects so that you can implement a **light Entity-Component System**.

You can create or transform your business objects into **Entities** and convert all their attributes to **Components**.

Entity-Component System allows you to make business changes easier and provides you with more scalability and reusability of your objects.

# Implementation

## Entity

Entities all implement the Entity protocol.

Depending on your design, you may have only one type for all your objects (an Entity is only a component container) or one Entity for every object you handle in your application.

### One for all
You may have only one Entity type for all your objects
```Swift
struct GenericEntity: Entity {
    var id: UUID = UUID()
}
```
### One Entity per type
```Swift
struct PersonEntity: Entity {
    var id: UUID = UUID()
}
struct DogEntity: Entity {
    var id: UUID = UUID()
}
```

## Component
Components all implement the Component protocol. You may extend any type with this protocol or create your own
```Swift
struct NameComponent: Component {
    var firstName: String = ""
    var lastName: String = ""
}
```
Components have a default implementation of the "update()" method. You may redefine this method to provide a behavior when component must be updated
```Swift
struct NameComponent: Component {
    var firstName: String = ""
    var lastName: String = ""

    mutating func update() {
        firstName = ""
        lastName = ""
    }
}
```
### Managing Components in Entity
Entities provide methods to handle Components
#### Adding a Component
```Swift
var person = PersonEntity(id: UUID())
var nameComponent = NameComponent(firstName: "John", lastName: "Doe")
person.addComponent(nameComponent)
```
#### Retrieving a Component
```Swift
let nameComponent = person.component(NameComponent.self)
nameComponent?.firstName // Optional("John")
```
#### Updating a Component
⚠️ Warning : you must be careful about the original type of your component when updating it. Don't forget Value Types are copied when modified.
```Swift
// your component is a struct
person.component(NameComponent.self)?.firstName = "Johnny"

// your component is a class
let nameComponent = person.component(NameComponent.self)
nameComponent?.firstName = "Johnny"
```
#### Removing a Component
```Swift
person.removeComponent(NameComponent.self)
// person.component(NameComponent.self) returns nil
```
## System
The System singleton provides methods to attach the entities and apply mass transformations to all or a subset of entities

#### Adding an Entity to the System
```Swift
System.shared.addEntity(person)
```
You can also categorize your entities by groups
```Swift
System.shared.addEntity(person, toGroup: "DogOwners") // the person Entity is also added to the default group
```
#### Retrieving an Entity
```Swift
System.shared.entities() // retrieves all entities in the default group

System.shared.entities(inGroup: "DogOwners") // retrieves all entities in group "DogOwners"
```
#### Removing an Entity from the System
```Swift
System.shared.removeEntity(person) // removes the person from all groups
```
#### Mass updating
```Swift
System.shared.update() // execute all update methods of all the entities components

System.shared.update(entitiesInGroup: "DogOwners") components
```
# Installation
## Carthage
