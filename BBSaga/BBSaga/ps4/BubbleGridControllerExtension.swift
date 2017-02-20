//
//  BubbleGridForPlayController.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class BubbleGridForPlayController: BubbleGridController {
    private var numRows = Setting.numRows
    private var numCellsPerOddRow = Setting.numCellsPerOddRow
    
    func setUpEmptyBubbleGrid() {
        guard let bubbleGrid = self.collectionView else {
            return
        }
        
        bubbleGrid.backgroundColor = UIColor.clear
        
        setUpEmptyBubbleGridModel()
    }
    
    /// helper function to set up empty bubble grid model
    private func setUpEmptyBubbleGridModel() {
        var numCells = 0
        for i in 1 ... numRows {
            if i % 2 == 1 {  // odd row
                numCells = numCellsPerOddRow
            } else {  // even row
                numCells = numCellsPerOddRow - 1
            }
            var newRowOfCells = Array<Bubble?>()
            for _ in 1 ... numCells {
                newRowOfCells.append(nil)
            }
            currentBubbleGrid.appendArrayOfBubbles(newRowOfCells)
        }
    }
    
    /// remove the bubbles at the specified indexPaths with animation
    /// - Parameter indexPaths: the array of the index path of the grid bubbles to be removed
    func removeConnectedSameColorBubblesWithAnimation(_ indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let bubbleGrid = self.collectionView {
                let cell =  bubbleGrid.dequeueReusableCell(withReuseIdentifier: "BubbleGridCell",
                                                           for: indexPath)
                Animation.animateBubbleBurst(within: cell.frame, in: bubbleGrid,
                                             withDuration: Setting.bubbleBurstAnimationDuration)
            }
        }
        for indexPath in indexPaths {
            currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
        }
        if let bubbleGrid = self.collectionView {
            UIView.performWithoutAnimation {
                bubbleGrid.reloadItems(at: indexPaths)
            }
        }
    }
    
    /// remove the bubbles at the specified indexPaths with animation
    /// - Parameter indexPaths: the array of the index path of the grid bubbles to be removed
    func removeUnattachedBubblesWithAnimation(_ indexPaths: [IndexPath]) {
        // animate
        let dropView = DropView()
        for indexPath in indexPaths {
            if let bubbleGrid = self.collectionView {
                dropView.frame = bubbleGrid.frame
                if let bubble = currentBubbleGrid.getBubbleAt(row: indexPath.section, col: indexPath.row) {
                    let frame = bubbleGrid.dequeueReusableCell(withReuseIdentifier: "BubbleGridCell",
                                                               for: indexPath).frame
                    let view = UIImageView(frame: frame)
                    view.image = UIImage(named: Setting.imageName(ofBubble: bubble))
                    dropView.add(view)
                }
            }
        }
        self.collectionView!.addSubview(dropView)
        dropView.start()
        
        // remove from bubbleGrid collection view
        for indexPath in indexPaths {
            currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
        }
        if let bubbleGrid = self.collectionView {
            bubbleGrid.reloadItems(at: indexPaths)
        }
    }
    
    func removeLightningDestroyedBubblesWithAnimation(_ indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
        }
        if let bubbleGrid = self.collectionView {
            bubbleGrid.reloadItems(at: indexPaths)
        }
    }
    
    func removeBombDestroyedBubblesWithAnimation(_ indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
        }
        if let bubbleGrid = self.collectionView {
            bubbleGrid.reloadItems(at: indexPaths)
        }
    }
    
    func removeStarDestroyedBubblesWithAnimation(_ indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
        }
        if let bubbleGrid = self.collectionView {
            bubbleGrid.reloadItems(at: indexPaths)
        }
    }
}


