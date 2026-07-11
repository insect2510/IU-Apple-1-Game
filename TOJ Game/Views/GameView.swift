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
    
    @State private var randomPosition: [CGPoint] = []
    @State private var animatedBackground = false
    
    @State private var showLevelUp = false
    
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
        
        GeometryReader { geometry in
            
            ZStack {
                
                Color.darknight
                    .ignoresSafeArea()
                
                //MARK: random squares in the background
                
                ForEach(
                    randomPosition.indices,
                    id: \.self
                    
                ) { index in
                    
                    Rectangle()
                        .fill(.gold.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                       // .position(randomPosition[index]
                        
                        .position(
                            CGPoint(
                                x: randomPosition[index].x,
                                y: randomPosition[index].y
                                + (animatedBackground ? 20: -20)
                            )
                        )
                    
                        // start animation
                            
                        .animation(
                            .easeInOut(
                                duration: Double.random(
                                    in: 5...10
                                )
                            )
                        
                            .repeatForever(
                            autoreverses: true
                            ),
                            value: animatedBackground
                    )
                }
                
                
                //MARK: Game Start
                
                if gameIsOver {
                    GameOverView(score: finalScore,
                                 level: finalLevel,
                                 isNewHighScore: isNewHighScore,
                                 restartAction: restartGame)

                    
                } else if !isGaming {
                    
                    GameStartView(
                        restartAction: restartGame
                    )
                }
                
                //MARK: gaming
                
                else {
                    
                    ZStack (alignment:.top){
                        
                        SpriteView(scene: scene
                                   , options: [.allowsTransparency])
                            .ignoresSafeArea()
                        
                        // Game Header
                        
                        HStack {
                            
                            Label(
                                "\(gameData.score)",
                                systemImage: "star.fill"
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            
                            Label(
                                "\(gameData.lives)",
                                systemImage: "heart.fill"
                            )
                            .frame(
                                width: 60
                            )
                            
                            Label(
                                "\(gameData.level)",
                                systemImage: "bolt.fill"
                            )
                            
                            .frame(
                                width: 60
                            )
                            
                            
                            Text(formatTime(gameData.timeRemaining))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        
                        .font(
                            .system(
                                .title3,
                                weight: .light
                            )
                        )
                        .foregroundColor(.warmwhite)
                        .padding(.horizontal, 20)
                        .frame(height: 80)
                        .background(
                            LinearGradient(
                                colors: [
                                    .lightnight,
                                    .darknight
                                ],
                                startPoint: .top,
                                endPoint: .bottom))
                    }
                }
                
                
                //MARK: show new level with animation
                
                if showLevelUp {
                    Text("LEVEL \(gameData.level)")
                        .font(
                            .system(
                                .largeTitle,
                                weight: .medium
                            )
                        )
                        .tracking(6)
                        .foregroundColor(.warmwhite)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(
                            Capsule()
                                .fill(.darkred)
                            )
                    
                        .scaleEffect(showLevelUp ? 1.2 : 0.5)
                        .opacity(showLevelUp ? 1 : 0)
                        .transition(.scale)
                        .zIndex(100)
                }
                
            }
            
            
            //MARK: check if gameLevel has changed
            
            .onChange(of: gameData.level) { _, newLevel in

                if newLevel > 1 {
                    
                    withAnimation(
                        .spring(
                            response: 0.4,
                            dampingFraction: 0.5
                        )
                    ) {
                        showLevelUp = true
                    }
                    
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 0.7
                    ) {
                        withAnimation {
                            showLevelUp = false
                        }
                        
                    }
                }
            }
            
            .onAppear {
                
                // random position for background shapes
                
                randomPosition = (1...10).map { _ in
                    
                    CGPoint(
                        x: CGFloat.random(
                            in: 50...(geometry.size.width - 50)
                        ),
                        y: CGFloat.random(
                            in: 100...(geometry.size.height - 100)
                        )
                    )
                
                }
                
                // trigger delay for animation
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                {
                    animatedBackground = true
                }
                

 
            }
        }
    }
    
    //MARK: restart the game
    
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
                    
                    // insert new highscore object
                    
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
