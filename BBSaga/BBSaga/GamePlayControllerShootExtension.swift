//
//  GamePlayControllerShootExtension.swift
//  BBSaga
//
//  Created by luoyuyang on 26/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit
import PhysicsEngine

extension GamePlayController {
    
    /// helper function to bind gesture recognizers
    func bindGestureRecognizer(to view: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(shootByTapping(_:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                         action: #selector(shootByPanning(_:))))
    }

    /// when players tap at the screen
    /// shoot a bubble projectile toward that direction
    @objc private func shootByTapping(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: view)
        calculateVelocityAndShootTo(point: point)
        rotateCannon(towards: point)
    }
    
    /// when players panning, show a bean to indicate the predicted trajectory
    /// when players lift off their fingers, shoot the ball toward that direction
    @objc private func shootByPanning(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            updateAimingBeam(point: recognizer.location(in: view))
            rotateCannon(towards: recognizer.location(in: view))
        case .ended:
            calculateVelocityAndShootTo(point: recognizer.location(in: view))
            removeAimingBeam()
        default:
            break
        }
    }
    
    private func removeAimingBeam() {
        for view in aimingBeam {
            view.removeFromSuperview()
        }
        aimingBeam = []
    }
    
    private func updateAimingBeam(point: CGPoint) {
        removeAimingBeam()
        
        // draw new aiming beam
        var v = CGVector(point) - bubbleShooterPosition
        v = Setting.aimingBeamStepLength * (v / v.norm())  // length for each step
        var currentPosition = bubbleShooterPosition + v
        var hasCollideWithGridBubble = false
        for _ in 0 ... Setting.aimingBeamStepNum {  // number of steps
            if hasCollideWithGridBubble {
                break
            }
            currentPosition = currentPosition + v
            
            var frame = CGRect()
            frame.size = Setting.pathNodeSize
            let pathNode = UIImageView(frame: frame)
            pathNode.center = currentPosition.toCGPoint()
            pathNode.image = Setting.pathNodeImage
            aimingBeam.append(pathNode)
            view.addSubview(pathNode)
            
            // collide with side wall
            if currentPosition.dx <= bubbleRadius || currentPosition.dx + bubbleRadius >= view.bounds.width {
                v.dx = -v.dx
            }
            // collide with grid bubbles
            for position in positionsOfGridBubbles {
                if currentPosition.distance(to: position) <= 2 * bubbleRadius {
                    let headNode = aimingBeam.removeLast()
                    headNode.removeFromSuperview()
                    hasCollideWithGridBubble = true
                    break
                }
            }
        }
    }
    
    /// calculate the velocity of the bubble projectile
    /// based on the position players tap or finish panning
    /// then, shoot the ball
    private func calculateVelocityAndShootTo(point: CGPoint) {
        let v = CGVector(point) - bubbleShooterPosition
        let velocity = bubbleProjectileSpeed * (v / v.norm())
        if velocity.dy < Setting.minimumShootingVerticalComponent {
            shoot(bubble: Bubble(), velocity: velocity)
        }
    }
    
    /// shoot the bubble. this is done by:
    /// create a view to represent the projectile ball on the screen and attach it to view as a subview
    /// create a body to represent the projectile ball in the world (physical engine)
    /// add this pair to the renderer
    private func shoot(bubble: Bubble, velocity: CGVector) {
        guard let color = BubbleColor(rawValue: Int.randomWithinRange(lower: 0, upper: 3)) else {
            return
        }
        
        // create projectile bubble body
        let bubbleProjectile = BubbleProjectile(of: pendingBubble.replica(),
                                                radius: bubbleRadius)
        bubbleProjectile.position = bubbleShooterPosition
        bubbleProjectile.velocity = velocity
        
        // add the projectile as a target of eventDetectors
        for eventDetector in world.eventDetectors {
            eventDetector.addTarget(bubbleProjectile)
        }
        
        // add the projectile as a target of collisionDetectors
        for collisionDetector in world.collisionDetectors {
            collisionDetector.addTarget(bubbleProjectile)
        }
        
        // create uiview and add it as subview to view
        let bubbleProjectileView = UIImageView(frame: CGRect(x: bubbleShooterPosition.dx - bubbleRadius,
                                                             y: bubbleShooterPosition.dy - bubbleRadius,
                                                             width: 2 * bubbleRadius,
                                                             height: 2 * bubbleRadius))
        bubbleProjectileView.image = Setting.imageOfBubble(bubbleProjectile.getBubble())
        view.addSubview(bubbleProjectileView)
        
        // register projectile bubble into the world physical engine
        world.addBody(bubbleProjectile)
        // register projectile bubble body and uiview to renderer
        renderer.register(body: bubbleProjectile, view: bubbleProjectileView)
        
        // update current choosed bubble
        pendingBubble.setColor(nextBubble.getColor())
        pendingBubbleView.image = Setting.imageOfBubble(nextBubble)
        
        nextBubble.setColor(color)
        nextBubbleView.image = Setting.imageOfBubble(nextBubble)
        countDownProjectilesLeft()
        if leftProjectileCount <= 0 {
            nextBubbleView.image = nil
        }
        
        animateCannon()
        audioPlayer.playShootSoundEffect()
    }
    
    private func rotateCannon(towards position: CGPoint) {
        let center = cannonView.center
        let y = position.y - center.y
        let x = position.x - center.x
        var angle = atan(y / x)
        if angle < 0 { angle = angle + CGFloat(M_PI) }
        
        UIView.animate(withDuration: 0.08, animations: { [weak self] _ in
            self?.cannonView.transform = CGAffineTransform(rotationAngle: angle - CGFloat(M_PI / 2))
        })
    }
    
    private func animateCannon() {
        cannonView.animationImages = Animation.cutSequenceImageIntoImages(named: Setting.cannonSpriteSheetName,
                                                                          numRows: 2, numCols: 6)
        cannonView.animationDuration = 0.38
        cannonView.animationRepeatCount = 0
        cannonView.startAnimating()
        delay(0.38) {
            self.cannonView.stopAnimating()
        }
    }
    
    private func countDownProjectilesLeft() {
        leftProjectileCount -= 1
        if leftProjectileCount >= 0 {
            leftProjectileCountLabel.text = String(leftProjectileCount)
        }
    }
}
