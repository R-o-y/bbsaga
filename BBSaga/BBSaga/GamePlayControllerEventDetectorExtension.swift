//
//  GamePlayControllerEventDetectorExtension.swift
//  BBSaga
//
//  Created by luoyuyang on 26/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit
import PhysicsEngine

extension GamePlayController {
    /// add event-detectors to the world
    /// these events will be checked everty time the world update
    func addEventDetectors() {
        world.addEventDetector(createVerticalBorderCollisionEventDetector())
        world.addEventDetector(createUpperBorderCollisionEventDetector())
        world.addEventDetector(createGridBubbleCollisionEventDetector())
        world.addEventDetector(createBottomBorderCollisionEventDetector())
    }
    
    /// check the collision between the projectile bubble and the left/right wall
    /// if collide, reverse the x-component of the velocity
    private func createVerticalBorderCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            return (target.position.dx <= weakSelf.bubbleRadius && target.velocity.dx < 0) ||  // left side wall
                (target.position.dx + weakSelf.bubbleRadius >= weakSelf.view.bounds.width && target.velocity.dx > 0)
        }
        let callback = { (target: RigidBody) in
            return target.velocity.dx = -target.velocity.dx
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }
    
    /// check the collision between the projectile bubble and the uppper wall
    /// if collide, find the closest empty cell and settle there
    /// then check whether there are 3 or more connected bubbles to be removed
    private func createUpperBorderCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            return target.position.dy <= weakSelf.bubbleRadius + CGFloat(Setting.statusBarHeight)
        }
        let callback = { [weak self] (target: RigidBody) in
            if let weakSelf = self {
                weakSelf.settleBubbleProjectileAndCheck(target)
            }
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }
    
    /// check the collision between the projectile bubble and the bottom wall
    /// if collide, remove this projectile from game
    /// that is, this projectile will be removed from physics engine and renderer
    /// and its corresponding view will be removed from its superview
    private func createBottomBorderCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            return target.position.dy >= weakSelf.view.bounds.height
        }
        let callback = { [weak self] (target: RigidBody) in
            if let weakSelf = self {
                weakSelf.gameEngine.removeRigidBody(target)
            }
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }
    
    /// check the collision between the projectil bubble with the bubble in the grid
    /// if collide, find the closest empty cell and settle there
    /// then check whether there are 3 or more connected bubbles to be removed
    private func createGridBubbleCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            for position in weakSelf.positionsOfGridBubbles {
                if target.position.distance(to: position) <= 2 * weakSelf.bubbleRadius {
                    return true
                }
            }
            return false
        }
        let callback = { [weak self] (target: RigidBody) in
            if let weakSelf = self {
                weakSelf.settleBubbleProjectileAndCheck(target)
            }
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }

}



















