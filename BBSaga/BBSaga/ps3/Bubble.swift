//
//  Bubble.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 27/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

/**
 
 This class is the basic bubble class
 It is an abstract class though, that is, you cannot instantiate like Bubble()
 instead, you must use subclass to instantiate like ColorBubble(ofColor:) or PowerBubble(ofPower:)
 
 Why I use an abstract class (which is not supported in Swift) rather than protocol
 Firstly, Bubble should inherits from NSObject to be able to use NSKeyedArchive to store it,
 which requires Bubble to be a class
 
 Besides I wish Bubble to be Equatabe, however, in Swift:
 such protocol can only be homogeneous
 while in bubble grid, I need to store both ColorBubble and PowerBubble in the same array
 
 */

class Bubble: NSObject, NSCoding {
    override init() {}
    
    /// conform to NSCoding to enable storing into plist
    required init(coder decoder: NSCoder) {
        fatalError("this method should be overriden by subclasses")
    }
    
    /// conform to NSCoding to enable storing into plist
    func encode(with coder: NSCoder) {
        fatalError("this method should be overriden by subclasses")
    }
    
    /// calling this method enable passing Bubble object by value rather than reference
    /// this method should be overriden by the subclasses
    func replica() -> Bubble {
        fatalError("this method should be overriden by subclasses")
    }
    
    static func ==(lhs: Bubble, rhs: Bubble) -> Bool {
        if let rhs = rhs as? ColorBubble, let lhs = lhs as? ColorBubble {
            return lhs.getColor() == rhs.getColor()
        }
        if let rhs = rhs as? PowerBubble, let lhs = lhs as? PowerBubble {
            return lhs.getPower() == rhs.getPower()
        }
        return false
    }
    
    static func ==(lhs: Bubble, rhs: Bubble?) -> Bool {
        guard let rhs = rhs else {  // unwrap first
            return false
        }
        return lhs == rhs
    }
    
    static func ==(lhs: Bubble?, rhs: Bubble) -> Bool {
        guard let lhs = lhs else {  // unwrap first
            return false
        }
        return lhs == rhs
    }
}




