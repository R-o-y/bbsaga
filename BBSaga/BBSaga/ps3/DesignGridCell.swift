//
//  DesignGridCell.swift
//  LevelDesigner
//
//  Created by luoyuyang on 19/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class DesignGridCell: UICollectionViewCell {
    private var bubbleGridView: UICollectionView!
    private var bubbleGridController: BubbleGridController!
    private var editButton: UIButton!
    private var nameLabel: UILabel!
    
    override func awakeFromNib() {
        setUpBubbleGridView()
        setUpNameLabel()
        setUpEditButton()
    }
    
    private func setUpBubbleGridView() {
        let layout = BubbleGridCellFlowLayout()
        bubbleGridController = BubbleGridController(collectionViewLayout: layout)
        
        guard let bubbleGridControllerCollectionView = bubbleGridController.collectionView else {
            return
        }
        bubbleGridView = bubbleGridControllerCollectionView
        
        bubbleGridView.isScrollEnabled = false
        bubbleGridView.frame = contentView.frame
        bubbleGridView.register(BubbleGridCell.self, forCellWithReuseIdentifier: Setting.bubbleGridCellIdentifier)
        
        bubbleGridView.backgroundColor = UIColor.clear
        bubbleGridView.contentMode = .scaleToFill
        bubbleGridView.clipsToBounds = true
        
        contentView.addSubview(bubbleGridView)
    }
    
    private func setUpNameLabel() {
        nameLabel = UILabel()
        let height = contentView.bounds.size.width * Setting.gridThumbnailFooterHeightRatio
        let width = contentView.bounds.size.width * (1 - Setting.gridCollectionItemSizeRatio)
        nameLabel.frame.size = CGSize(width: width, height: height)
        nameLabel.frame.origin = CGPoint(x: 0, y: contentView.bounds.size.height - height)
        nameLabel.textColor = .darkGray
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
    
    private func setUpEditButton() {
        editButton = UIButton()
        let width = contentView.bounds.size.width * Setting.gridThumbnailFooterHeightRatio
        editButton.frame.size = CGSize(width: width, height: width)
        editButton.frame.origin = CGPoint(x: contentView.bounds.size.width - width, y: contentView.bounds.size.height - width)
        editButton.setImage(UIImage(named: Setting.editButtonImageName), for: .normal)
        editButton.addTarget(self, action: #selector(notifyPerformSegueToDesigner(sender:)), for: .touchUpInside)
        contentView.addSubview(editButton)
    }
    
    @IBAction @objc func notifyPerformSegueToDesigner(sender: UIButton) {
        guard let bubbleGridController = bubbleGridController else {
            return
        }
        let name = Notification.Name(rawValue: Setting.segueToDesignerNotificationName)
        NotificationCenter.default.post(Notification(name: name, object: bubbleGridController))
    }
    
    func setUpBubbleGrid(to bubbleGrid: BubbleGrid) {
        if let bubbleGridController = bubbleGridController {
            bubbleGridController.setBubbleGrid(to: bubbleGrid)
        }
    }
    
    func setUpNameLabelText(to text: String) {
        if let nameLabel = nameLabel {
            nameLabel.text = text
        }
    }
}









