//
//  GameOverView.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 04.07.26.
//

import SwiftUI
import SpriteKit


struct GameOverView: View {
    var body: some View {
        
        ZStack {
            Color.darkred
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // Game Over Text
           
            Text("GAME OVER")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.warmwhite)
                
               // Text( "Your score: \(score)")
            Text("Your score: 123")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.warmwhite)
                
                
                // Show Restart Button
            
            Button("Nochmal spielen") {
                
                restartGame()
            }
            .font(.system(size: 24, weight: .medium))
            .padding(24)
            .background(.darkcyan)
            .foregroundColor(.warmwhite)
                
            }
        
        }
        
    }
}

#Preview {
    GameOverView()
}
