//
//  IntExtension.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

extension Int {
    /// - Parameters:
    ///     - lower: the lower bound
    ///     - upper: the upper bound
    /// - Returns: a random interger between the lower (inclusive) and upper (inclusive) bound
    static func randomWithinRange(lower: Int, upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
