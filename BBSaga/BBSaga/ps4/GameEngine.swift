//
//  GameEngine.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit
import PhysicsEngine

class GameEngine {
    private(set) var world: World
    private(set) var renderer: Renderer
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
    private let framePerSecond: Int
    
    init(framePerSecond: Int) {
        world = World()
        renderer = Renderer()
        self.framePerSecond = framePerSecond
    }
    
    /// use CADisplayLink to make the game loop run per 1/60 second,
    /// the same as the frame rate of the screen
    func startGameLoop() {
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        displayLink.preferredFramesPerSecond = framePerSecond
    }

    func terminateGameLoop() {
        displayLink.invalidate()
    }

    /// the game loop that is run per 1/60 second
    /// first the world (physical engine) update (including checking for user-specifed event and collisions)
    /// then the renderer draw the "world" out to the screen
    @objc private func gameLoop() {
        world.update(timeInterval: 1 / Double(framePerSecond))
        renderer.render()
    }
    
    /// remove the target from gameEngine
    /// this is done by:
    /// firstly, remove the target from World (physics engine)
    ///     which will also trigger event and collision detectors to remove the target
    /// secondly, remove the corresponding view of the target from its superview
    /// thirdly, remove the target and its corresponding view from renderer
    func removeRigidBody(_ target: RigidBody) {
        world.removeBody(target)  // this will also trigger Detectors to remove this body
        if let targetView = self.renderer.getCorrespondingView(of: target) {
            targetView.removeFromSuperview()
            self.renderer.remove(body: target)
        }
    }
}





