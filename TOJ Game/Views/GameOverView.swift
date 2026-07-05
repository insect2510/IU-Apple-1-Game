//
//  TOJ Game
//  GameOverView.swift
//
//  Created by Oliver Hartmann on 04.07.26.
//

import SwiftUI
import SpriteKit
import SwiftData




struct GameOverView: View {
    
   // @Query(sort: \Score.score, order: .reverse)
   // private var highScore: [Score]

   // @Environment(\.modelContext) var modelContext

    
    let score: Int
    let restartAction: () -> Void
    

    
    var body: some View {
        
        ZStack {
            Color.darkred
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // Game Over Text
                
                Text("GAME OVER")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.warmwhite)
                
                Text( "Your score: \(score)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.warmwhite)
                
            //  VStack {
            //         List {
            //              ForEach(highScore) { score in
            //                  HStack {
            //                    //  Text(score.name)
            //                      Spacer()
            //                      Text("\(score.score)")
            //                          .bold()
            //                          .foregroundColor(.black)
            //                  }
            //
            //              }
            //          }
            //      }
                
                
                // Show Restart Button
                
                Button("Nochmal spielen") {
                    
                    restartAction()
                    
                }
                .font(.system(size: 24, weight: .medium))
                .padding(24)
                .background(.darkcyan)
                .foregroundColor(.warmwhite)
                
            }
        }
    }
}

//#Preview {
//   GameOverView(score: 331, restartAction: restartGame())
//}
