//
//  CollisionDetector.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 7/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

public class CollisionDetector {
    private var circleShapeTargets: [RigidBody] = []
    private var segmentShapeTargets: [RigidBody] = []
    private var callback: ((RigidBody, RigidBody) -> Void)
    
    public init(callback: @escaping (((RigidBody, RigidBody)) -> Void)) {
        self.callback = callback
    }
    
    public init() {
        callback = { _,_ in }
    }
    
    public func addTarget(_ target: RigidBody) {
        if target.shape is CircleShape && !circleShapeTargets.contains(target) {
            circleShapeTargets.append(target)
        }
        if target.shape is SegmentShape && !segmentShapeTargets.contains(target) {
            segmentShapeTargets.append(target)
        }
    }
    
    public func removeTarget(_ target: RigidBody) {
        circleShapeTargets.removeEqualItems(item: target)
        segmentShapeTargets.removeEqualItems(item: target)
    }
    
    /// check for collisions between rigid bodies and trigger callback method if collision is detected
    public func check() {
        // circle-circle collision
        for (body1, body2) in circleShapeTargets.getAllPairs() {
            if body1.shape.overlap(at: body1.position, with: body2.shape, at: body2.position) {
                let p1 = body1.position
                let p2 = body2.position
                let v1 = body1.velocity
                let v2 = body2.velocity
                if  (p2 - p1) * (v1 - v2) > 0 {  // if two bodeis are approaching each other

                    // the accuracy of the following method depends on the accuracy of (p1 - p2)
                    // however, since (p1 - p2) is not accurate (1/60-second delay, that is, p1 - p2 is not the value at the moment of collision)
                    // therefore, the result of this method is also not accurate
                    let m1 = CGFloat(body1.mass)
                    let m2 = CGFloat(body2.mass)
                    let distance = (p1 - p2) * (p1 - p2)
                    let helperTerm = (p1 - p2) * (v1 - v2) / distance
                    body1.velocity = v1 - (2 * m2) / (m1 + m2) * helperTerm * (p1 - p2)
                    body2.velocity = v2 - (2 * m1) / (m1 + m2) * helperTerm * (p2 - p1)
                    callback(body1, body2)
                    
                    // this is the sinple method to deal with the perfectly elastic collision between 2 circle body of the same mass
                    // let linkLine = body2.position - body1.position
                    // body1.velocity = -1 * body1.velocity.reflect(by: linkLine)
                    // body2.velocity = -1 * body2.velocity.reflect(by: linkLine)
                }
            }
        }
        
        for circleBody in circleShapeTargets {
            for segmentBody in segmentShapeTargets {
                if circleBody.shape.overlap(at: circleBody.position,
                                            with: segmentBody.shape,
                                            at: segmentBody.position) {
                    callback(circleBody, segmentBody)
                }
            }
        }
    }
}
