////
////  EventDetector.swift
////  BBSGameEngine
////
////  Created by 罗宇阳 on 7/2/17.
////  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
////
//
//import Foundation
//
//class EventDetector {
//    private var targets: [RigidBody] = []
//    private var callback: ((RigidBody) -> Void)
//    private var detectEvent: ((RigidBody) -> Bool)
//    
//    init(detectEvent: @escaping (((RigidBody)) -> Bool),
//         callback: @escaping (((RigidBody)) -> Void)) {
//        self.detectEvent = detectEvent
//        self.callback = callback
//    }
//    
//    func addTarget(_ target: RigidBody) {
//        if !targets.contains(target) {
//            targets.append(target)
//        }
//    }
//    
//    func removeTarget(_ target: RigidBody) {
//        targets.removeEqualItems(item: target)
//    }
//    
//    /// check whether the event happens (detectEvent returns true)
//    /// if so, trigger callback function on them
//    func check() {
//        for body in targets {
//            if detectEvent(body) {
//                callback(body)
//            }
//        }
//    }
//}
