//
//  ArrayExtension.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    /// removing all the items that is equal to the given element
    /// for instance, [1,2,1].removeEqualItems(item: 1) will get [2]
    public mutating func removeEqualItems(item: Element) {
        while let index = index(of: item) {
            remove(at: index)
        }
    }
    
    /// get an array of all pairs of elements in array, 
    /// excluding pairs of element at the same index and pairs of reverse order
    /// for instance, [1,2,3].getAllPairs() will return [(1,2), (1,3), (2,3)]
    public func getAllPairs() -> [(Element, Element)] {
        var allPairs: [(Element, Element)] = []
        var i = 0
        while i < self.count {
            var j = i + 1
            while j < self.count {
                allPairs.append((self[i], self[j]))
                j += 1
            }
            i += 1
        }
        return allPairs
    }
}
