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
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(scores) { score in
                    Text(score.name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let scoreNew = Score(name: "Dummy", score: 123)
                        modelContext.insert(scoreNew)
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
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
