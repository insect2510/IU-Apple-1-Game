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
    
    @StateObject private var gameData: GameData
    
    @State private var scene: GameScene
    
    init() {
        let data = GameData()
        
        _gameData = StateObject(
            wrappedValue: data
        )
        
        let newScene = GameScene(
            size: UIScreen.main.bounds.size,
            gameData: data
        )
        
        newScene.scaleMode = .resizeFill
        
        _scene = State(
            initialValue: newScene
        )
    }
    

    var body: some View {
        
        ZStack {
            
            if !isGaming {
                GameStartView(restartAction: restartGame)
            }
            
            if isGaming {
                ZStack (alignment:.top){
                    
                    SpriteView(scene: scene)
                       // .id(sceneID)
                        .ignoresSafeArea()
                    
                    
                    HStack {
                        Text("Score: \(gameData.score)")
                        
                        Spacer()
                        
                        Text("Lives: \(gameData.lives)")
                        
                        Spacer()
                        
                        Text(formatTime(gameData.timeRemaining))
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .frame(height: 80)
                    .background(LinearGradient(colors: [.lightnight, .darknight], startPoint: .top, endPoint: .bottom))

                }

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
        
        gameData.score = 0
        gameData.lives = 3
        gameData.timeRemaining = 60
        
       let newScene = GameScene(
            size: self.scene.size,
            gameData: gameData
        )
        
        newScene.scaleMode = .resizeFill
        
        newScene.gameOverHandler = { finalScore in
            DispatchQueue.main.async {
                
                let newScore = Score(
                    score: finalScore
                )
                
                modelContext.insert(newScore)
                
                score = finalScore
                gameIsOver = true
                isGaming = false
            }
        }
        
        
        
        scene = newScene

        gameIsOver = false
        isGaming = true

        
    }
    
    func formatTime(_ seconds:Int) -> String {
        
        String(
            format:"%02d:%02d",
            seconds / 60,
            seconds % 60
            )
    }
    
    // makes a new scene
   // func makeScene() -> GameScene {
   //     let scene = GameScene()
   //     scene.scaleMode = .resizeFill
   //     return scene
   // }
    
    
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
                isGaming = false
            }
        }
            
    }

}

#Preview {
    GamePlayView()
}
