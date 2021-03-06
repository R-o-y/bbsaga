//
//  RigidBody.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 4/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

open class RigidBody: Hashable {
    open var acceleration = CGVector(dx: 0, dy: 0)
    open var velocity = CGVector(dx: 0, dy: 0)
    open var position = CGVector(dx: 0, dy: 0)
    open var shape: Shape!
    open var mass: Double
    
    open var hashValue: Int {
        return position.dx.hashValue ^ position.dy.hashValue
    }
    
    public init(mass: Double) {
        self.mass = mass
    }
    
    /// Update the physics property of this RigidBody.
    /// This method will be called by World.update(timeInterval: TimeInterval)
    open func update(timeInterval: TimeInterval) {
        let nextVelocity = velocity + timeInterval * acceleration
        let averageVelocity = (velocity + nextVelocity) / 2
        position = position + timeInterval * averageVelocity
        velocity = nextVelocity
    }
    
    open static func ==(lhs: RigidBody, rhs: RigidBody) -> Bool {
        return lhs === rhs
    }
}






