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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var settingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer.prepareBgm()
        audioPlayer.playBgm()
        titleLabel.transform = CGAffineTransform(rotationAngle: -0.08)
        settingView.layer.cornerRadius = settingView.bounds.width * Setting.cellCornerRadiusWidthRate
        settingView.isHidden = true  // hide at the beginning
    }
    
    @IBAction func bgmSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {  // the state after change
            audioPlayer.playBgm()
        } else {
            audioPlayer.pauseBgm()
        }
    }

    @IBAction func toggleSettingView(_ sender: Any) {
        if settingView.isHidden {
            settingView.isHidden = false
        } else {
            settingView.isHidden = true
        }
    }
    
    @IBAction func unwindSegueToMenu(segue: UIStoryboardSegue) {}
}

