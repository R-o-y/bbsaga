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
    private var bgmPlayer = AVAudioPlayer()
    private var shootPlayer = AVAudioPlayer()
    private var lightningPlayer = AVAudioPlayer()
    private var bombPlayer = AVAudioPlayer()
    private var sameColorPlayer = AVAudioPlayer()
    
    func prepare() {
        // prepare background audio player
        bgmPlayer = getAudioPlayer(playing: "bgm", ofType: "mp3")
        shootPlayer = getAudioPlayer(playing: "shoot", ofType: "mp3")
        lightningPlayer = getAudioPlayer(playing: "lightning2", ofType: "mp3")
        bombPlayer = getAudioPlayer(playing: "bomb", ofType: "mp3")
        sameColorPlayer = getAudioPlayer(playing: "same-color", ofType: "mp3")
        bgmPlayer.volume = Setting.bgmVolumn
        bombPlayer.volume = Setting.bombVolumn
        shootPlayer.volume = Setting.shootVolumn
    }
    
    func playBgm() {
        bgmPlayer.numberOfLoops = -1  // loop infinitely
        bgmPlayer.play()
    }
    
    func pauseBgm() {
        bgmPlayer.pause()
    }
    
    /// play the background music from the start
    func replayBgm() {
        bgmPlayer.currentTime = 0
    }
    
    func playShootSoundEffect() {
        playSoundEffect(by: shootPlayer)
    }
    
    func playBombSoundEffect() {
        playSoundEffect(by: bombPlayer)
    }
    
    func playLightningSoundEffect() {
        playSoundEffect(by: lightningPlayer)
    }
    
    func playSameColorSoundEffect() {
        playSoundEffect(by: sameColorPlayer)
    }
    
    private func getAudioPlayer(playing name: String, ofType extensionName: String) -> AVAudioPlayer {
        var player = AVAudioPlayer()
        if let path = Bundle.main.path(forResource: name, ofType: extensionName) {
            let url = URL(fileURLWithPath: path)
            do {
                try player = AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            } catch {}
        }
        return player
    }
    
    private func playSoundEffect(by player: AVAudioPlayer) {
        DispatchQueue.global().async {
            if player.isPlaying {
                player.currentTime = 0
            } else {
                player.play()
            }
        }
    }
}











