//
//  GamePlayControllerRemoveBubblesExtension.swift
//  BBSaga
//
//  Created by luoyuyang on 26/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit
import PhysicsEngine

extension GamePlayController {
    
    /// find the closest empty cell and settle there
    /// then check whether there are 3 or more connected bubbles to be removed
    func settleBubbleProjectileAndCheck(_ bubbleProjectile: RigidBody) {
        if leftProjectileCount < 0  {
            endGame()
        }
        guard let bubbleProjectile = bubbleProjectile as? BubbleProjectile else {
            return
        }
        gameEngine.removeRigidBody(bubbleProjectile)
        
        for position in positionsToConsiderWhenPrepareSettling(around: bubbleProjectile.position) {
            guard let indexPath = bubbleGridView.indexPathForItem(at: position.toCGPoint()) else {
                return
            }
            
            if bubbleGridController.currentBubbleGrid.isCellEmptyAt(row: indexPath.section,
                                                                    col: indexPath.row) {
                // settle into bubbleGrid
                bubbleGridController.currentBubbleGrid.setBubbleAt(row: indexPath.section,
                                                                   col: indexPath.row,
                                                                   to: bubbleProjectile.getBubble())
                bubbleGridView.reloadItems(at: [indexPath])
                if let point = getCell(at: indexPath)?.center {
                    let position = CGVector(point)
                    positionsOfGridBubbles.append(position)
                }
                
                // remove grid bubbles according to the rules
                removeAfterShootTo(indexPath)
                break
            }
        }
    }
    
    /// helper function that returns the current position
    /// and its 6 "neighbor" positions (vertices of the inscribed hexagon of the buble)
    private func positionsToConsiderWhenPrepareSettling(around position: CGVector) -> [CGVector] {
        return [
            position,
            position + CGVector(dx: bubbleRadius, dy: 0),
            position + CGVector(dx: bubbleRadius / 2, dy: sqrt(3) / 2 * bubbleRadius),
            position + CGVector(dx: -bubbleRadius / 2, dy: sqrt(3) / 2 * bubbleRadius),
            position + CGVector(dx: -bubbleRadius, dy: 0),
            position + CGVector(dx: -bubbleRadius / 2, dy: -sqrt(3) / 2 * bubbleRadius),
            position + CGVector(dx: bubbleRadius / 2, dy: -sqrt(3) / 2 * bubbleRadius)
        ]
    }
    
    /// after the bubble projectile settle at the specified indexPath
    /// remove more than 3 connected same-colored bubbles and
    /// then remove unattached bubbles
    /// - Parameter indexPath: the indexPath where the bubble projectile settle
    private func removeAfterShootTo(_ indexPath: IndexPath) {
        scoreThisShot = 0
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        
        // remove more than 3 connected same-colored bubbles
        let connectedIndexPathsOfSameColor = bubbleGrid.connectedIndexPathsOfSameColor(from: indexPath)
        if connectedIndexPathsOfSameColor.count >= 3 {
            audioPlayer.playSameColorSoundEffect()
            scoreThisShot += connectedIndexPathsOfSameColor.count * Setting.scorePerBubble
            removeFromPositionsOfGridBubbles(indexPaths: connectedIndexPathsOfSameColor)
            bubbleGridController.removeConnectedSameColorBubblesWithAnimation(connectedIndexPathsOfSameColor)
        }
        
        // trigger star bubble
        for starBubbleIndexPath in getPowerBubbleIndexPaths(around: indexPath, ofPower: .star) {
            audioPlayer.playSameColorSoundEffect()
            triggerStarBubbleAt(starBubbleIndexPath, by: indexPath)
        }
        
        // trigger lightning bubble
        for indexPath in getPowerBubbleIndexPaths(around: indexPath, ofPower: .lightning) {
            audioPlayer.playLightningSoundEffect()
            triggerLightningBubbleAt(indexPath)
        }
        
        // trigger bomb bubble
        for indexPath in getPowerBubbleIndexPaths(around: indexPath, ofPower: .bomb) {
            audioPlayer.playBombSoundEffect()
            triggerBombBubbleAt(indexPath)
        }
        
        // remove unattached bubbles
        let unattachedIndexPaths = bubbleGrid.unattachedIndexPaths()
        scoreThisShot += unattachedIndexPaths.count * Setting.scorePerBubble
        removeFromPositionsOfGridBubbles(indexPaths: unattachedIndexPaths)
        bubbleGridController.removeUnattachedBubblesWithAnimation(unattachedIndexPaths)
        
        accumulateScore()
    }
    
    private func accumulateScore() {
        guard let currentNumString = scoreLabel.text else {
            return
        }
        guard let currentNum = Int(currentNumString) else {
            return
        }
        let finalScore = currentNum + scoreThisShot
        for i in stride(from: currentNum, through: finalScore, by: Setting.scorePerBubble) {
            delay(Double(i - currentNum) / Double(Setting.scorePerBubble) * Setting.scoreIncreasingAnimationStepDelay) { [weak self] _ in
                self?.scoreLabel.text = String(i)
            }
        }
    }
    
