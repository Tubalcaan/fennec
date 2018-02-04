# Fennec
Fennec is a light and fast implementation of Entity-Component System

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

## Component

## System
