//
//  ColorBubble.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 16/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

enum BubbleColor: Int {
    case blue
    case green
    case orange
    case red
}

class ColorBubble: Bubble {
    private var bubbleColor: BubbleColor
    
    init(ofColor bubbleColor: BubbleColor) {
        self.bubbleColor = bubbleColor
        super.init()
    }
    
    override init() {
        bubbleColor = .blue  // default
        super.init()
    }
    
    /// conform to NSCoding to enable storing into plist
    required convenience init(coder decoder: NSCoder) {
        self.init()
        let rawValue = decoder.decodeInteger(forKey: "bubbleColor")
        bubbleColor = BubbleColor(rawValue: rawValue)!
    }
    
    /// conform to NSCoding to enable storing into plist
    override func encode(with coder: NSCoder) {
        coder.encode(self.bubbleColor.rawValue, forKey: "bubbleColor")
    }
    
    func setColor(_ bubbleColor: BubbleColor) {
        self.bubbleColor = bubbleColor
    }
    
    func getColor() -> BubbleColor {
        return self.bubbleColor
    }
    
    /// calling this method enable passing Bubble object by value rather than reference
    /// this method should be overriden by the subclasses
    /// if they have more properties than bubbleColor
    override func replica() -> Bubble {
        let equalBubble = ColorBubble(ofColor: bubbleColor)
        return equalBubble
    }
}









