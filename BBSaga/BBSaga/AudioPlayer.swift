//
//  AudioPlayer.swift
//  BBSaga
//
//  Created by 罗宇阳 on 14/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    private var avAudioPlayer = AVAudioPlayer()  // this is to play background music
    private var avPlayer = AVPlayer()  // this is to play sound effect
    
    func prepareBgm() {
        if let path = Bundle.main.path(forResource: "bgm", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                try avAudioPlayer = AVAudioPlayer(contentsOf: url)
                avAudioPlayer.prepareToPlay()
            } catch {}
        }
    }
    
    func playBgm() {
        avAudioPlayer.numberOfLoops = -1  // loop infinitely
        avAudioPlayer.play()
    }
    
    func pauseBgm() {
        avAudioPlayer.pause()
    }
    
    /// play the background music from the start
    func replayBgm() {
        avAudioPlayer.currentTime = 0
    }
}
