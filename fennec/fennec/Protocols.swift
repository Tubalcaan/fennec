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
    mutating func update(deltaTime seconds: TimeInterval)
}
public protocol Component: Updatable {
}

extension Component {
    var componentType: ComponentType {
        return String(describing: type(of: self))
    }
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

public protocol Entity: Unique, Composable {
}
