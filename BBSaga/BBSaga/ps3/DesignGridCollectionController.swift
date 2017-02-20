//
//  CutomGridListController.swift
//  LevelDesigner
//
//  Created by luoyuyang on 19/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class DesignGridCollectionController: UICollectionViewController {
    private var designGridURLList: [URL] = []
    private let storageManager = StorageManager()
    private let numGridPerRow = Setting.numGridsPerRow
    
    override func viewDidLoad() {
        guard let designGridCollectionView = collectionView else {
            return
        }
        designGridCollectionView.backgroundColor = UIColor.clear
        
        if let list = storageManager.loadBubbleGridFileURLs() {
            designGridURLList = list
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil(Double(designGridURLList.count) / Double(numGridPerRow)))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numOfItemsInThisAndFollowingSection = designGridURLList.count - numGridPerRow * section
        if numOfItemsInThisAndFollowingSection < numGridPerRow {
            return numOfItemsInThisAndFollowingSection
        } else {
            return numGridPerRow
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Setting.designGridCellIdentifier,
                                                      for: indexPath) as! DesignGridCell
        cell.awakeFromNib()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let designGridCell = cell as? DesignGridCell else {
            return
        }
        
        let row = indexPath.section + 1
        let col = indexPath.row + 1
        let index = (row - 1) * numGridPerRow + col - 1
        
        if index < designGridURLList.count {
            let url = designGridURLList[index]
            guard let loadedDic = storageManager.load(from: url) else {
                return
            }
            guard let loadedBubbleGrid = loadedDic["bubbleGrid"] as? BubbleGrid else {
                return
            }
            
            designGridCell.setUpBubbleGrid(to: loadedBubbleGrid)
            
            // remove path and extension
            let name = url.lastPathComponent.components(separatedBy: ".")[0]
            designGridCell.setUpNameLabelText(to: name)
        }
    }
}













