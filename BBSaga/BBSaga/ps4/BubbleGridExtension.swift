//
//  BubbleGridExtension.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

extension BubbleGrid {
    
    /// After the launched bubble has found a resting position,
    /// if it is connected to other identically-coloured bubbles and they form a group of 3 or more,
    /// that connected group of bubbles is removed from the arena.
    /// - Parameter indexPath: the index path of the cell which the bubble projectile rest at
    /// - Returns: an array of index paths of the connected same-colored grid bubbles
    func connectedIndexPathsOfSameColor(from indexPath: IndexPath) -> [IndexPath] {
        guard let thisBubble = getBubbleAt(row: indexPath.section, col: indexPath.row) else {
            return []
        }
        var boolGrid = createBoolGridForMarking()
        
        /// helper function
        func markRecursively(_ indexPath: IndexPath) {
            if boolGrid[indexPath.section][indexPath.row] == false {
                boolGrid[indexPath.section][indexPath.row] = true
                for indexPath in adjacentUnemptyIndexPaths(to: indexPath) {
                    if getBubbleAt(row: indexPath.section, col: indexPath.row) == thisBubble {
                        markRecursively(indexPath)
                    }
                }
            }
        }
        
        markRecursively(indexPath)
        
        var returnedArray: [IndexPath] = []
        for row in 0 ..< boolGrid.count {
            for col in 0 ..< boolGrid[row].count {
                if boolGrid[row][col] {
                    returnedArray.append(IndexPath(row: col, section: row))
                }
            }
        }
        return returnedArray
    }
    
    /// After identically-coloured bubbles are removed, 
    /// if there are bubbles that are not connected to the bubbles on the top wall, 
    /// they should be removed too.
    /// - Returns: an array of index paths of the grid bubbles unattached to the ceiling
    func unattachedIndexPaths() -> [IndexPath] {
        var boolGrid = createBoolGridForMarking()
        
        /// helper function
        func markRecursively(_ indexPath: IndexPath) {
            if boolGrid[indexPath.section][indexPath.row] == false {
                boolGrid[indexPath.section][indexPath.row] = true
                for indexPath in adjacentUnemptyIndexPaths(to: indexPath) {
                    markRecursively(indexPath)
                }
            }
        }
        
        for col in 0 ..< getNumCellsAt(row: 0) {
            if !isCellEmptyAt(row: 0, col: col) {
                markRecursively(IndexPath(row: col, section: 0))
            }
        }
        
        var returnedArray: [IndexPath] = []
        for row in 0 ..< boolGrid.count {
            for col in 0 ..< boolGrid[row].count {
                if !boolGrid[row][col] && !isCellEmptyAt(row: row, col: col) {
                    returnedArray.append(IndexPath(row: col, section: row))
                }
            }
        }
        return returnedArray
    }
    
    /// return the index paths of adjacent, non-empty cells of the input index path
    /// - Parameter indexPath: the input indexPath
    /// - Returns: all the index paths of adjacent, non-empty cells
    func adjacentUnemptyIndexPaths(to indexPath: IndexPath) -> [IndexPath] {
        var connectedUnEmptyIndexPaths: [IndexPath] = []
        let maxRows = getNumRows() - 1
        let maxColsInOddRow = getNumCellsAt(row: 0) - 1
        let maxColsInEvenRow = maxColsInOddRow - 1
        
        let row = indexPath.section
        let col = indexPath.row
        
        /// helper function
        func appendIfValid(row: Int, col: Int) {
            if row % 2 == 0 {  // odd row
                if row >= 0 && row <= maxRows &&
                    col >= 0 && col <= maxColsInOddRow &&
                    !isCellEmptyAt(row: row, col: col) {
                    connectedUnEmptyIndexPaths.append(IndexPath(row: col, section: row))
                }
            } else {
                if row >= 0 && row <= maxRows &&
                    col >= 0 && col <= maxColsInEvenRow &&
                    !isCellEmptyAt(row: row, col: col) {
                    connectedUnEmptyIndexPaths.append(IndexPath(row: col, section: row))
                }
            }
        }
        
        if row % 2 == 0 {  // odd row
            appendIfValid(row: row, col: col + 1)  // right
            appendIfValid(row: row + 1, col: col)  // bottom right
            appendIfValid(row: row + 1, col: col - 1)  // bottom left
            appendIfValid(row: row, col: col - 1)  // left
            appendIfValid(row: row - 1, col: col)  // top right
            appendIfValid(row: row - 1, col: col - 1)  // top left
        } else {  // even row
            appendIfValid(row: row, col: col + 1)  // right
            appendIfValid(row: row + 1, col: col + 1)  // bottom right
            appendIfValid(row: row + 1, col: col)  // bottom left
            appendIfValid(row: row, col: col - 1)  // left
            appendIfValid(row: row - 1, col: col + 1)  // top right
            appendIfValid(row: row - 1, col: col)  // top left
        }
        return connectedUnEmptyIndexPaths
    }
    
    /// - Returns: a 2d-array of boolean elements, which is of the same size as bubble grid
    private func createBoolGridForMarking() -> [[Bool]] {
        var boolGrid: [[Bool]] = []
        for i in 0 ..< getNumRows() {
            var row = Array<Bool>()
            for _ in 1 ... self.getNumCellsAt(row: i) {
                row.append(false)
            }
            boolGrid.append(row)
        }
        return boolGrid
    }
    
    func indexPathsRemovedByLightningBubble(at indexPath: IndexPath) -> [IndexPath] {
        var returnedIndexPaths: [IndexPath] = []
        for col in 0 ..< getNumCellsAt(row: indexPath.section) {
            if !isCellEmptyAt(row: indexPath.section, col: col) {
                returnedIndexPaths.append(IndexPath(row: col, section: indexPath.section))
            }
        }
        return returnedIndexPaths
    }
    
    func indexPathsOfSameColor(as indexPath: IndexPath) -> [IndexPath] {
        guard let thisBubble = getBubbleAt(row: indexPath.section, col: indexPath.row) else {
            return []
        }
        var returnedIndexPaths: [IndexPath] = []
        for row in 0 ..< getNumRows() {
            for col in 0 ..< getNumCellsAt(row: row) {
                if getBubbleAt(row: row, col: col) == thisBubble {
                    returnedIndexPaths.append(IndexPath(row: col, section: row))
                }
            }
        }
        return returnedIndexPaths
    }
}










