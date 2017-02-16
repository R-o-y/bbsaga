//
//  Animation.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class Animation {
    static func sinkAndFloat(_ target: UIView, duration: TimeInterval = 0.38, range: CGFloat = 28) {
        let halfTime = duration / Double(2)
        UIView.animate(withDuration: halfTime, animations: {
            target.transform = CGAffineTransform(translationX: 0, y: range);
        })
        UIView.animate(withDuration: halfTime, delay: halfTime, animations: {
            target.transform = CGAffineTransform(translationX: 0, y: 0);
        })
    }
    
    static func animateTableFallingCells(_ tableView: UITableView) {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
        }
        
        var index = 0
        
        for cell in cells.reversed() {
            UIView.animate(withDuration: 0.8, delay: 0.06 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            index += 1
        }
    }
    
    static func leftSlideIn(_ target: UIView, duration: TimeInterval = 0.38, delay: TimeInterval) {
        if let superViewWidth = target.superview?.bounds.width {
            target.transform = CGAffineTransform(translationX: -superViewWidth, y: 0)

            UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                target.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}









