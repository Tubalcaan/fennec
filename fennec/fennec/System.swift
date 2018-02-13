//
//  System.swift
//  fennec
//
//  Created by eliksir on 04/02/2018.
//  Copyright © 2018 eliksir. All rights reserved.
//

import Foundation

// TODO: remove entity from group

public extension Entity {
    public func addComponent(_ aComponent: Component) {
        if Engine.shared.allComponents[aComponent.componentType] == nil {
            Engine.shared.allComponents[aComponent.componentType] = [:]
        }
        Engine.shared.allComponents[aComponent.componentType]![id] = aComponent
    }
    public func component<T>(_ componentType: T.Type) -> T? where T : Component {
        return Engine.shared.allComponents[String(describing: componentType)]?[id] as? T
    }
    public func removeComponent<T>(_ componentType: T.Type) where T : Component {
        Engine.shared.allComponents[String(describing: componentType)]?[id] = nil
    }
    subscript<T>(_ componentType: T.Type) -> T? where T : Component {
        return component(componentType)
    }
}


public typealias ComponentType = String
public protocol System: Unique {
    func update(deltaTime seconds: TimeInterval)
}

public struct Engine {
    public static var shared = Engine()
    private var allEntities: [UUID:Entity] = [:]
    fileprivate var allComponents: [ComponentType:[UUID:Component]] = [:]
    private var groups: [String:[Entity]] = [:]
    private var systems: [UUID:System] = [:]
    
    public mutating func addEntity(_ entity: Entity, inGroup group: String = "") {
        allEntities[entity.id] = entity
        if groups[""] == nil {
            groups[""] = []
        }
        if groups[group] == nil {
            groups[group] = []
        }
        groups[""]?.append(entity)
        if group != "" {
            groups[group]?.append(entity)
        }
    }
    
    public mutating func removeEntity(_ entity: Entity) {
        allEntities[entity.id] = nil
        // TODO
        // remove entity from "" group and its group
        groups.enumerated().forEach { (offset: Int, element: (key: String, value: [Entity])) in
            if let index = groups[element.key]?.index(where: { ent -> Bool in
                entity.id == ent.id
            }) {
                groups[element.key]?.remove(at: index)
            }
        }
        // remove all components of the entity
        var comps: [Component] = []
        allComponents.enumerated().forEach { (offset: Int, element: (key: ComponentType, value: [UUID:Component])) in
            if let component = allComponents[element.key]?[entity.id] {
                comps.append(component)
            }
        }
        comps.forEach { comp in
            allComponents[comp.componentType]?[entity.id] = nil
        }
    }
    
    public func update(deltaTime seconds: TimeInterval) {
        systems.enumerated().forEach { (offset: Int, element: (key: UUID, value: System)) in
            element.value.update(deltaTime: seconds)
        }
    }
    
    public func entities(inGroup group: String = "") -> [Entity] {
        return groups[group] ?? []
    }
    
    public mutating func addSystem(_ system: System) {
        systems[system.id] = system
    }
    
    public mutating func removeSystem(_ system: System) {
        systems[system.id] = nil
    }
    
    public func entity(_ id: UUID) -> Entity? {
        return allEntities[id]
    }
    
    public func entities<T>(with componentType: T.Type) -> [Entity] {
        let comps = allComponents[String(describing: componentType)]?.flatMap({ (tuple: (key: UUID, value: Component)) -> Entity? in
            return allEntities[tuple.key]
        }) ?? []
        
        return comps
    }
    
    public func components<T>(_ componentType: T.Type) -> [T] where T : Component {
        let comps = allComponents[String(describing: componentType)]?.map({ (tuple: (key: UUID, value: Component)) -> Component in
            return tuple.value
        }) ?? []
        
        return comps as! [T]
    }
}
