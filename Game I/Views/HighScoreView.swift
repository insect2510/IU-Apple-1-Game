//
//  ContentView.swift
//  Gametest
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SwiftUI
import SwiftData

struct HighScoreView: View {
    
    @Query  var scores: [Score]

    var body: some View {
        List {
            ForEach(scores) { score in
                Text(score.name)
            }
        }
    }
}

#Preview {
    HighScoreView()
        .modelContainer(for:
                        Score.self,
                        inMemory: true)
}
