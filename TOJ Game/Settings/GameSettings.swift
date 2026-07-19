//
//  GameSettings.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 10.07.26.
//

import Foundation
import AudioToolbox
import SwiftUI

// sound ids

enum GameSound {
    
    static let circle: SystemSoundID = 1052     // normal touch
    static let square: SystemSoundID = 1007     // bonus touch
    static let levelUp: SystemSoundID = 1016    // bonus touch
    
    static let missTouch: SystemSoundID = 1000  // touch missed
    
    static let fail: SystemSoundID = 1021       // game over
    static let highScore: SystemSoundID = 1025  // game over
    
}

// highscore info text

enum GameText {
    static let higScore: String = "Congrats, you made it into the TOP5!"    // Text for new highscore
    static let fail: String = "Sorry, you didn't make it in the TOP5!"      // Text for not a new highscore
}

// types of gaming objects

enum ObjectType {
    case circle
    case square
}


// properties for the gaming objects

enum ObjectData {
    static let circleRadius: Double  = 30.0     // size for circle
    static let circleScore: Int = 1
    static let squareSize: Double = 60.0        // size for square
    static let squareScore: Int = 10
    static let fadeInDuration: Double = 0.10    // duration for fade in animation
    static let fadeOutDuration: Double = 0.05   // duration for fade out animation
    static let startDuration: Double = 4.0      // start duration to wait for a new object to draw
    static let timerInterval: Double = 1.0      // duration for game time = 1 second
    static let randomObjectProbability: Int = 10    // probabilty for a bonus object in procent
}

// properties for particle overlays

enum ObjectTouchParticle {
    static let circle: String = "ParticleFire"        // filename for particle overlay for a circle object
    static let square: String = "ParticleMagic"      // filename for particle overlay for a square object
    
}

enum Colors {
    static let circlecolor: UIColor = .brightgold
    static let squarecolor: UIColor = .brightcyan
    static let buttonbackground: Color = .limegreen
    static let levelupbackground: Color = .darkpink
    static let primarycolor: Color = .warmwhite
    static let backgroundcolor: Color = .darknight
}
