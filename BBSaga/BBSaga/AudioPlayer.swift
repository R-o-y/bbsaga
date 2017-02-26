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
    
    func prepare() {
        // prepare background audio player
        if let path = Bundle.main.path(forResource: "bgm", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                try avAudioPlayer = AVAudioPlayer(contentsOf: url)
            } catch {}
        }
        // prepare sound effects player
        guard let path = Bundle.main.path(forResource: "shoot", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
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
    
    func playShootSoundEffect() {
        avPlayerPlay(name: "shoot", ofType: "mp3")
    }
    
    func playBombSoundEffect() {
        avPlayerPlay(name: "bomb", ofType: "mp3")
    }
    
    func playLightningSoundEffect() {
        avPlayerPlay(name: "lightning2", ofType: "mp3")
    }
    
    func playSameColorSoundEffect() {
        avPlayerPlay(name: "same-color", ofType: "mp3")
    }
    
    private func avPlayerPlay(name: String, ofType extensionName: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: extensionName) else {
            return
        }
        let url = URL(fileURLWithPath: path)
        avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        avPlayer.play()
    }
}
