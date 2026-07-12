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


enum GameText {
    
    static let higScore: String = "Congrats, you made it into the TOP5!" // Text for new highscore
    static let fail: String = "Sorry, you didn't make it in the TOP5!" // Text for not a new highscore
    
}


enum ObjectType {
    case circle
    case square
}

enum ObjectData {
    
    static let circleRadius: Double  = 30.0
    static let squareSize: Double = 60.0
    
    static let fadeIn: Double = 0.10
    static let fadeOut: Double = 0.05
    
    static let startDuration: Double = 4.0
    static let timerInterval: Double = 1.0
    
    static let randomObjectProbability: Int = 90
    
}


enum ObjectTouchParticle {
    
    static let standard = "ParticleFire"
    static let bonus: String = "ParticleMagic"
    
}
