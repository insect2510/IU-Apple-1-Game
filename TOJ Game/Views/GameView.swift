//
//  TOJ Game
//  GameView.swift
//  GameView
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SwiftUI
import SpriteKit
import SwiftData

struct GameView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var sceneID: UUID = UUID()
    @State private var gameIsOver = false
    @State private var isGaming = false
    @State private var finalScore = 0
    @State private var finalLevel = 1
    
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
                        
                        Text("Level: \(gameData.level)")
                        
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
                GameOverView(score: finalScore, level: finalLevel, restartAction: restartGame)
                    .id(gameData.score)
            }
        }
        

      /*  .onChange(of: gameIsOver) {_, newValue in
            
            if newValue {
                let newScore = Highscore(
                    name: "Oliver",
                    points: finalScore,
                    level: finalLevel
                )
                
                modelContext.insert(newScore)
                
                do {
                    try modelContext.save()
                    
                    print("Gespeichert")
                    print(newScore.name)
                    print(newScore.points)
                    print(newScore.level)
                    
                    let descriptor = FetchDescriptor<Highscore>()
                    let result = try modelContext.fetch(descriptor)
                    
                    print("Direkt gefunden:", result.count)
                    
                    for item in result {
                        print(item.name, item.points, item.level)
                    }
                    
                } catch {
                    print(error)
                }
                
                
            }
            
        }
       */
    }
    
    
    
    // restarts the game
    func restartGame() {
                
       let newScene = GameScene(
            size: self.scene.size,
            gameData: gameData
        )
        
        newScene.scaleMode = .resizeFill
        
        newScene.gameOverHandler = { finalScore, finalLevel in
            
            DispatchQueue.main.async {
                
               /* finalScore = score
                finalLevel = level
                
                gameIsOver = true
                isGaming = false*/
                
                let newScore = Highscore(
                    name: "Oliver",
                    points: finalScore,
                    level: finalLevel
                )
                
                modelContext.insert(newScore)
                
                do {
                    try modelContext.save()
                    
                    print("Gespeichert")
                    print(newScore.name)
                    print(newScore.points)
                    print(newScore.level)
                    
                    let descriptor = FetchDescriptor<Highscore>()
                    let result = try modelContext.fetch(descriptor)
                    
                    print("Direkt gefunden:", result.count)
                    
                    for item in result {
                        print(item.name, item.points, item.level)
                    }
                    
                } catch {
                    print(error)
                }
                
                self.finalScore = finalScore
                self.finalLevel = finalLevel
                
                gameIsOver = true
                isGaming = false
                
                
               
            }
        }
        
        
        // Reset game data values

        gameData.score = 0
        gameData.lives = 3
        gameData.timeRemaining = 60
        gameData.level = 1
        
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

}

#Preview {
    GameView()
}