    /// return the index paths of the power bubble adjacent to the input index path
    private func getPowerBubbleIndexPaths(around indexPath: IndexPath, ofPower power: BubblePower) -> [IndexPath] {
        var returnedIndexPaths: [IndexPath] = []
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        for indexPath in bubbleGrid.adjacentUnemptyIndexPaths(to: indexPath) {
            let row = indexPath.section
            let col = indexPath.row
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: power) {
                returnedIndexPaths.append(indexPath)
            }
        }
        return returnedIndexPaths
    }
    
    /// helper function to trigger lightning bubble at the input index path
    private func triggerLightningBubbleAt(_ indexPath: IndexPath) {
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        let indexPathsRemovedByLightningBubble = bubbleGrid.indexPathsRemovedByLightningBubble(at: indexPath)
        scoreThisShot += indexPathsRemovedByLightningBubble.count * Setting.scorePerBubble
        
        // get the index paths of chaining power bubbles
        var chainingLightningIndexPaths: [IndexPath] = []
        var chainingBombIndexPaths: [IndexPath] = []
        for indexPath in indexPathsRemovedByLightningBubble {
            let row = indexPath.section
            let col = indexPath.row
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .lightning) {
                chainingLightningIndexPaths.append(indexPath)
            }
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .bomb) {
                chainingBombIndexPaths.append(indexPath)
            }
        }
        
        // trigger current power bubbles
        removeFromPositionsOfGridBubbles(indexPaths: indexPathsRemovedByLightningBubble)
        bubbleGridController.removeLightningDestroyedBubblesWithAnimation(indexPathsRemovedByLightningBubble)
        
        // trigger chaining power bubbles
        for indexPath in chainingBombIndexPaths {
            triggerBombBubbleAt(indexPath)
        }
        for indexPath in chainingLightningIndexPaths {
            triggerLightningBubbleAt(indexPath)
        }
    }
    
    /// helper function to trigger bomb bubble at the input index path
    private func triggerBombBubbleAt(_ indexPath: IndexPath) {
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        var indexPathsRemovedByBombBubble = bubbleGrid.adjacentUnemptyIndexPaths(to: indexPath)
        indexPathsRemovedByBombBubble.append(indexPath)
        scoreThisShot += indexPathsRemovedByBombBubble.count * Setting.scorePerBubble
        
        // get the index paths of chaining power bubbles
        var chainingLightningIndexPaths: [IndexPath] = []
        var chainingBombIndexPaths: [IndexPath] = []
        for indexPath in indexPathsRemovedByBombBubble {
            let row = indexPath.section
            let col = indexPath.row
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .lightning) {
                chainingLightningIndexPaths.append(indexPath)
            }
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .bomb) {
                chainingBombIndexPaths.append(indexPath)
            }
        }
        
        // trigger current power bubbles
        removeFromPositionsOfGridBubbles(indexPaths: indexPathsRemovedByBombBubble)
        bubbleGridController.removeBombDestroyedBubblesWithAnimation(indexPathsRemovedByBombBubble)
        
        // trigger chaining power bubbles
        for indexPath in chainingLightningIndexPaths {
            triggerLightningBubbleAt(indexPath)
        }
        for indexPath in chainingBombIndexPaths {
            triggerBombBubbleAt(indexPath)
        }
    }
    
    /// helper function to trigger bomb bubble at the input index path
    private func triggerStarBubbleAt(_ starBubbleIndexPath: IndexPath, by projectileIndexPath: IndexPath) {
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        var indexPathsRemovedByStarBubble = bubbleGrid.indexPathsOfSameColor(as: projectileIndexPath)
        indexPathsRemovedByStarBubble.append(starBubbleIndexPath)
        scoreThisShot += indexPathsRemovedByStarBubble.count * Setting.scorePerBubble
        removeFromPositionsOfGridBubbles(indexPaths: indexPathsRemovedByStarBubble)
        bubbleGridController.removeStarDestroyedBubblesWithAnimation(indexPathsRemovedByStarBubble)
    }
    
    /// helper function to remove center of grid bubbles from positionsOfGridBubbles
    /// - Parameter indexPaths: the index paths of the grid bubbles removed
    private func removeFromPositionsOfGridBubbles(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let position = getCell(at: indexPath)?.center {
                positionsOfGridBubbles.removeEqualItems(item: CGVector(position))
            }
        }
    }
    
    /// helper function to get the cell at the specified indexPath
    func getCell(at indexPath: IndexPath) -> BubbleGridCell? {
        if let cell = bubbleGridView?.dequeueReusableCell(
            withReuseIdentifier: Setting.bubbleGridCellIdentifier,for: indexPath) as? BubbleGridCell {
            return cell
        }
        return nil
    }
    
}







