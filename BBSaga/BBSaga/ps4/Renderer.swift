//
//  Renderer.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 4/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit
import PhysicsEngine

/**
 the Renderer class keeps an array of (RigiBody, UIView) pair
 the UIView is the visual representation of the RigidBody on the screen
 when the Renderer renders, it update the display property of the UIView 
 according to the physics property of the RigidBody
 (current the only property considered is position)
 */
class Renderer {
    private var bodyViewMapping: [(RigidBody, UIView)] = []
    
    func register(body: RigidBody, view: UIView) {
        bodyViewMapping.append((body, view))
    }
    
    func remove(body: RigidBody) {
        if let index = bodyViewMapping.index(where: { $0.0 == body }) {
            bodyViewMapping.remove(at: index)
        }
    }
    
    func getCorrespondingView(of body: RigidBody) -> UIView? {
        if let index = bodyViewMapping.index(where: { $0.0 == body }) {
            return bodyViewMapping[index].1
        }
        return nil
    }
    
    func render() {
        for (body, view) in bodyViewMapping {
            view.center = body.position.toCGPoint()
        }
    }
}
