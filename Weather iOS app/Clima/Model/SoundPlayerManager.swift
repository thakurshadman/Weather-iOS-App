//
//  SoundPlayerManager.swift
//  Clima
//
//  Created by Shadman Thakur on 12/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
//MARK: - CreditL Appbrewery.co (IOS Web Course)
class SoundPlayerManager{
var player: AVAudioPlayer!
    
func playSound() {
    let url = Bundle.main.url(forResource: "click", withExtension: "mp3")
    player = try! AVAudioPlayer(contentsOf: url!)
    player.play()
            
    }
}
