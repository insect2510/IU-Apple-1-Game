//
//  HighScoreView 2.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 05.07.26.
//

/*

import SwiftUI
import SwiftData

struct HighScoreView: View {
    
    // @Query  var highScore: [Score]
    @Query(sort: \Score.score, order: .reverse)
    private var highScore: [Score]
    
    @Environment(\.modelContext) var modelContext

    var body: some View {
      NavigationStack {
            List {
                ForEach(highScore) { score in
                    HStack {
                      //  Text(score.name)
                        Spacer()
                        Text("\(score.score)")
                            .bold()
                    }
      
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let highScoreNew = Score(score: 123)
                        modelContext.insert(highScoreNew)
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
*/
