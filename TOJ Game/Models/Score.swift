//
//  Highscore.swift
//  TOJ Game
//
//  Created by Oliver Hartmann on 28.06.26.
//

import Foundation
import SwiftData

@Model
class Highscore {
    
    var name: String = ""
    var points: Int = 0
    var level: Int = 1
    
    init(name: String, points: Int, level: Int) {
        self.name = name
        self.points = points
        self.level = level
    }
    
}
