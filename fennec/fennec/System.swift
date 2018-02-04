//
//  System.swift
//  fennec
//
//  Created by eliksir on 04/02/2018.
//  Copyright © 2018 eliksir. All rights reserved.
//

import Foundation

// TODO: remove entity from group

public typealias ComponentType = String
public struct System: Updatable {
    public static var shared = System()
    private var entities: [Entity] = []
    var components: [UUID:[ComponentType:Component]] = [:]
    private var groups: [String:[Entity]] = [:]
    
    public mutating func addEntity(_ entity: Entity, toGroup group: String = "") {
        entities.append(entity)
        if groups[""] == nil {
            groups[""] = []
        }
        if groups[group] == nil {
            groups[group] = []
        }
        groups[""]?.append(entity)
        groups[group]?.append(entity)
    }
    
    public mutating func removeEntity(_ entity: Entity) {
        if let index = entities.index(where: { (ent: Entity) -> Bool in
            ent.id == entity.id
        }) {
            entities.remove(at: index)
            components[entity.id] = nil
        }
    }
    
    public func update() {
        entities.forEach { entity in
            entity.update()
        }
    }
    
    public func update(entitiesInGroup group: String = "") {
        if group == "" {
            update()
        } else {
            groups[group]?.forEach { entity in
                entity.update()
            }
        }
    }
    
    public func entities(inGroup group: String = "") -> [Entity] {
        return groups[group] ?? []
    }
    
    public func execute(_ block: (Entity)->(), onGroup group: String = "") {
        let selectedEntities: [Entity]
        
        if group == "" {
            selectedEntities = entities
        } else {
            selectedEntities = groups[group] ?? []
        }
        
        selectedEntities.forEach { entity in
            block(entity)
        }
    }
}
