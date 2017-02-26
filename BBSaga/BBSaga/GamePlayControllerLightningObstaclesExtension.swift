//
//  GamePlayControllerLightningObstaclesExtension.swift
//  BBSaga
//
//  Created by luoyuyang on 26/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit
import PhysicsEngine

extension GamePlayController {
    func setUpLightningObstacles() {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            guard let segmentShape = target.shape as? SegmentShape else {
                return false
            }
            let p1 = segmentShape.p1.dx < segmentShape.p2.dx ? segmentShape.p1 : segmentShape.p2  // left end point
            let p2 = segmentShape.p1.dx < segmentShape.p2.dx ? segmentShape.p2 : segmentShape.p1  // right end point
            return (target.position.dx + p2.dx <= 0 && target.velocity.dx < 0) ||  // left side wall
                (target.position.dx + p1.dx >= weakSelf.view.bounds.width && target.velocity.dx > 0)
        }
        let callback = { (target: RigidBody) in
            target.position.dy = CGFloat(Int.randomWithinRange(lower: Setting.obstacle1VerticalRangeUpper,
                                                               upper: Setting.obstacle1VerticalRangeLower))
            target.velocity.dx = -target.velocity.dx
        }
        let lightningObstacleBorderCollisionEventDetector = EventDetector(detectEvent: detectEvent, callback: callback)
        world.addEventDetector(lightningObstacleBorderCollisionEventDetector)
        lightningObstacleBorderCollisionEventDetector.addTarget(setUpLightningObstacle(origin: Setting.obstacle1Origin,
                                                                                       numSection: 2,
                                                                                       rotationAngle: 0,
                                                                                       initVelocity: Setting.obstacle1Velocity))
        lightningObstacleBorderCollisionEventDetector.addTarget(setUpLightningObstacle(origin: Setting.obstacle2Origin,
                                                                                       numSection: 1,
                                                                                       rotationAngle: Setting.obstacle2Angle,
                                                                                       initVelocity: CGVector.zero))
        lightningObstacleBorderCollisionEventDetector.addTarget(setUpLightningObstacle(origin: Setting.obstacle3Origin,
                                                                                       numSection: 1,
                                                                                       rotationAngle: Setting.obstacle3Angle,
                                                                                       initVelocity: CGVector.zero))
    }
    
    private func setUpLightningObstacle(origin: CGPoint, numSection: Int, rotationAngle: CGFloat, initVelocity: CGVector) -> RigidBody {
        let obstacleView = Animation.createLightningObstacleView(origin: origin,
                                                                 numSections: numSection)
        let angle1 = rotationAngle
        let angle2 = rotationAngle + CGFloat(M_PI)
        let r = obstacleView.bounds.width / 2
        obstacleView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        view.addSubview(obstacleView)
        
        let obstacle = RigidBody(mass: 1)
        
        obstacle.position = CGVector(obstacleView.center)
        let start = CGVector(dx: r * cos(angle1), dy: r * sin(angle1))
        let end = CGVector(dx: r * cos(angle2), dy: r * sin(angle2))
        obstacle.shape = SegmentShape(from: start, to: end)
        
        
        let detector = CollisionDetector(callback: { [weak self] (body1: RigidBody, body2: RigidBody) in
            guard let weakSelf = self else {
                return
            }
            if !(body1.shape is CircleShape && body2.shape is CircleShape) {
                let bubble = body1.shape is CircleShape ? body1 : body2
                if let bubbleFrame = weakSelf.renderer.getCorrespondingView(of: bubble)?.frame {
                    Animation.animateLightningDisappear(within: bubbleFrame, in: weakSelf.view)
                }
                weakSelf.gameEngine.removeRigidBody(bubble)
                if weakSelf.leftProjectileCount < 0 {
                    weakSelf.endGame()
                }
            }
        })
        detector.addTarget(obstacle)
        world.addCollisionDetector(detector)
        world.addBody(obstacle)
        renderer.register(body: obstacle, view: obstacleView)
        
        obstacle.velocity = initVelocity
        return obstacle
    }
}







