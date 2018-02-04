//
//  Protocols.swift
//  fennec
//
//  Created by eliksir on 04/02/2018.
//  Copyright © 2018 eliksir. All rights reserved.
//

import Foundation

//////////////////////
// Component
//////////////////////
public protocol Updatable {
    mutating func update()
}
public protocol Component: Updatable {
}

//////////////////////
// Entity
//////////////////////
public protocol Unique {
    var id: UUID { get set }
}

public protocol Composable {
    func addComponent(_ component: Component)
    func component<T>(_ componentType: T.Type) -> T? where T : Component
    func removeComponent<T>(_ componentType: T.Type) where T : Component
}

public protocol Entity: Unique, Composable, Updatable {
}
public extension Entity {
    public func update() {
        if let allKeys = System.shared.components[id]?.keys {
            let keys = Array(allKeys)
            for i in 0..<keys.count {
                let key = keys[i]
                if var component = System.shared.components[id]?[key] {
                    component.update()
                    if Mirror(reflecting: component).displayStyle != Mirror.DisplayStyle.class {
                        System.shared.components[id]?[key] = component
                    }
                }
            }
        }
    }
}
extension Entity {
    public func addComponent(_ component: Component) {
        if System.shared.components[id] == nil {
            System.shared.components[id] = [:]
        }
        System.shared.components[id]![String(describing: type(of: component))] = component
    }
    public func component<T>(_ componentType: T.Type) -> T? where T : Component {
        return System.shared.components[id]?[String(describing: componentType)] as? T
    }
    public func removeComponent<T>(_ componentType: T.Type) where T : Component {
        System.shared.components[id]?[String(describing: componentType)] = nil
    }
}
