//
//  AnimationExtension.swift
//  BBSGameEngine
//
//  Created by luoyuyang on 18/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

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
        animationView.startAnimating()
        
        UIView.animate(withDuration: animationView.animationDuration,
                       animations: { _ in
                        animationView.bounds.size.height = finalSize.height
                        animationView.bounds.size.width = finalSize.width
        }, completion: { _ in
            animationView.stopAnimating()
            animationView.removeFromSuperview()
        })
    }
}
