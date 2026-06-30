//
//  GameScene.swift
//  Gametest
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SpriteKit

class GameScene: SKScene {
    
    // Duratian at the start of the game in seconds
    var duration = 3.0
  
    
    // Timer
    var timerLabel = SKLabelNode(text: "01:00")
    var timeRemaining = 60
    var gameIsOver = false
    
    // Games Lifes
    var gameLifes = 3
    var gameLifesLabel = SKLabelNode(text: "Lifes: 3")
    
    
    // Score label
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var score = 0
                      
    // Restart
    var restartLabel: SKLabelNode?
    let buttonSize = CGSize(width: 220, height: 60)
    
    // Circle or Rectangle
    var randomObjectValue = Int.random(in: 1...100)
    var objectType = "circle"
    let fadeDuration = 0.1
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .darknight
        
        // Timer Text Setup
        timerLabel = SKLabelNode(fontNamed: "Helvetica")
        timerLabel.fontSize = 20
        timerLabel.fontColor = .grey
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.verticalAlignmentMode = .top
        timerLabel.position = CGPoint(x: frame.maxX - 20, y: frame.maxY - 32)
        timerLabel.text = "01:00"
        addChild(timerLabel)
        startTimer()
        
        
        // Game Lifes text
        gameLifesLabel = SKLabelNode(fontNamed: "Helvetica")
        gameLifesLabel.fontSize = 20
        gameLifesLabel.fontColor = .grey
        gameLifesLabel.horizontalAlignmentMode = .center
        gameLifesLabel.verticalAlignmentMode = .top
        gameLifesLabel.position = CGPoint(x: frame.midX + 10, y: frame.maxY - 32 )
        gameLifesLabel.text = "Lifes: \(gameLifes)"
        addChild(gameLifesLabel)
        
 
        // Score Text Setup
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .grey
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 20, y: frame.maxY - 32)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        drawObject(objectType: objectType)
    }
    
    
    // Start Timer
    func startTimer() {
        let counddown = SKAction.sequence ([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                
                guard let self = self else { return }
                
                if self.gameIsOver { return }
                
                self.timeRemaining -= 1
                self.updateTimerLabel()
                
                if self.timeRemaining == 0 {
                    self.endGame()
                }
            }
    ])
        run(SKAction.repeatForever(counddown), withKey: "gameTimer")
    }
    
    
    // Update Timer Text
    func updateTimerLabel() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    
    
    
    // Draw a circle with random coordinates
    func drawObject(objectType: String) {
        
        
        // draw circle or square
        let object: SKShapeNode
        
        if objectType == "circle" {
            object = SKShapeNode(circleOfRadius: 30)
            object.fillColor = .warmwhite
            object.position = randomPoint()
        } else  {
           object = SKShapeNode(rectOf: CGSize(width: 50, height: 50),
                                     cornerRadius: 0)
            object.fillColor = .gold
            object.strokeColor = .clear
            object.position = randomPoint()

        }
        
        // add gaming object to the view
        object.name = "object"
        addChild(object)
        
        // set duration for object display
        object.run(SKAction.sequence([
             SKAction.wait(forDuration: duration),
             SKAction.fadeOut(withDuration: fadeDuration),
             SKAction.removeFromParent(),
             SKAction.run { [weak self] in
                 guard let self = self else { return }
                 
                 
        // subtract 1 life if no touch on the object has been detected
                 self.gameLifes -= 1
                 gameLifesLabel.text = "Lifes: \(gameLifes)"
                 
        // end game if lifes = 0
                 
                 if gameLifes <= 0 {
                     self.endGame()
                     
                 } else {
                     
                     self.randomObject()
                 }

             }
         ]))
    }
    
    // Remove old object before drawing new object
    func removeObject() {
 
        enumerateChildNodes(withName: "object") { (object, _) in
        object.removeAllActions()

        let fade = SKAction.fadeOut(withDuration: self.fadeDuration)
        let remove = SKAction.removeFromParent()
        object.run(SKAction.sequence([
            fade,
            remove]))
            
        }
    }
    
    

    // get random values for coordinates
    func randomPoint() -> CGPoint {
        let x = CGFloat.random(in: 50...frame.width - 50)
        let y = CGFloat.random(in: 100...frame.height - 100)
        return CGPoint(x: x, y: y)
    }
    
    // Game Play
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        for node in nodes {
            if node.name == "restart" {
                restartGame()
                return
            }
        }
        
        if gameIsOver { return }
    
        // update score and check for new duration
        for node in nodes {
            if node.name == "object" {
                if objectType == "circle" {
                    score += 1 } else {
                        score += 10
                    }
            
                if score >= 10 {
                    duration = 2.0
                }
                if score >= 20 {
                    duration = 1
                }
                
                if score >= 30 {
                    duration = 0.5
                }
                
                if score >= 50 {
                    duration = 0.3
                }
                
                scoreLabel.text = "Score: \(score)"
                
                removeObject()
                
                randomObject()
               
            }
        }
    }
    
    
    // ramdomly choose circle or square for object tyoe
    func randomObject() {
        
        randomObjectValue = Int.random(in: 1...100)
        
        if randomObjectValue <= 90 {
           objectType = "circle"
        } else {
            objectType = "square"
        }
        
        drawObject(objectType: objectType)
        
    }
    
    
    
    // End Game
    func endGame() {
        
        gameIsOver = true

        backgroundColor = .darkred
        
        
        // call remove objects function
        removeObject()
        
        
        // Game Over Text
       let gameOver = SKLabelNode(text: "GAME OVER")
        gameOver.fontName = "Helvectica-Bold"
        gameOver.fontSize = 36
        gameOver.fontColor = .warmwhite
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOver)
        
        let yourScore = SKLabelNode(text: "Your score: \(score)")
        yourScore.fontName = "Helvectica-Bold"
        yourScore.fontSize = 24
        yourScore.fontColor = .warmwhite
        yourScore.position = CGPoint(x: frame.midX, y: frame.midY - 36)
        addChild(yourScore)
        
        
        // Show Restart Button
        let restartButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 12)
        restartButton.fillColor = .darkcyan
        restartButton.strokeColor =  .clear
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY - 80)
        restartButton.name = "restart"
        restartButton.zPosition = 10
        addChild(restartButton)
        
        // Show Restart Text inside Button
        let restartLabel = SKLabelNode(text: "Nochmal spielen")
        restartLabel.fontName = "Helvectica-SemiBold"
        restartLabel.fontSize = 24
        restartLabel.fontColor = .warmwhite
        restartLabel.verticalAlignmentMode = .center
        restartLabel.horizontalAlignmentMode = .center
        restartLabel.position = CGPoint(x: 0, y: 0)
        restartButton.addChild(restartLabel)
            
    }

    
    // restart the game
    func restartGame() {
        guard let view = self.view else { return }
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        view.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
