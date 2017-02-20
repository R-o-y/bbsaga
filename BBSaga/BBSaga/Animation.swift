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
    static func animateTableFallingCells(_ tableView: UITableView) {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        
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
    
    static func animateCollectionFallingCells(_ collectionView: UICollectionView) {
        let cells = collectionView.visibleCells
        let collectionHeight = collectionView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -collectionHeight)
        }
        
        var index = 0
        
        for cell in cells.reversed() {
            UIView.animate(withDuration: 0.8, delay: 0.08 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            index += 1
        }
    }
    
    static func sinkAndFloat(_ target: UIView, duration: TimeInterval = Setting.sinkAndFloatDefaultDuration, range: CGFloat = Setting.sinkAndFloatDefaultRange) {
        let halfTime = duration / Double(2)
        UIView.animate(withDuration: halfTime, animations: {
            target.transform = CGAffineTransform(translationX: 0, y: range);
        })
        UIView.animate(withDuration: halfTime, delay: halfTime, animations: {
            target.transform = CGAffineTransform(translationX: 0, y: 0);
        })
    }
    
    static func leftSlideIn(_ target: UIView, duration: TimeInterval = Setting.leftSlideInDefaultDuration, delay: TimeInterval) {
        if let superViewWidth = target.superview?.bounds.width {
            target.transform = CGAffineTransform(translationX: -superViewWidth, y: 0)
            
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                target.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}








