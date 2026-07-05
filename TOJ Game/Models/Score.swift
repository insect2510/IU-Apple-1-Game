//
//  Highscore.swift
//  TOJ Game
//
//  Created by Oliver Hartmann on 28.06.26.
//

import Foundation
import SwiftData

@Model
final class Score {
    
    @Attribute(.unique) var id = UUID()
   // var name: String
    var score: Int
    
    init(score: Int) {
       // self.name = name
        self.score = score
    }
    
}

extension Score {
    static let sampleData = [
        Score(score: 10),
        Score(score: 20),
      //  Score(name: "Oliver", score: 10),
      //  Score(name: "Marco", score: 100),
      //  Score(name: "Janet", score: 321),
        
    ]
}


