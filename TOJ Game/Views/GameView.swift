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
    
    @State private var isNewHighScore = false
    
    @Query(sort: \Highscore.points, order: .reverse)
    private var highScore: [Highscore]
    
    
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
    
    //MARK: main view
    
    var body: some View {
        
        ZStack {
            
            if !isGaming {
                GameStartView(restartAction: restartGame)
                
                
                if gameIsOver {
                    GameOverView(score: finalScore,
                                 level: finalLevel,
                                 isNewHighScore: isNewHighScore,
                                 restartAction: restartGame)
                        .id(gameData.score)
                }
            }
            
            if isGaming {
                ZStack (alignment:.top){
                    
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                    
                    
                    HStack {
                        Text("Score: \(gameData.score)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        

                        Text("Lives: \(gameData.lives)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        

                        
                        Text("Level: \(gameData.level)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        
                        
                        Text(formatTime(gameData.timeRemaining))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .font(.system(.title3, weight: .light))
                    .foregroundColor(.white)
                    .padding()
                    .frame(height: 80)
                    .background(LinearGradient(colors: [.lightnight, .darknight], startPoint: .top, endPoint: .bottom))
                    
                }
            }
            

        }
    
    }
    
    
    
    //MARK: restarts the game
    
    func restartGame() {
        
        isNewHighScore = false
                
       let newScene = GameScene(
            size: self.scene.size,
            gameData: gameData
        )
        
        newScene.scaleMode = .resizeFill
        
        newScene.gameOverHandler = { finalScore, finalLevel in
            
            DispatchQueue.main.async {
                
                // create new highscore object
                
                let topScores = highScore.prefix(5)
                
                let qualifies = topScores.count < 5 || finalScore > (topScores.last?.points ?? 0)
                
                if qualifies {
                    
                    isNewHighScore = true
                    
                    // delete old rank 5 before inserting
                    
                    if highScore.count >= 5 {
                        
                        if let lowestScore = highScore.last {
                            modelContext.delete(lowestScore)
                            
                            // print deleted values to console while testing
                            
                            print("Deleted:")
                            print(lowestScore.points)
                        }
                    }
                    
                    let newScore = Highscore(
                        name: "Oliver",
                        points: finalScore,
                        level: finalLevel
                    )
                    
                    // inser new highscore object
                    
                    modelContext.insert(newScore)
                    
                    
                    // save data model with new highscore
                    
                    do {
                        
                        try modelContext.save()
                        
                        // print values to console while testing
                        
                        print("Gespeichert")
                        print(newScore.name)
                        print(newScore.points)
                        print(newScore.level)
                        
                        // reload data model and print values to console while testing
                        
                        let descriptor = FetchDescriptor<Highscore>()
                        let result = try modelContext.fetch(descriptor)
                        
                        print("Direkt gefunden:", result.count)
                        
                        for item in result {
                            print(item.name, item.points, item.level)
                        }
                        
                    // catch errors
                        
                    } catch {
                        print(error)
                        
                    }
                }   else {
                        isNewHighScore = false
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
    
    
    // format time into string
    
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
