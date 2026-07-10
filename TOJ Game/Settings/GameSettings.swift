//
//  GameSettings.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 10.07.26.
//

import Foundation
import AudioToolbox

// sound ids


enum GameSound {
    
    static let circle: SystemSoundID = 1052      // normal touch
    static let square: SystemSoundID = 1007     // bonus touch
    static let levelUp: SystemSoundID = 1016     // bonus touch
    
    static let missTouch: SystemSoundID = 1000   // touch missed
    
    static let fail: SystemSoundID = 1021    // game over
    static let highScore: SystemSoundID = 1025    // game over
    
}

