//
//  BubbleGridController.swift
//  LevelDesigner
//
//  Created by luoyuyang on 19/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class BubbleGridController: UICollectionViewController {
    private(set) var currentBubbleGrid = BubbleGrid()

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentBubbleGrid.getNumRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentBubbleGrid.getNumCellsAt(row: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Setting.bubbleGridCellIdentifier,
                                                      for: indexPath) as! BubbleGridCell
        
        cell.awakeFromNib()
        return cell
    }
    
    /// load the image right before displaying the cell
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let bubbleGridCell = cell as! BubbleGridCell
        
        if let bubble = currentBubbleGrid.getBubbleAt(row: indexPath.section, col: indexPath.row) {
            bubbleGridCell.setImage(to: UIImage(named: Setting.imageName(ofBubble: bubble)))
        }
    }
    
    func setBubbleGrid(to bubbleGrid: BubbleGrid) {
        currentBubbleGrid = bubbleGrid
        if let bubbleGridView = collectionView {
            bubbleGridView.reloadData()
        }
    }
    
    /// clean all the cells of the BubbleGridView this controller control
    /// this method is supposed to be called by its parentController
    func cleanAllCells() {
        currentBubbleGrid.cleanAllCells()
        if let bubbleGridView = collectionView {
            bubbleGridView.reloadData()
        }
    }
}
