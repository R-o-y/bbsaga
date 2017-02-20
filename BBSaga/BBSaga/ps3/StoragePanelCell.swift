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
    private var cellView: UIView!
    private var cellLabelView: UILabel!
    
    override func awakeFromNib() {
        cellView = UIView(frame: contentView.frame)
        cellLabelView = UILabel(frame: contentView.frame)
        cellLabelView.textColor = .darkGray
        cellLabelView.textAlignment = .center
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        cellView.addSubview(cellLabelView)
        contentView.addSubview(cellView)
    }
    
    func setText(to text: String) {
        cellLabelView.text = text
    }
}
