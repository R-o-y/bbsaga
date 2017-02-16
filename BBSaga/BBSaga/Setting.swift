//
//  Setting.swift
//  BBSaga
//
//  Created by 罗宇阳 on 15/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

struct Setting {
    static let numRows: Int = 12
    static let numCellsPerOddRow = 12
    static let cellBorderWidth: CGFloat = 0.8
    
    static let storagePanelHeightInPercentage: CGFloat = 0.38  // relative to the main view
    static let storagePanelWidthInPercentage: CGFloat = 0.48  // relative to the main view
    
    static let storagePanelHeaderAlpha = 0.38
    static let storagePanelHeaderHeightInPercentage: CGFloat = 0.12  // relative to the storage panel
    static let headerTextWidthInPercentage: CGFloat = 0.66  // relative to the storage panel header
    
    static let statusBarHeight: Double = 20
    
    static let noContentMessage = "there is no content to be loaded from this file"
    static let confirmSaveQuestion = "save into the following file?\n\n"
    static let confirmLoadQuestion = "load from the folloing file?\n\n"
    static let confirmRemoveQuestion = "remove the following file?\n\n"
    static let inputNamePlaceholder = "name, repetition NOT allowed"
    static let loadOverwrittenWarning = "\n\nthe current grid will be overwritten"
    
    // game engine
    static let bubbleProjectileSpeed: CGFloat = 1200
    static let framePerSecond = 60
    static let minimumShootingVerticalComponent: CGFloat = -18
    
    static let dropViewGravityMagnitude: CGFloat = 1.2
    static let dropViewElasticity: CGFloat = 0.66
    static let dropViewFadeOutDuration = 2.8
}
