//
//  DropView.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

/**
 this is an view that helps removing other views with animtion
 the animation includes:
 - free fall with gravity
 - bounce on the bottom
 - while falling and bouncing, fade out
 */
class DropView: UIView {
    private lazy var animator = UIDynamicAnimator()
    
    private let gravity = UIGravityBehavior()
    private let collider = UICollisionBehavior()
    private let itemBehavior = UIDynamicItemBehavior()
    
    private var views: [UIView] = []
    
    /// - Parameter view: the view to be removed with animation
    func add(_ view: UIView) {
        views.append(view)
        self.addSubview(view)
    }
    
    /// start the animation
    func start() {
        let bottomLeft = CGPoint(x: 0, y: self.frame.height)
        let bottomRight = CGPoint(x: self.frame.width, y: self.frame.height)
        collider.addBoundary(withIdentifier: "bottomLine" as NSCopying, from: bottomLeft, to: bottomRight)
        // this two should be in Setting
        gravity.magnitude = Setting.dropViewGravityMagnitude
        itemBehavior.elasticity = Setting.dropViewElasticity
        for view in views {
            gravity.addItem(view)
            collider.addItem(view)
            itemBehavior.addItem(view)
            animator.addBehavior(gravity)
            animator.addBehavior(collider)
            animator.addBehavior(itemBehavior)
        }
        
        // fade the dropped bubble out, after that, 
        // remove this dropView from its super view
        UIView.animate(withDuration: Setting.dropViewFadeOutDuration, animations: ({
            for view in self.views {
                view.alpha = 0
            }
        }), completion: ({ _ in
            self.removeFromSuperview()
        }))
    }
}
