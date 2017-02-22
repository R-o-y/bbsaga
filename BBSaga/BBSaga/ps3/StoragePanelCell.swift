//
//  StoragePanelCell.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 29/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class StoragePanelCell: UITableViewCell {
    private var url: URL!
    private var containerView: UIView!
    private var bubbleGridView: UICollectionView!
    private(set) var bubbleGridController: BubbleGridController!
    private var removeButton: UIButton!
    private var nameLabel: UILabel!
    private var isSetUp = false
    
    override func awakeFromNib() {
        if !isSetUp {
            setUpContainerView()
            setUpBubbleGridView()
            setUpNameLabel()
            setUpRemoveButton()
            isSetUp = true
        }
    }

    private func setUpContainerView() {
        let width = contentView.frame.width * Setting.containerWidthInPercentage
        let height = contentView.frame.height * Setting.containerHeightInPercentage
        let frame = CGRect(x: (contentView.frame.width - width) / 2,
                           y: height * Setting.containerUpperPaddingInPercentage,
                           width: width,
                           height: height * (1 - Setting.containerUpperPaddingInPercentage))
        containerView = UIView(frame: frame)
        containerView.layer.borderWidth = 0.8
        containerView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.addSubview(containerView)
    }

    private func setUpBubbleGridView() {
        let layout = BubbleGridCellFlowLayout()
        bubbleGridController = BubbleGridController(collectionViewLayout: layout)
        
        guard let bubbleGridControllerCollectionView = bubbleGridController.collectionView else {
            return
        }
        bubbleGridView = bubbleGridControllerCollectionView
        
        bubbleGridView.isScrollEnabled = false
        
        bubbleGridView.frame = containerView.bounds
        bubbleGridView.register(BubbleGridCell.self, forCellWithReuseIdentifier: Setting.bubbleGridCellIdentifier)
        
        bubbleGridView.backgroundColor = UIColor.clear
        bubbleGridView.contentMode = .scaleToFill
        bubbleGridView.clipsToBounds = true
        
        containerView.addSubview(bubbleGridView)
    }
    
    private func setUpNameLabel() {
        nameLabel = UILabel()
        let height = containerView.bounds.size.width * Setting.gridThumbnailFooterHeightRatio
        let width = containerView.bounds.size.width
        nameLabel.frame.size = CGSize(width: width, height: height)
        nameLabel.frame.origin = CGPoint(x: 0, y: containerView.bounds.size.height - height)
        nameLabel.textColor = .darkGray
        nameLabel.textAlignment = .center
        containerView.addSubview(nameLabel)
    }
    
    private func setUpRemoveButton() {
        let height = containerView.bounds.width * Setting.gridThumbnailFooterHeightRatio
        let width = height
        removeButton = UIButton(frame: CGRect(x: containerView.bounds.width  - width,
                                              y: containerView.bounds.height - height,
                                              width: width, height: height))
        removeButton.setImage(UIImage(named: Setting.removeButtonImageName), for: .normal)
        removeButton.addTarget(self, action: #selector(notifyRemoveGrid(sender:)), for: .touchUpInside)
        containerView.addSubview(removeButton)
    }
    
    @IBAction @objc func notifyRemoveGrid(sender: UIButton) {
        guard let url = url else {
            return
        }
        let name = Notification.Name(rawValue: Setting.removeGridNotificationName)
        NotificationCenter.default.post(Notification(name: name, object: url))
    }
    
    func setUpBubbleGrid(to bubbleGrid: BubbleGrid) {
        if let bubbleGridController = bubbleGridController {
            bubbleGridController.setBubbleGrid(to: bubbleGrid)
        }
    }
    
    func setURL(to url: URL) {
        self.url = url
    }
    
    func setUpNameLabelText(to text: String) {
        if let nameLabel = nameLabel {
            nameLabel.text = text
        }
    }
}











