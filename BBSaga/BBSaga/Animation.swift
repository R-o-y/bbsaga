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
    static func animateTableSlidingUpCells(_ tableView: UITableView) {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
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

// game play effect
extension Animation {
    static func cutSequenceImageIntoImages(named name: String, numRows: Int, numCols: Int) -> [UIImage] {
        guard let image = UIImage(named: name) else {
            return []
        }
        var returnedImages: [UIImage] = []
        let width = CGFloat(image.size.width / CGFloat(numCols))
        let height = CGFloat(image.size.height / CGFloat(numRows))
        for i in 0 ..< numRows {
            for j in 0 ..< numCols {
                let x = CGFloat(j) * width
                let y = CGFloat(i) * height
                let rect = CGRect(x: x, y: y, width: width, height: height)
                if let nextFrameImage = cropImage(image: image, toRect: rect) {
                    returnedImages.append(nextFrameImage)
                }
            }
        }
        return returnedImages
    }
    
    static private func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let scale = image.scale
        let realSizeRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale,
                                  width: rect.size.width * scale, height: rect.size.height * scale)
        let imageRef: CGImage = cgImage.cropping(to: realSizeRect)!
        let croppedImage: UIImage = UIImage(cgImage: imageRef)
        return croppedImage
    }
    
    static func animateBubbleBurst(within frame: CGRect, in superView: UIView, withDuration duration: TimeInterval) {
        let animationView = UIImageView()
        
        let finalScale = Setting.bubbleBurstAnimationFinalScale
        let size = frame.size
        animationView.frame.size = size
        
        let finalSize = CGSize(width: size.width * finalScale, height: size.height * finalScale)
        
        let center = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 2)
        animationView.center = center
        
        animationView.animationImages = cutSequenceImageIntoImages(named: Setting.bubbleBurstAnimationImageName,
                                                                   numRows: Setting.bubbleBurstAnimationRowNum,
                                                                   numCols: Setting.bubbleBurstAnimationColNum)
        animationView.animationDuration = duration
        animationView.animationRepeatCount = Setting.bubbleBurstAnimationRepeatCount
        superView.addSubview(animationView)
        
        UIView.animate(withDuration: animationView.animationDuration,
                       animations: { _ in
                        animationView.startAnimating()
                        animationView.bounds.size.height = finalSize.height
                        animationView.bounds.size.width = finalSize.width
        }, completion: { _ in animationView.removeFromSuperview() })
    }
    
    static func animateLightning(centerY: CGFloat, in superView: UIView) {
        let sectionDuration: TimeInterval = Setting.lightningSectionDuration
        let nextStartingTimeRatio = Setting.lightningNextStartingTimeRate
        let sectionWidth = Setting.lightningSectionWidth
        let lengthRate = Setting.lightningNextStartingPositionRate
        let y = centerY - sectionWidth * Setting.lightningVerticalHalfRate
        
        var lightningSections: [UIImageView] = []
        let numSection = Int(ceil(superView.bounds.width / sectionWidth) / lengthRate) + 1
        
        // prepare
        for i in 0 ..< numSection {
            let lightningSectionView = UIImageView(frame: CGRect(x: CGFloat(i) * sectionWidth * lengthRate, y: y, width: sectionWidth, height: sectionWidth))
            let lightningAnimationImages = cutSequenceImageIntoImages(named: Setting.lightningSpriteSheetName,
                                                                      numRows: Setting.lightningSpriteSheetRowNum,
                                                                      numCols: Setting.lightningSpriteSheetColNum)
            lightningSectionView.animationImages = lightningAnimationImages
            lightningSectionView.animationDuration = sectionDuration
            lightningSectionView.animationRepeatCount = 1
            lightningSections.append(lightningSectionView)
        }
        // animate
        for i in 0 ..< numSection {
            delay(TimeInterval(i) * sectionDuration * nextStartingTimeRatio) {
                superView.addSubview(lightningSections[i])
                lightningSections[i].startAnimating()
            }
        }
        // finish
        delay(sectionDuration * TimeInterval(numSection - 1) * nextStartingTimeRatio + sectionDuration) {
            for sectionView in lightningSections {
                sectionView.removeFromSuperview()
            }
        }
    }
    
    static func animateFireHit(within frame: CGRect, in superView: UIView) {
        let fireAnimationView = UIImageView(frame: frame)
        fireAnimationView.animationImages = cutSequenceImageIntoImages(named: Setting.firehitSpriteSheetName,
                                                                       numRows: Setting.firehitSpriteSheetRowNum,
                                                                       numCols: Setting.firehitSpriteSheetColNum)
        fireAnimationView.animationDuration = 0.6
        fireAnimationView.animationRepeatCount = 1
        superView.addSubview(fireAnimationView)
        fireAnimationView.startAnimating()
        delay(fireAnimationView.animationDuration) {
            fireAnimationView.removeFromSuperview()
        }
    }
    
    static func createLightningObstacleView(origin: CGPoint, numSections: Int) -> UIView {
        let width: CGFloat = Setting.lightningObstacleWidth
        let rate = Setting.lightningObstacleWidthRate
        let size = CGSize(width: width * CGFloat(numSections - 1) * rate + width, height: width)
        let containerView = UIView(frame: CGRect(origin: origin, size: size))
        for i in 0 ... numSections - 1 {
            let sectionOrigin = CGPoint(x: CGFloat(i) * width * rate, y: 0)
            let section = UIImageView(frame: CGRect(origin: sectionOrigin, size: CGSize(width: width, height: width)))
            section.animationImages = cutSequenceImageIntoImages(named: Setting.lightningObstacleSpriteSheetName,
                                                                 numRows: Setting.lightningObstacleSpriteSheetRowNum,
                                                                 numCols: Setting.lightningObstacleSpriteSheetColNum)
            section.animationDuration = Setting.lightningObstacleAnimationDuration
            containerView.addSubview(section)
            delay(Double(i) * Setting.lightningObstacleDelay) {
                section.startAnimating()
            }
        }
        return containerView
    }
    
    static func animateLightningDisappear(within frame: CGRect, in superView: UIView) {
        let animationView = UIImageView()
        
        let finalScale: CGFloat = Setting.finalScale
        let size = CGSize(width: frame.size.width * Setting.initScale,
                          height: frame.size.height * Setting.initScale)
        animationView.frame.size = size
        
        let finalSize = CGSize(width: size.width * finalScale, height: size.height * finalScale)
        
        let center = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 2)
        animationView.center = center
        
        animationView.animationImages = cutSequenceImageIntoImages(named: Setting.spriteSheetName,
                                                                   numRows: Setting.spriteSheetNumRows,
                                                                   numCols: Setting.spriteSheetNumCols)
        animationView.animationDuration = Setting.duration
        animationView.animationRepeatCount = Setting.bubbleBurstAnimationRepeatCount
        superView.addSubview(animationView)
        
        UIView.animate(withDuration: animationView.animationDuration,
                       animations: { _ in
                        animationView.startAnimating()
                        animationView.bounds.size.height = finalSize.height
                        animationView.bounds.size.width = finalSize.width
        }, completion: { _ in animationView.removeFromSuperview() })
    }
}

func delay(_ delay: Double, _ closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}






















