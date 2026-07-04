//
//  GameOverView.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 04.07.26.
//

import SwiftUI
import SpriteKit


struct GameOverView: View {
    
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
//    GameOverView(score: 331, restartAction: restartGame())
//}
