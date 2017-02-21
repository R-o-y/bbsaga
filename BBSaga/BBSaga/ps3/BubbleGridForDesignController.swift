//
//  BubbleGridController.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 26/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class BubbleGridForDesignController: BubbleGridController {
    private var cellBorderWidth = Setting.cellBorderWidth
    
    /// set up an empty bubble grid for user to design on
    /// it also contains some important initialization process
    /// thus should be called right after the controller instance is created
    func setUpEmptyBubbleGrid() {
        guard let bubbleGrid = self.collectionView else {
            return
        }
        
        bubbleGrid.backgroundColor = UIColor.clear
        
        currentBubbleGrid.setUpEmptyBubbleGrid()
        
        bindGestureRecognizer(to: bubbleGrid)
    }

    /// helper function to bind gesture recognizers
    private func bindGestureRecognizer(to bubbleGrid: UICollectionView) {
        bubbleGrid.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(fillOrEraseCellsByPanning(_:))))
        bubbleGrid.addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(eraseCellByLongPressing(_:))))
        bubbleGrid.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(fillOrEraseOrCycleCellByTapping(_:))))
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Setting.bubbleGridCellIdentifier,
                                                      for: indexPath) as! BubbleGridCell
        
        cell.layer.borderWidth = cellBorderWidth
        cell.layer.borderColor = UIColor.black.cgColor
        
        cell.awakeFromNib()      
        return cell
    }
    
    /// load the image right before displaying the cell
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let bubbleGridCell = cell as! BubbleGridCell
        
        if let bubble = currentBubbleGrid.getBubbleAt(row: indexPath.section, col: indexPath.row) {
            bubbleGridCell.setImage(to: UIImage(named: Setting.imageName(ofBubble: bubble)))
        } else {
            bubbleGridCell.alpha = Setting.emptyCellAlpha
            bubbleGridCell.backgroundColor = UIColor.white
        }
    }
    
    /// tapping/dragging across a cell to fill it with the selected bubble colour
    /// if a bubble color was chosen in the palette
    /// Tapping/dragging across a cell to erase it if the erase button was chosen in the palette
    @objc private func fillOrEraseCellsByPanning(_ recognizer: UIPanGestureRecognizer) {
        guard self.collectionView != nil else {
            return
        }
        
        let bubbleGridView = self.collectionView!
        switch recognizer.state {
        case .began, .changed, .ended:
            let currentPoint = recognizer.location(in: bubbleGridView)
            guard let indexPath = bubbleGridView.indexPathForItem(at: currentPoint) else {
                return
            }
            
            let origBubble = currentBubbleGrid.getBubbleAt(row: indexPath.section, col: indexPath.row)
            
            switch bubbleGridDesigner.getCurrentDesignMode() {
            case .erasing:
                currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
            case .filling(let bubble):
                currentBubbleGrid.setBubbleAt(row: indexPath.section, col: indexPath.row, to: bubble)
            case .cycling: break
            }
            
            if currentBubbleGrid.getBubbleAt(row: indexPath.section,
                                             col: indexPath.row) != origBubble {
                UIView.performWithoutAnimation {
                    bubbleGridView.reloadItems(at: [indexPath])
                }
            }
        default:
            break
        }
    }
    
    /// convenient erasure of a cell (Long-press gesture)
    /// Notice, the following codes only clear the cell at which the finger press
    /// Even if the finger moves to other cells while pressing,
    /// those cells will not be cleared
    /// If want to achive this,
    /// simply add .changed and .ended into the first case pattern (after .began)
    @objc private func eraseCellByLongPressing(_ recognizer: UILongPressGestureRecognizer) {
        guard self.collectionView != nil else {
            return
        }
        let bubbleGridView = self.collectionView!
        switch recognizer.state {
        case .began:
            let currentPoint = recognizer.location(in: bubbleGridView)
            guard let indexPath = bubbleGridView.indexPathForItem(at: currentPoint) else {
                return
            }
            if !currentBubbleGrid.isCellEmptyAt(row: indexPath.section, col: indexPath.row) {
                currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
                UIView.performWithoutAnimation {
                    bubbleGridView.reloadItems(at: [indexPath])
                }
            }
        default:
            break
        }
    }
    
    /// tapping an existing bubble on the grid to cycling it through the bubble colours (Single-tap gesture).
    /// For example, tapping a blue bubble on the grid four times could cycling it 
    /// from blue -> green -> orange -> red -> blue. 
    /// Note that dragging across filled cells when a color has been selected 
    /// still fills all of them with the selected color.
    @objc private func fillOrEraseOrCycleCellByTapping(_ recognizer: UITapGestureRecognizer) {
        guard self.collectionView != nil else {
            return
        }
        let bubbleGridView = self.collectionView!
        let currentPoint = recognizer.location(in: bubbleGridView)
        guard let indexPath = bubbleGridView.indexPathForItem(at: currentPoint) else {
            return
        }
        let origBubble = currentBubbleGrid.getBubbleAt(row: indexPath.section, col: indexPath.row)
        
        switch bubbleGridDesigner.getCurrentDesignMode() {
        case .erasing:
            currentBubbleGrid.emptyCellAt(row: indexPath.section, col: indexPath.row)
        case .filling(let bubble):
            currentBubbleGrid.setBubbleAt(row: indexPath.section, col: indexPath.row, to: bubble)
        case .cycling:
            if !currentBubbleGrid.isCellEmptyAt(row: indexPath.section, col: indexPath.row) {
                let thisBubble = currentBubbleGrid.getBubbleAt(row: indexPath.section, col: indexPath.row)!
                if let nextBubble = nextBubbleInCycle(from: thisBubble) {
                    currentBubbleGrid.setBubbleAt(row: indexPath.section, col: indexPath.row, to: nextBubble)
                }
            }
        }
        
        if currentBubbleGrid.getBubbleAt(row: indexPath.section,
                                         col: indexPath.row) != origBubble {
            UIView.performWithoutAnimation {
                bubbleGridView.reloadItems(at: [indexPath])
            }
        }
    }
    
    /// helper function to get the next bubble in the cycle
    private func nextBubbleInCycle(from thisBubble: Bubble) -> Bubble? {
        if let thisBubble = thisBubble as? ColorBubble {
            let colorRawValue = thisBubble.getColor().rawValue
            if colorRawValue == Setting.numBubbleColor - 1 {
                if let power = BubblePower(rawValue: 0) {
                    return PowerBubble(ofPower: power)
                }
            }
            if let newColor = BubbleColor(rawValue: colorRawValue + 1) {
                return ColorBubble(ofColor: newColor)
            }
        } else if let thisBubble = thisBubble as? PowerBubble {
            let powerRawValue = thisBubble.getPower().rawValue
            if powerRawValue == Setting.numBubblePower - 1 {
                if let color = BubbleColor(rawValue: 0) {
                    return ColorBubble(ofColor: color)
                }
            }
            if let newPower = BubblePower(rawValue: powerRawValue + 1) {
                return PowerBubble(ofPower: newPower)
            }
        }
        return nil
    }
}




