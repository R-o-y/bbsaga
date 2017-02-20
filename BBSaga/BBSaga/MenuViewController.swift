//
//  MenuViewController.swift
//  BBSaga
//
//  Created by 罗宇阳 on 13/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import UIKit
import AVFoundation

let audioPlayer = AudioPlayer()

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer.prepareBgm()
        audioPlayer.playBgm()
        setUpBackground()
    }
    
    /// helper function to add background image into current view
    private func setUpBackground() {
        let background = UIImageView(image: UIImage(named: "home-background.jpg"))
        background.frame = CGRect(x: 0, y: 0,
                                  width: view.frame.width,
                                  height: view.frame.height)
        view.insertSubview(background, at: 0)  // insert at the most back
    }
    
    @IBAction func bgmSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {  // the state after change
            audioPlayer.playBgm()
        } else {
            audioPlayer.pauseBgm()
        }
    }
    
    @IBAction func unwindSegueToMenu(segue: UIStoryboardSegue) {}
}

