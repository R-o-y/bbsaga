//
//  Shape.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

public protocol Shape {
    func overlap(at myPosition: CGVector, with shape: Shape, at position: CGVector) -> Bool
}

public class CircleShape: Shape {
    private(set) var offset: CGVector
    private(set) var radius: CGFloat

    public init(radius: CGFloat) {
        self.radius = radius
        offset = CGVector.zero
    }
    
    public init(radius: CGFloat, offset: CGVector) {
        self.radius = radius
        self.offset = offset
    }
    
    /// this method check whether this circle overlaps with another shape,
    /// currently only checking circle-circle and circle-segment overlaps are supported
    /// for other shapes, this method will return false
    /// - Parameters:
    ///     - myPosition: the position of the reference point, 
    ///                   the position of the center will be myPosition + self.offset
    ///     - shape: the other shape,
    ///     - position: the position of the reference point of the other shape, 
    ///                 the position of the center of the other shape will be position + shape.offset
    /// - Returns: true if this circle is overlapped with the other circle or segment, false if not
    ///             if the other shape is not a circle, return false
    public func overlap(at myPosition: CGVector, with shape: Shape, at itsPosition: CGVector) -> Bool {
        let center = myPosition + self.offset
        if let shape = shape as? CircleShape {
            let center2 = itsPosition + shape.offset
            let distance = center.distance(to: center2)
            return distance < self.radius + shape.radius
        }
        if let shape = shape as? SegmentShape {
            let x1 = shape.p1.dx + itsPosition.dx
            let x2 = shape.p2.dx + itsPosition.dx
            let y1 = shape.p1.dy + itsPosition.dy
            let y2 = shape.p2.dy + itsPosition.dy
            let a = y2 - y1
            let b = x1 - x2
            let normalVector = CGVector(dx: a, dy: b)
            let projectionOnNormal = ((shape.p1 + itsPosition) - center).projection(on: normalVector)
            if projectionOnNormal.norm() < radius {
                let projectionPoint = center + projectionOnNormal
                let x = projectionPoint.dx
                let y = projectionPoint.dy
                // projection point in between of 2 end points
                if (x - x1) * (x - x2) <= 0 && (y - y1) * (y - y2) <= 0 {
                    return true
                }
            }
        }
        return false
    }
}

public class SegmentShape: Shape {
    private(set) var p1: CGVector  // in local coordinate
    private(set) var p2: CGVector
    
    public init(from p1: CGVector, to p2: CGVector) {
        self.p1 = p1
        self.p2 = p2
    }
    
    /// currently, only segment-circle overlaps is supported
    public func overlap(at myPosition: CGVector, with shape: Shape, at position: CGVector) -> Bool {
        if let shape = shape as? CircleShape {
            return shape.overlap(at: position, with: self, at: myPosition)
        }
        return false
    }
}

