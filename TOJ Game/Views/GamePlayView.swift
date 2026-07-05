//
//  TOJ Game
//  GamePlayView.swift
//  GamePlayView
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SwiftUI
import SpriteKit
import SwiftData

struct GamePlayView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var sceneID: UUID = UUID()
    @State private var gameIsOver = false
    @State private var score = 0
    @State private var isGaming = false

    
    @State private var scene: GameScene = {
        let scene = GameScene()
        // scene.size = CGSize(width: 300, height: 533)
       scene.scaleMode = .resizeFill
        return scene
    }()
    

    var body: some View {
        
        ZStack {
            
            if !isGaming {
                GameStartView(restartAction: restartGame)
            }
            
            if isGaming {
                SpriteView(scene: scene)
                    .id(sceneID)
                    .ignoresSafeArea()
            }

            
            if gameIsOver {
                GameOverView(score: score, restartAction: restartGame)
            }
        }
        
        .onAppear {
            setupScene()
        }
        
    }
    
    
    // restarts the game with unique scene id
    func restartGame() {
        gameIsOver = false
        score = 0
        sceneID = UUID()
        scene = makeScene()
        setupScene()
        isGaming = true
        
    }
    
    
    // makes a new scene
    func makeScene() -> GameScene {
        let scene = GameScene()
        // scene.size = CGSize(width: 300, height: 533)
        scene.scaleMode = .resizeFill
        return scene
    }
    
    
    // sync GameScene with Game Over handler
    func setupScene() {
        scene.gameOverHandler = { finalScore in
            DispatchQueue.main.async {
                
                let newScore = Score (
                    // name: "Oliver",
                    score: finalScore
                )
                
                modelContext.insert(newScore)
                score = finalScore
                gameIsOver = true
            }
        }
            
    }

}

#Preview {
    GamePlayView()
}
