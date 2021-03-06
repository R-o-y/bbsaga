//
//  PlayGridCell.swift
//  BBSaga
//
//  Created by luoyuyang on 20/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class PlayGridCell: UICollectionViewCell {
    private var bubbleGridView: UICollectionView!
    private(set) var bubbleGridController: BubbleGridController!
    private var nameLabel: UILabel!
    
    override func awakeFromNib() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        setUpBubbleGridView()
        setUpNameLabel()
        bindGestureRecognizer()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = contentView.bounds.width * Setting.cellCornerRadiusWidthRate
    }
    
    private func bindGestureRecognizer() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notifyPerformSegueToPlayer(sender:))))
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
        
        bubbleGridView.backgroundColor = UIColor.white
        bubbleGridView.alpha = Setting.bubbleGridViewAlpha
        bubbleGridView.contentMode = .scaleToFill
        
        contentView.addSubview(bubbleGridView)
    }
    
    private func setUpNameLabel() {
        nameLabel = UILabel()
        nameLabel.backgroundColor = UIColor.darkGray
        let height = contentView.bounds.size.width * Setting.gridThumbnailFooterHeightRatio
        let width = contentView.bounds.size.width
        nameLabel.frame.size = CGSize(width: width, height: height)
        nameLabel.frame.origin = CGPoint(x: 0, y: contentView.bounds.size.height - height)
        nameLabel.textColor = .white
        nameLabel.font = Setting.nameLabelFont
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
    @IBAction @objc func notifyPerformSegueToPlayer(sender: UIButton) {
        guard let bubbleGridController = bubbleGridController else {
            return
        }
        let name = Notification.Name(rawValue: Setting.segueToPlayerNotificationName)
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








