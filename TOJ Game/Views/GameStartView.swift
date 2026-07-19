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
    
   // @State private var randomPosition: [CGPoint] = []

    // game is not running
    var isGaming: Bool = false
    
    
    // MARK: game start view
    
    var body: some View {
            
            ZStack {
                
                VStack(spacing: 32) {
                    
                    // Display game name
                    
                    Text("TOJ")
                        .font(.system(.largeTitle, weight: .black))
                        .foregroundColor(Colors.primarycolor)
                        .scaleEffect(1.5)

                    Text("Touch the object")
                        .font(.system(.title, weight: .medium))
                        .foregroundColor(Colors.primarycolor)
                    
                    
                    // show start button
                    
                    Button {
                        restartAction()
                        
                    } label:  {
                        
                        Text("Start Play")
                        
                        .textCase(.uppercase)
                        .font(.system(.title3, weight: .light))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(.limegreen)
                            )
                        .foregroundColor(Colors.backgroundcolor)
                        
                    }
                }
        }
    }
}

//#Preview {
//   GameStartView(restartAction)
//}
