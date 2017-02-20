//
//  BubbleGridCellFlowLayout.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 29/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class BubbleGridCellFlowLayout: UICollectionViewFlowLayout {
    var numRows: Int {
        if let collectionView = collectionView {
            return collectionView.numberOfSections
        }
        return Setting.numRows
    }
    
    var numCellsPerOddRow: Int {
        if let collectionView = collectionView {
            return collectionView.numberOfItems(inSection: 0)  // first row is an odd row
        }
        return Setting.numCellsPerOddRow
    }
    
    var cellDiameter: Double {
        if let bubbleGridView = collectionView {
            return Double(bubbleGridView.frame.width) / Double(numCellsPerOddRow)
        }
        return 66  // default
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < numRows else {
            return nil
        }
        guard indexPath.section % 2 == 0 ?
              indexPath.row < numCellsPerOddRow :
              indexPath.row < numCellsPerOddRow - 1 else {
            return nil
        }
        
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // setting the display style of the cell
        layoutAttribute.frame.size = CGSize(width: cellDiameter, height: cellDiameter)

        // setting the display position of the cell
        let row = Double(indexPath.section)
        let col = Double(indexPath.row)
        let minY: Double = row * cellDiameter / 2 * sqrt(3) + Setting.statusBarHeight
        let minX: Double = Int(row) % 2 == 0 ?
            col * cellDiameter :  // odd row
            col * cellDiameter + cellDiameter / 2  // even row
        layoutAttribute.frame.origin = CGPoint(x: CGFloat(minX), y: CGFloat(minY))  // top-left corner point
        
        return layoutAttribute
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for section in 0 ... numRows {
            for row in 0 ... numCellsPerOddRow - 1 {
                if let attributes = layoutAttributesForItem(at: IndexPath(row: row, section: section)) {
                    if attributes.frame.intersects(rect) {
                        layoutAttributes.append(attributes)
                    }
                }
            }
        }
        return layoutAttributes
    }
}


