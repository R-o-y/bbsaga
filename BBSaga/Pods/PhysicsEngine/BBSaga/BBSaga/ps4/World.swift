//
//  PhysicsNgin.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 4/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

public class World {
    public private(set) var rigidBodies: [RigidBody] = []
    public private(set) var eventDetectors: [EventDetector] = []
    public private(set) var collisionDetectors: [CollisionDetector] = []
    
    public init() {}
    
    /// for every time step, this method will be called
    /// it will:
    /// 1. detect events and invoke callback if events are detected
    /// 2. detect collisions and invoke callback if collisions are detected
    /// 3. update the physics property of all the RigidBody it keeps track of
    /// - Parameter timeInterval: the length of the time step
    public func update(timeInterval: TimeInterval) {
        for eventDetector in eventDetectors {
            eventDetector.check()
        }
        
        for collisionDetector in collisionDetectors {
            collisionDetector.check()
        }
        
        for rigidBody in rigidBodies {
            rigidBody.update(timeInterval: timeInterval)
        }
    }

    public func addBody(_ rigidBody: RigidBody) {
        if !rigidBodies.contains(rigidBody) {
            rigidBodies.append(rigidBody)
        }
    }
    
    /// remove the specifed rigidBody from the world
    /// after this, the world will not update its physics propert such as position and velocity
    /// this will also trigger EventDetector and CollisionDetector to remove this rigidBody
    public func removeBody(_ rigidBody: RigidBody) {
        for eventDetector in eventDetectors {
            eventDetector.removeTarget(rigidBody)
        }
        
        for collisionDetector in collisionDetectors {
            collisionDetector.removeTarget(rigidBody)
        }
        
        rigidBodies.removeEqualItems(item: rigidBody)
    }
    
    public func addEventDetector(_ eventDetector: EventDetector) {
        eventDetectors.append(eventDetector)
    }
    
    public func addCollisionDetector(_ collisionDetector: CollisionDetector) {
        collisionDetectors.append(collisionDetector)
    }
}




