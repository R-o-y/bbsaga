//
//  setting.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

struct Setting {
    static let statusBarHeight: Double = 20
    static let backGroundImageName = "background"
}

/// storage panel
extension Setting {
    static let storagePanelYPercentage: CGFloat = 0.08
    static let storagePanelHeightInPercentage: CGFloat = 0.66  // relative to the main view
    static let storagePanelWidthInPercentage: CGFloat = 0.66  // relative to the main view
    static let storagePanelAlpha: CGFloat = 0.66
    
    static let storagePanelHeaderAlpha = 0.38
    static let storagePanelHeaderHeightInPercentage: CGFloat = 0.06  // relative to the storage panel
    
    static let bubbleGridStorageKey = "bubbleGrid"
    
    static let noContentMessage = "there is no content to be loaded from this file"
    static let confirmSaveQuestion = "save into the following file?\n\n"
    static let confirmLoadQuestion = "load from the folloing file?\n\n"
    static let confirmRemoveQuestion = "remove the following file?\n\n"
    static let inputNamePlaceholder = "name, repetition NOT allowed"
    static let loadOverwrittenWarning = "\n\nthe current grid will be overwritten"
    
    static let removeGridNotificationName = "removeGrid"
    
    static let containerWidthInPercentage: CGFloat = 0.6  // relative to contentView
    static let containerHeightInPercentage: CGFloat = 1  // relative to contentView
    static let containerUpperPaddingInPercentage: CGFloat = 0.1
    static let storagePanelRowHeightRatio: CGFloat = 0.8
}

/// bubble grid selection scene
extension Setting {
    static let numGridsPerRow = 2
    
    static let bubbleGridCellIdentifier = "BubbleGridCell"
    static let storagePanelCellIdentifier = "StoragePanelCell"
    static let playGridCellIdentifier = "PlayGridCell"
    
    static let removeButtonImageName = "remove-button"
    
    static let gridCollectionItemSizeRatio: CGFloat = 0.28
    static let gridCollectionVerticalMarginRatio: CGFloat = 0.038
    static let gridCollectionHorizontalMarginRatio: CGFloat = 0.12
    
    // grid cell
    static let gridThumbnailFooterHeightRatio: CGFloat = 0.1
    
    static let segueToPlayerIdentifier = "segueToPlayer"
    static let segueToPlayerNotificationName = "segueToPlayer"
}

/// bubble grid view
extension Setting {
    static let numRows: Int = 12
    static let numCellsPerOddRow = 12
    static let cellBorderWidth: CGFloat = 0.8
    static let emptyCellAlpha: CGFloat = 0.08
    static let numBubbleColor = 4
    static let numBubblePower = 4
}

extension Setting {
    /// helper function that maps a bubble to the name of the image that represents it
    /// - Parameter bubble: the bubble to be displayed
    /// - Returns: the name of the imsage that represents it
    static private func imageName(ofBubble bubble: Bubble) -> String {
        if let bubble = bubble as? ColorBubble {
            switch bubble.getColor() {
            case .blue:
                return "bubble-blue"
            case .green:
                return "bubble-green"
            case .orange:
                return "bubble-orange"
            case .red:
                return "bubble-red"
            }
        } else if let bubble = bubble as? PowerBubble {
            switch bubble.getPower() {
            case .lightning:
                return "bubble-lightning"
            case .bomb:
                return "bubble-bomb"
            case .star:
                return "bubble-star"
            case .indestructible:
                return "bubble-indestructible"
            }
        }
        fatalError("imageName(ofBubble:) does not exhaust all types of bubble")
    }
    
    static func imageOfBubble(_ bubble: Bubble) -> UIImage? {
        return UIImage(named: imageName(ofBubble: bubble))
    }
}

/// animation
extension Setting {
    static let sinkAndFloatDefaultDuration = 0.38
    static let sinkAndFloatDefaultRange: CGFloat = 28
    
    static let leftSlideInDefaultDuration = 0.38

    static let dropViewGravityMagnitude: CGFloat = 1.2
    static let dropViewElasticity: CGFloat = 0.66
    static let dropViewFadeOutDuration = 2.8
    
    // bubble burst animation
    static let bubbleBurstAnimationImageName = "bubble-burst"
    static let bubbleBurstAnimationRowNum = 1
    static let bubbleBurstAnimationColNum = 4
    static let bubbleBurstAnimationRepeatCount = 1
    static let bubbleBurstAnimationFinalScale: CGFloat = 1.2
    static let bubbleBurstAnimationDuration = 0.12
    
    static let chainingDelay: TimeInterval = 0.08
    
    // lightning animation
    static let lightningDelay: TimeInterval = 0.028
    static let lightningSectionDuration: TimeInterval = Setting.lightningDelay * TimeInterval(16)
    static let lightningSectionWidth: CGFloat = 180
    static let lightningSpriteSheetName = "bolt_strike"
    static let lightningSpriteSheetRowNum = 1
    static let lightningSpriteSheetColNum = 10
    static let lightningNextStartingTimeRate: TimeInterval = 0.138
    static let lightningNextStartingPositionRate: CGFloat = 0.8
    static let lightningVerticalHalfRate: CGFloat = 1 / 2.18
    
    // fire hit animation
    static let firehitDuration = 0.66
    static let firehitSpriteSheetName = "fireball_hit"
    static let firehitSpriteSheetRowNum = 1
    static let firehitSpriteSheetColNum = 9
    static let firehitSizeRateCompareToBubble = 3.18
    
    // lightning obstacles animation
    static let lightningObstacleWidth: CGFloat = 108
    static let lightningObstacleAnimationDuration: TimeInterval = 1.28
    static let lightningObstacleSpriteSheetName = "bolt_tesla"
    static let lightningObstacleSpriteSheetRowNum = 1
    static let lightningObstacleSpriteSheetColNum = 10
    static let lightningObstacleDelay: TimeInterval = 0.18
    static let lightningObstacleWidthRate: CGFloat = 0.88
}

/// game play
extension Setting {
    static let playBackgroundImage = UIImage(named: "background")
    static let bubbleProjectileSpeed: CGFloat = 1200
    static let framePerSecond = 60
    static let minimumShootingVerticalComponent: CGFloat = -18
    
    static let numProjectiles = 60
    
    static let pathNodeImage = UIImage(named: "shuriken")
    static let pathNodeSize = CGSize(width: 18, height: 18)
    static let aimingBeamStepLength = 60
    static let aimingBeamStepNum = 13
}

























