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
            setupScene()
        }
        
    }
    
    func restartGame() {
        
        gameIsOver = false
        score = 0
        sceneID = UUID()
        scene = makeScene()
        setupScene()
        
    }
    
    func makeScene() -> GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 533)
        scene.scaleMode = .aspectFit
        return scene
    }
    
    func setupScene() {
        
        scene.gameOverHandler = { finalScore in
            DispatchQueue.main.async {
                score = finalScore
            gameIsOver = true
            }}
            
    }

}

#Preview {
    GamePlayView()
}
