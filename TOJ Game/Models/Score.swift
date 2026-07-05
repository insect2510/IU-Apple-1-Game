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
    
    var name: String
    var points: Int
    
    init(name: String, points: Int) {
        self.name = name
        self.points = points
    }
    
}

extension Highscore {
    static let sampleData = [

       Highscore(name: "Oliver", points: 10),
       Highscore(name: "Marco", points: 100),
       Highscore(name: "Janet", points: 321),
        
    ]
}


