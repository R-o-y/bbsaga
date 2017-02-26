//
//  PlayGridCollectionController.swift
//  BBSaga
//
//  Created by luoyuyang on 20/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class PlayGridCollectionController: UICollectionViewController {
    private var playGridURLList: [URL] = []
    private let storageManager = StorageManager()
    private let numGridPerRow = Setting.numGridsPerRow
    
    override func viewDidLoad() {
        guard let playGridCollectionView = collectionView else {
            return
        }
        playGridCollectionView.backgroundColor = UIColor.clear
        
        for url in storageManager.preloadLevelURLs {
            playGridURLList.append(url)
        }
        if let userDesignedGridURLs = storageManager.loadBubbleGridFileURLs() {
            for url in userDesignedGridURLs {
                playGridURLList.append(url)
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil(Double(playGridURLList.count) / Double(numGridPerRow)))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numOfItemsInThisAndFollowingSection = playGridURLList.count - numGridPerRow * section
        if numOfItemsInThisAndFollowingSection < numGridPerRow {
            return numOfItemsInThisAndFollowingSection
        } else {
            return numGridPerRow
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Setting.playGridCellIdentifier,
                                                      for: indexPath) as! PlayGridCell
        cell.awakeFromNib()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let playGridCell = cell as? PlayGridCell else {
            return
        }
        
        let row = indexPath.section + 1
        let col = indexPath.row + 1
        let index = (row - 1) * numGridPerRow + col - 1
        
        if index < playGridURLList.count {
            let url = playGridURLList[index]
            guard let loadedDic = storageManager.load(from: url) else {
                return
            }
            guard let loadedBubbleGrid = loadedDic["bubbleGrid"] as? BubbleGrid else {
                return
            }
            
            playGridCell.setUpBubbleGrid(to: loadedBubbleGrid)
            
            // remove path and extension
            let name = url.lastPathComponent.components(separatedBy: ".")[0]
            playGridCell.setUpNameLabelText(to: name)
        }
    }
}








