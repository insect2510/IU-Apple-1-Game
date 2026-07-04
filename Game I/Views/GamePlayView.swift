//
//  GamePlayView.swift
//  GamePlayView
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SwiftUI
import SpriteKit

struct GamePlayView: View {
    
    @State private var sceneID: UUID = UUID()
    @State private var gameIsOver = false
    @State private var score = 0

    
    @State private var scene: GameScene = {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 533)
        scene.scaleMode = .aspectFit
        return scene
    }()
    

    var body: some View {
        
        ZStack {
            
            SpriteView(scene: scene)
                .id(sceneID)
                .ignoresSafeArea()
            
            if gameIsOver {
                GameOverView(score: score, restartAction: restartGame)
            }
        }
        
        .onAppear {
            scene.gameOverHandler = { finalScore in
                score = finalScore
            gameIsOver = true}
        }
        

    }
    
    func restartGame() {
        
        scene.gameOverHandler = { finalScore in
            score = finalScore
            gameIsOver = true
        }
        gameIsOver = false
        score = 0
        sceneID = UUID()
        scene = makeScene()
        
    }
    
    func makeScene() -> GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 533)
        scene.scaleMode = .aspectFit
        return scene
    }

}

#Preview {
    GamePlayView()
}
