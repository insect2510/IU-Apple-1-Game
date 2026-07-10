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
    
  @Query(sort: \Highscore.points, order: .reverse)

    private var highScore: [Highscore]

 //  @Environment(\.modelContext) var modelContext

    
    let score: Int
    let level: Int
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
                
                Text("Your level: \(level)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.warmwhite)
                
              // show Top 5 Highscore
                
                VStack {
                    
                    Text("Top 5")
                    
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.black)
                    
                    List {
                        
                        HStack {
                            
                            Text("Name")
                                .bold()
                            
                            Spacer()
                            
                            Text("Score")
                                .bold()
                                 
                            Spacer()
                                 
                            Text("Level")
                                .bold()
                            
                        }
                        
                        ForEach(highScore.prefix(5)) { entry in
                            HStack {
                                Text(entry.name)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("\(entry.points)")
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("\(entry.level)")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .frame(height: 250)
                    
                    
                }
                

                
            
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

// #Preview {
//   GameOverView(score: 331, restartAction: restartGame())
// }
