//
//  BubbleGrid.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 29/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

class BubbleGrid: NSObject, NSCoding {
    /// nil entry means no bubble in that cell
    private var bubble2dArray = Array<Array<Bubble?>>()
    private var numRows = Setting.numRows
    private var numCellsPerOddRow = Setting.numCellsPerOddRow

    /// conform to NSCoding to enable storing into plist
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.bubble2dArray = decoder.decodeObject(forKey: "bubble2dArray") as! Array<Array<Bubble?>>
    }
    func encode(with coder: NSCoder) {
        coder.encode(bubble2dArray, forKey: "bubble2dArray")
    }
    
    /// set up a bubble grid with all cells empty
    func setUpEmptyBubbleGrid() {
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
            bubble2dArray.append(newRowOfCells)
        }
    }
    
    func setBubbleAt(row: Int, col: Int, to bubble: Bubble?) {
        guard row < bubble2dArray.count && col < bubble2dArray[row].count else {
            return
        }
        bubble2dArray[row][col] = bubble?.replica()
    }
    
    func appendBubble(_ newBubble: Bubble?, to row: Int) {
        guard row < bubble2dArray.count else {
            return
        }
        bubble2dArray[row].append(newBubble?.replica())
    }
    
    func emptyCellAt(row: Int, col: Int) {
        setBubbleAt(row: row, col: col, to: nil)
    }
    
    func appendArrayOfBubbles(_ bubbles: [Bubble?]) {
        let duplicate = bubbles.map({ $0?.replica() })
        bubble2dArray.append(duplicate)
    }
    
    func getBubbleAt(row: Int, col: Int) -> Bubble? {
        guard row < bubble2dArray.count && col < bubble2dArray[row].count else {
            assert(false, "row or col out of bound when calling getBubbleAt")
        }
        return bubble2dArray[row][col]
    }
    
    func getNumRows() -> Int {
        return bubble2dArray.count
    }
    
    func getNumCellsAt(row: Int) -> Int {
        guard row < bubble2dArray.count else {
            assert(false, "row out of bound when calling getNumCellsAt")
        }
        return bubble2dArray[row].count
    }
    
    func isCellEmptyAt(row: Int, col: Int) -> Bool {
        guard row < bubble2dArray.count && col < bubble2dArray[row].count else {
            assert(false, "row or col out of bound when calling isCellEmptyAt")
        }
        return bubble2dArray[row][col] == nil
    }
    
    func cleanAllCells() {
        for row in 0 ..< bubble2dArray.count {
            for col in 0 ..< bubble2dArray[row].count {
                bubble2dArray[row][col] = nil
            }
        }
    }
}



