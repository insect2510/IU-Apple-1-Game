//
//  TOJ Game
//  GameScene.swift
//  GameScene
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SpriteKit
import AudioToolbox
import SwiftUI


class GameScene: SKScene {
    
    // MARK: Setup
    
    var gameData: GameData
    
    init(size: CGSize, gameData: GameData) {
        self.gameData = gameData
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // gameOverHandller
    
    var gameOverHandler: ((Int, Int) -> Void)?
    
    // Duratian at the start of the game in seconds
    
    var duration = 4.0
    var gameIsOver = false
    
    // Timer
    
    var gameTime: Timer?

    // Circle or Rectangle
    
    var randomObjectValue = Int.random(in: 1...100)
    var objectType = "circle"
    let fadeDuration = 0.1

    // particles
    
    var particleFileName = "ParticleFire"
    var soundId:SystemSoundID = 0
    
    override func didMove(to view: SKView) {
        
        // background color for scene
        
        backgroundColor = .darknight
        
        // Timer Setup
        
        startTimer()
        drawObject(objectType: objectType)
    }
    
    
    // Start Timer
    
    func startTimer() {
        
        gameTime?.invalidate()
        
        gameTime = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        )
        { [weak self] timer in
            
            guard let self else { return }
            
            if self.gameIsOver {
                timer.invalidate()
                return
            }
            self.gameData.timeRemaining -= 1
            if self.gameData.timeRemaining == 0 {
                self.endGame()
            }
        }
    }

    
    //MARK:  Draw a circle with random coordinates
    
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
             SKAction.scale(by: 0.1, duration: fadeDuration),
             SKAction.fadeOut(withDuration: fadeDuration),
    
             
             SKAction.run { [weak self] in
                 
                 guard let self = self else { return }
                 
                 // remove one  life if no touch on the object has been detected
                 
                 self.gameData.lives -= 1
                 

                 
                 // check Game Over
                 
                 if self.gameData.lives <= 0 {
                     self.endGame()
                     
                 } else {
                     
                     // play audio file
                     
                     AudioServicesPlaySystemSound(GameSound.missTouch)
                     
                     self.randomObject()
                 }

             },
             SKAction.removeFromParent()
         ]))
    }
    
    // MARK: Remove old object before drawing new object
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
    
    
    // MARK:  get random values for coordinates
    func randomPoint() -> CGPoint {
        let x = CGFloat.random(in: 50...frame.width - 50)
        let y = CGFloat.random(in: 100...frame.height - 200)
        return CGPoint(x: x, y: y)
    }
    
    //MARK: Game Play
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        if gameIsOver { return }
    
        // update score and check for new duration
        for node in nodes {
            if node.name == "object" {
                if objectType == "circle" {
                    self.gameData.score += 1 } else {
                        self.gameData.score += 10
                    }
            
                if   gameData.score >= 15 {
                    duration = 3.0
                    gameData.level = 2
                }
                
                if   gameData.score >= 30 {
                    duration = 2.0
                    gameData.level = 3
                }
                
                if  gameData.score >= 50 {
                    duration = 1.0
                    gameData.level = 4
                }
                
                
                // animation after touching
                
                // particle animation
                // for square object
                if objectType == "square" {
                    
                    particleFileName = "ParticleMagic"
                    soundId = GameSound.square
                }
                // for cirlce object
                else if objectType == "circle" {
                    
                    particleFileName = "ParticleFire"
                    soundId = GameSound.circle

            }
                // start particle anmiation based on object type
                if let particles = SKEmitterNode(fileNamed: particleFileName) {
                particles.position = node.position
                
                // add audio
                AudioServicesPlaySystemSound(SystemSoundID(soundId))
                
                // add particle
                addChild(particles)
                    
                // wait and remove particle node
                let removeParticle = SKAction.sequence([SKAction.wait(forDuration: 2),
                                                        SKAction.removeFromParent()])
                particles.run(removeParticle)
            }
                
                
                // object fade out animation
                let scaleUp = SKAction.scale(to: 1.5, duration: fadeDuration / 2)
                let fadeOut = SKAction.fadeOut(withDuration: fadeDuration / 2)
                let remove = SKAction.removeFromParent()
                node.run(SKAction.sequence([scaleUp, fadeOut, remove]))
                
                // calls a new object to draw
                randomObject()
               
            }
        }
    }
    
    
    //MARK: ramdomly choose circle or square for object type
    func randomObject() {
        
        randomObjectValue = Int.random(in: 1...100)
        
        if randomObjectValue <= 90 {
           objectType = "circle"
        } else {
            objectType = "square"
        }
        
        drawObject(objectType: objectType)
        
    }
    
    
    //MARK: end of the game
    func endGame() {
        
        gameIsOver = true
        
        gameTime?.invalidate()
        
       // AudioServicesPlaySystemSound(self.soundIdGameOver)
        
        // call remove all objects function
        removeObject()
        gameOverHandler?(gameData.score, gameData.level)

    }

}
