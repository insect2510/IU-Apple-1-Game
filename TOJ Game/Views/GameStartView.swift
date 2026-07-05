//
//  TOJ Game
//  GameStartView.swift
//
//  Created by Oliver Hartmann on 05.07.26.
//

import SwiftUI
import SpriteKit


struct GameStartView: View {
    
   // let score: Int
   let restartAction: () -> Void

    // game is not running
    var isGaming: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.darkred
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // Display game name
                
                Text("TOJ")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.warmwhite)
                Text("Touch the object")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.warmwhite)
                
                
                // show start button
                
                Button("Start Game") {
                    
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
//   GameStartView()
//}
