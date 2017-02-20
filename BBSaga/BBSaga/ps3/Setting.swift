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
    
    static let storagePanelHeightInPercentage: CGFloat = 0.38  // relative to the main view
    static let storagePanelWidthInPercentage: CGFloat = 0.48  // relative to the main view
    
    static let storagePanelHeaderAlpha = 0.38
    static let storagePanelHeaderHeightInPercentage: CGFloat = 0.12  // relative to the storage panel
    static let headerTextWidthInPercentage: CGFloat = 0.66  // relative to the storage panel header
    
    static let noContentMessage = "there is no content to be loaded from this file"
    static let confirmSaveQuestion = "save into the following file?\n\n"
    static let confirmLoadQuestion = "load from the folloing file?\n\n"
    static let confirmRemoveQuestion = "remove the following file?\n\n"
    static let inputNamePlaceholder = "name, repetition NOT allowed"
    static let loadOverwrittenWarning = "\n\nthe current grid will be overwritten"
    
    static let backGroundImageName = "background"
}

/// bubble grid selection scene
extension Setting {
    static let numGridsPerRow = 2
    
    static let bubbleGridCellIdentifier = "BubbleGridCell"
    static let storagePanelCellIdentifier = "StoragePanelCell"
    static let designGridCellIdentifier = "DesignGridCell"
    
    static let segueToDesignerIdentifier = "segueToDesigner"
    static let segueToDesignerNotificationName = "segueToDesigner"
    
    static let editButtonImageName = "edit-button"
    
    static let gridCollectionItemSizeRatio: CGFloat = 0.28
    static let gridCollectionVerticalMarginRatio: CGFloat = 0.038
    static let gridCollectionHorizontalMarginRatio: CGFloat = 0.12
    
    // grid cell
    static let gridThumbnailFooterHeightRatio: CGFloat = 0.1
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
    static func imageName(ofBubble bubble: Bubble) -> String {
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
}

/// animation
extension Setting {
    static let sinkAndFloatDefaultDuration = 0.38
    static let sinkAndFloatDefaultRange: CGFloat = 28
    
    static let leftSlideInDefaultDuration = 0.38
}



























