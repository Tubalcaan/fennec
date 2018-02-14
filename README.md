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

```Swift
struct MyEntity: Entity {
    var id: UUID = UUID()
}
```
## Component
Components all implement the Component protocol. You may extend any type with this protocol or create your own
```Swift
struct PositionComponent: Component {
    var x: Int = 0
    var y: Int = 0
}
```
Components have a default implementation of the "update(deltaTime:)" method. You may redefine this method to provide a behavior when component must be updated after a certain TimeInterval
```Swift
struct PositionComponent: Component {
    var x: Int = 0
    var y: Int = 0

    mutating func update(deltaTime seconds: TimeInterval) {
        x += 2
        y += 1
    }
}
```

### Managing Components in Entity
Entities provide methods to handle Components

#### Adding a Component
```Swift
var entity = MyEntity(id: UUID())
var positionComponent = PositionComponent(x: 10, y: 20)
entity.addComponent(positionComponent)
```
#### Retrieving a Component
```Swift
let positionComponent = entity.component(PositionComponent.self)
positionComponent?.x // Optional(10)
// You may also use : entity[PositionComponent.self]
```
#### Updating a Component
⚠️ Warning : you must be careful about the original type of your component when updating it. Don't forget Value Types are copied when modified.
```Swift
// your component is a struct
if var positionComponent = entity.component(PositionComponent.self) {
  positionComponent.x = 12
  entity.addComponent(positionComponent) // replace the old component
}

// your component is a class
let positionComponent = entity.component(PositionComponent.self)
positionComponent?.x = 12
```
#### Removing a Component
```Swift
entity.removeComponent(PositionComponent.self)
// entity.component(PositionComponent.self) returns nil
```
## System
The Systems provide a centralized way to handle components of a certain type. Systems are added to the engine.

#### Defining a System
```Swift
struct PositionSystem: System {
    var id: UUID = UUID()

    func update(deltaTime seconds: TimeInterval) {
      // get the components or entities you need to update
    }
}
```
## Engine
The Engine is the heart of the ECS. You add your entities and your systems to the Engine. You can also group your entities.

#### Adding an Entity to the Engine
```Swift
// add the entity in the default group (default group contains all entities)
Engine.shared.addEntity(entity)

// add the entity in the group "aGroup" (and in the default group as well)
Engine.shared.addEntity(entity, inGroup: "aGroup")
```
#### Retrieving an Entity
```Swift
Engine.shared.entities() // retrieves all entities in the default group

Engine.shared.entities(inGroup: "aGroup") // retrieves all entities in group "aGroup"
```
#### Removing an Entity from the Engine
```Swift
Engine.shared.removeEntity(entity) // removes the person from all groups
```
#### Mass updating
```Swift
Engine.shared.addSystem(mySystem)
Engine.shared.update(deltaTime: 0.2) // executes the update(deltaTime:) of all added systems
```
# Installation
## Carthage

To install, simply add the following lines to your Cartfile :
```ruby
github "Tubalcaan/Fennec" ~> 1.0
```
