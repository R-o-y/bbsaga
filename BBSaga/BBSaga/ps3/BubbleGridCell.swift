//
//  BubbleGridView.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 26/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class BubbleGridCell: UICollectionViewCell {
    private var bubbleGridCellCotentView: UIImageView!
    
    override func awakeFromNib() {
        bubbleGridCellCotentView = UIImageView(frame: contentView.frame)
        bubbleGridCellCotentView.contentMode = .scaleToFill
        bubbleGridCellCotentView.clipsToBounds = true
        layer.cornerRadius = bounds.width / 2
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        contentView.addSubview(bubbleGridCellCotentView)
    }
    
    func setImage(to image: UIImage?) {
        self.bubbleGridCellCotentView.image = image
    }
}
