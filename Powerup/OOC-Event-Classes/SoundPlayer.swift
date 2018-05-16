//
//  SoundPlayer.swift
//  Powerup
//
//  Created by KD on 5/16/18.
//  Copyright © 2018 Systers. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

/*
    Example Use
 
    var soundPlayer : SoundPlayer? = SoundPlayer()
    guard let player = self.soundPlayer else {return}
    player.playSound(<#T##fileName: String##String#>, <#T##volume: Float##Float#>)
 
*/

class SoundPlayer {
    var player : AVAudioPlayer?
    
    init () {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound(_ fileName: String,_ volume: Float) {
        guard let sound = NSDataAsset(name: fileName) else { return }
        
        do {
            if #available(iOS 11.0, *) {
                player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            } else {
                player = try AVAudioPlayer(data: sound.data)
            }
            
            guard let soundplayer = player else { return }
            soundplayer.volume = volume
            soundplayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
