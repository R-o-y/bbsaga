//
//  CGVectorExtension.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 4/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

extension CGVector {
    static func +(v1: CGVector, v2: CGVector) -> CGVector {
        return CGVector(dx: v1.dx + v2.dx, dy: v1.dy + v2.dy)
    }
    
    static func -(v1: CGVector, v2: CGVector) -> CGVector {
        return CGVector(dx: v1.dx - v2.dx, dy: v1.dy - v2.dy)
    }
    
    static func *(scalar: CGFloat, vector: CGVector) -> CGVector {
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }
    
    static func *(scalarInt: Int, vector: CGVector) -> CGVector {
        let scalar = CGFloat(scalarInt)
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }
    
    static func *(scalarDouble: Double, vector: CGVector) -> CGVector {
        let scalar = CGFloat(scalarDouble)
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }
    
    static func /(vector: CGVector, scalar: CGFloat) -> CGVector {
        if scalar != 0 {
            return 1 / Double(scalar) * vector
        }
        return CGVector.zero
    }
    
    static func /(vector: CGVector, scalarInt: Int) -> CGVector {
        if scalarInt != 0 {
            return 1 / Double(scalarInt) * vector
        }
        return CGVector.zero
    }
    
    static func /(vector: CGVector, scalarDouble: Double) -> CGVector {
        if scalarDouble != 0 {
            return 1 / Double(scalarDouble) * vector
        }
        return CGVector.zero
    }
    
    static func *(v1: CGVector, v2: CGVector) -> CGFloat {
        return v1.dx * v2.dx + v1.dy * v2.dy
    }
    
    /// - Returns: the length of the vector
    func norm() -> CGFloat {
        return sqrt(self * self)
    }
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    func distance(to point: CGVector) -> CGFloat {
        return (self - point).norm()
    }
    
    func reflect(by mirror: CGVector) -> CGVector {
        let projection = (self * mirror) / (mirror * mirror) * mirror
        return 2 * projection - self
    }
    
    init(_ point: CGPoint) {
        self.dx = point.x
        self.dy = point.y
    }
}













