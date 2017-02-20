//
//  RigidBody.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 4/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class RigidBody: Hashable {
    var acceleration = CGVector(dx: 0, dy: 0)
    var velocity = CGVector(dx: 0, dy: 0)
    var position = CGVector(dx: 0, dy: 0)
    var shape: Shape!
    var mass: Double
    
    var hashValue: Int {
        return position.dx.hashValue ^ position.dy.hashValue
    }
    
    init(mass: Double) {
        self.mass = mass
    }
    
    /// Update the physics property of this RigidBody.
    /// This method will be called by World.update(timeInterval: TimeInterval)
    func update(timeInterval: TimeInterval) {
        let nextVelocity = velocity + timeInterval * acceleration
        let averageVelocity = (velocity + nextVelocity) / 2
        position = position + timeInterval * averageVelocity
        velocity = nextVelocity
    }
    
    public static func ==(lhs: RigidBody, rhs: RigidBody) -> Bool {
        return lhs === rhs
    }
}






