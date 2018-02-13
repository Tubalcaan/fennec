<center><img src="fennec.png" width=400></center>

# Fennec
Fennec is a light and portable implementation of Entity-Component System (aka _ECS_)

# Purpose of Fennec
Fennec is intended to enhance your data objects so that you can implement a **light Entity-Component System**.

You can create or transform your business objects into **Entities** and convert all their attributes to **Components**.

Entity-Component System allows you to make business changes easily and provides you with more scalability and reusability of your objects.

Fennec's main components are
* **Entities** : the objects you handle in your application
* **Components** : the attributes and behavior of your entities
* **Systems** : the managers dedicated to certain types of components
* **Engine** : the main manager of all above

# Implementation

## Entity

Entities all implement the Entity protocol.

Depending on your design, you may have only one type for all your objects (an Entity is only a component container) or one Entity for each kind of object you handle in your application.

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
Components have a default implementation of the "update(deltaTime:)" method. You may redefine this method to provide a behavior when component must be updated after a certain TimeInterval
```Swift
struct NameComponent: Component {
    var firstName: String = ""
    var lastName: String = ""

    mutating func update(deltaTime seconds: TimeInterval) {
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
// You may also use : person[NameComponent.self]
```
#### Updating a Component
⚠️ Warning : you must be careful about the original type of your component when updating it. Don't forget Value Types are copied when modified.
```Swift
// your component is a struct
if var component = person.component(NameComponent.self) {
  component.firstName = "Johnny"
  person.addComponent(component) // replace the old component
}

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
The Systems provide a centralized way to handle components of a certain type. Systems are added to the engine.

#### Defining a System
```Swift
struct NameSystem: System {
    var id: UUID = UUID()

    // if your component is a value type, you must reset the component every time
    func update(deltaTime seconds: TimeInterval) {
      // get the components or entities you need to update
    }
}
```
You can also categorize your entities by groups
```Swift
System.shared.addEntity(person, toGroup: "DogOwners") // the person Entity is also added to the default group
```
## Engine
The Engine is the heart of the ECS. You add your entities and your systems to the Engine. You can also group your entities.

#### Adding an Entity
```Swift
Engine.shared.addEntity(entity)

Engine.shared.addEntity(entity, inGroup: "aGroup")
```
#### Retrieving an Entity
```Swift
Engine.shared.entities() // retrieves all entities in the default group

Engine.shared.entities(inGroup: "DogOwners") // retrieves all entities in group "DogOwners"
```
#### Removing an Entity from the Engine
```Swift
System.shared.removeEntity(person) // removes the person from all groups
```
#### Mass updating
```Swift
Engine.shared.addSystem(mySystem)
Engine.shared.update(deltaTime: 0.2) // executes the update(deltaTime:) of all added systems
```
# Installation
## Carthage
