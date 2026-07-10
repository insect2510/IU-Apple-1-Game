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
    
    
    // MARK: game start view
    
    var body: some View {
        
        ZStack {
            Color.darknight
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // Display game name
                
                Text("TOJ")
                    .font(.system(.largeTitle, weight: .black))
                    .foregroundColor(.warmwhite)
                    .scaleEffect(1.5)

                Text("Touch the object")
                    .font(.system(.title, weight: .medium))
                    .foregroundColor(.warmwhite)
                
                
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
                            .fill(.darkcyan)
                        )
                    .foregroundColor(.warmwhite)
                    
                }
                
            }
        }
    }
}

//#Preview {
//   GameStartView(restartAction)
//}
