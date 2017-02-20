//
//  PowerBubble.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 16/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

enum BubblePower: Int {
    case lightning
    case star
    case bomb
    case indestructible
}

class PowerBubble: Bubble {
    private var bubblePower: BubblePower
    
    init(ofPower bubblePower: BubblePower) {
        self.bubblePower = bubblePower
        super.init()
    }
    
    override init() {
        bubblePower = .indestructible  // default
        super.init()
    }
    
    /// conform to NSCoding to enable storing into plist
    required convenience init(coder decoder: NSCoder) {
        self.init()
        let rawValue = decoder.decodeInteger(forKey: "bubblePower")
        bubblePower = BubblePower(rawValue: rawValue)!
    }
    
    /// conform to NSCoding to enable storing into plist
    override func encode(with coder: NSCoder) {
        coder.encode(self.bubblePower.rawValue, forKey: "bubblePower")
    }
    
    func setPower(_ bubblePower: BubblePower) {
        self.bubblePower = bubblePower
    }
    
    func getPower() -> BubblePower {
        return bubblePower
    }
    
    /// calling this method enable passing Bubble object by value rather than reference
    /// this method should be overriden by the subclasses
    /// if they have more properties than bubblePower
    override func replica() -> Bubble {
        let equalBubble = PowerBubble(ofPower: self.bubblePower)
        return equalBubble
    }
}
