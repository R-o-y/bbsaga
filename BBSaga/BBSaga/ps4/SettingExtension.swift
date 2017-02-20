//
//  SettingExtension.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

extension Setting {
    static let bubbleProjectileSpeed: CGFloat = 1200
    static let framePerSecond = 60
    static let minimumShootingVerticalComponent: CGFloat = -18
    
    // Animation
    static let dropViewGravityMagnitude: CGFloat = 1.2
    static let dropViewElasticity: CGFloat = 0.66
    static let dropViewFadeOutDuration = 2.8
    
    static let bubbleBurstAnimationImageName = "bubble-burst"
    static let bubbleBurstAnimationRowNum = 1
    static let bubbleBurstAnimationColNum = 4
    static let bubbleBurstAnimationRepeatCount = 1
    static let bubbleBurstAnimationFinalScale: CGFloat = 1.2
    static let bubbleBurstAnimationDuration = 0.12
}
