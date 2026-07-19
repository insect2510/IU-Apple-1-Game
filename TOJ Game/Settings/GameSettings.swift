//
//  GameSettings.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 10.07.26.
//

import Foundation
import AudioToolbox
import SwiftUI
import SpriteKit

// sound ids

enum GameSound {
    
    static let circle: SystemSoundID = 1052     // normal touch
    static let square: SystemSoundID = 1007     // bonus touch
    
    static let levelUp: SystemSoundID = 1016    // level up information
    
    static let missTouch: SystemSoundID = 1000  // touch missed
    
    static let top5Missed: SystemSoundID = 1021       // game over
    static let top5: SystemSoundID = 1025  // game over new highscore
    
}


// properties for animation of the gaming objects

enum ObjectAnimation {
    
    static let fadeInDuration: Double = 0.10    // duration for fade in animation
    static let fadeOutDuration: Double = 0.05   // duration for fade out animation
    static let startDuration: Double = 4.0      // start duration to wait for a new object to draw
    static let timerInterval: Double = 1.0      // duration for game time = 1 second
}

// color settings

enum Colors {
    static let circlecolor: UIColor = .brightgold
    static let squarecolor: UIColor = .brightcyan
    static let buttonbackground: Color = .limegreen
    static let levelupbackground: Color = .darkpink
    static let primarycolor: Color = .warmwhite
    static let backgroundcolor: Color = .darknight
}


// highscore settings

enum Highscore {
    
    enum Top5 {
        static let text: String = "Congrats, you made it into the TOP5!"    // Text for new highscore
        static let sound = GameSound.top5                                   // sound new highscore
    }
    
    enum Missed {
        static let text: String = "Sorry, you didn't make it in the TOP5!"    // Text top5 missed
        static let sound = GameSound.top5Missed                               //sound top5 missed
    }
}

// types of gaming objects

enum ObjectType {
    case circle
    case square
}



enum GamingObject {
    
    enum Circle {
        static let fillcolor = Colors.circlecolor       // color for circle
        static let size: Double  = 30.0                 // size for circle
        static let score: Int = 1                       // score for circle
        static let sound = GameSound.circle             // sound for circle
        static let particle: String = "ParticleFire"    // filename for particle overlay for a circle
    }
    
    enum Square {
        static let fillcolor = Colors.squarecolor        // color for square
        static let size: Double  = 50.0                  // size for square
        static let score: Int = 10                       // score for square
        static let sound = GameSound.square              // sound for circle
        static let particle: String = "ParticleMagic"    // filename for particle overlay for a circle
    }
    
    static let randomObjectProbability: Int = 10        // probabilty for square object in procent
}
