//
//  Highscore.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 28.06.26.
//

import Foundation
import SwiftData

@Model
class Score {
    
    var name: String
    var score: Int
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
    
}

extension Score {
    static let sampleDate = [
        Score(name: "Oliver", score: 10),
        Score(name: "Marco", score: 100),
        Score(name: "Janet", score: 321),
        
    ]
}


