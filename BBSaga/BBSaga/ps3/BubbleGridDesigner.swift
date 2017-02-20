//
//  BubbleGrid.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 25/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

enum DesignMode {
    case erasing
    case filling(Bubble)
    case cycling
}

class BubbleGridDesigner {

    private var mode: DesignMode = DesignMode.erasing
    
    init() {}
    
    func setDesignMode(to mode: DesignMode) {
        self.mode = mode
    }
    
    func getCurrentDesignMode() -> DesignMode {
        return mode
    }
}
