//
//  Shape.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

protocol Shape {
    var offset: CGVector {get}
    func overlap(at myPosition: CGVector, with shape: Shape, at position: CGVector) -> Bool
}

class CircleShape: Shape {
    private(set) var offset: CGVector
    private(set) var radius: CGFloat

    init(radius: CGFloat) {
        self.radius = radius
        offset = CGVector.zero
    }
    
    init(radius: CGFloat, offset: CGVector) {
        self.radius = radius
        self.offset = offset
    }
    
    /// this method check whether this circle overlaps with another shape,
    /// currently only checking circle-circle overlaps is supported
    /// for other shapes, this method will return true
    /// - Parameters:
    ///     - myPosition: the position of the reference point, 
    ///                   the position of the center will be myPosition + self.offset
    ///     - shape: the other shape,
    ///     - position: the position of the reference point of the other shape, 
    ///                 the position of the center of the other shape will be position + shape.offset
    /// - Returns: true if this circle is overlapped with the other circle, false if not
    ///             if the other shape is not a circle, return true
    func overlap(at myPosition: CGVector, with shape: Shape, at itsPosition: CGVector) -> Bool {
        if let shape = shape as? CircleShape {
            let center1 = myPosition + self.offset
            let center2 = itsPosition + shape.offset
            let distance = center1.distance(to: center2)
            return distance < self.radius + shape.radius
        }
        return false
    }
}
