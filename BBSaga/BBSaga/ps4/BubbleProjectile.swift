//
//  BubbleProjectile.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class BubbleProjectile: RigidBody {
    private var bubble: Bubble
    
    init(of bubble: Bubble, radius: CGFloat) {
        self.bubble = bubble
        super.init(mass: 1)
        self.shape = CircleShape(radius: radius)
    }
    
    func getBubble() -> Bubble {
        return bubble
    }
}
