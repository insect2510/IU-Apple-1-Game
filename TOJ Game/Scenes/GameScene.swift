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
    
    var duration = ObjectData.startDuration
    var gameIsOver = false
    
    // Timer
    
    var gameTime: Timer?
    
    // Circle or Rectangle
    
    var randomObjectValue = Int.random(in: 1...100)
    
    private var objectType: ObjectType = ObjectType.circle
    
    override func didMove(to view: SKView) {
        
        // background clear for scene
        
        backgroundColor = .clear
        
        // Timer Setup
        
        startTimer()
        drawObject(objectType: objectType)
    }
    
    
    // Start Timer
    
    func startTimer() {
        
        gameTime?.invalidate()
        
        gameTime = Timer.scheduledTimer(
            withTimeInterval: ObjectData.timerInterval,
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
    
    func drawObject(objectType: ObjectType) {
        
        
        // draw circle or square
        
        let object: SKShapeNode
        
        switch objectType {
            
        case ObjectType.circle:
            object = SKShapeNode(circleOfRadius: ObjectData.circleRadius)
            object.fillColor = .warmwhite
            object.position = randomPoint()
            
        case ObjectType.square:
            object = SKShapeNode(rectOf: CGSize(width: ObjectData.squareSize, height: ObjectData.squareSize),
                                 cornerRadius: 0)
            object.fillColor = .gold
            object.strokeColor = .clear
            object.position = randomPoint()
            
        }
        
        
        // add gaming object to the view
        
        object.name = "object"
        object.alpha = 0
        object.setScale(0.1)
        addChild(object)
        
        // Fade in animation
        
        let fadeIn = SKAction.fadeIn(withDuration: ObjectData.fadeInDuration)
        let scaleUp = SKAction.scale(to: 1, duration: ObjectData.fadeInDuration)
        scaleUp.timingMode = .easeOut
        
        object.run(SKAction.group([fadeIn, scaleUp]))
        
        
        // set duration for object display and fade out
        
        object.run(SKAction.sequence([
            SKAction.wait(forDuration: duration),
            SKAction.scale(by: 0.1, duration: ObjectData.fadeOutDuration),
            SKAction.fadeOut(withDuration: ObjectData.fadeOutDuration),
            
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
            
            let fade = SKAction.fadeOut(withDuration: ObjectData.fadeOutDuration)
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
        
        var particleFileName = ObjectTouchParticle.standard
        var soundId: SystemSoundID = GameSound.circle
        
        if gameIsOver { return }
        
        // update score and check for new duration
        for node in nodes {
            
            if node.name == "object" {
                
                
                // animation after touching
                
                switch objectType {
                    
                    // for circle
                    
                case ObjectType.circle:
                    gameData.score += 1
                    particleFileName = ObjectTouchParticle.standard
                    soundId = GameSound.circle
                    
                    // for square
                    
                case ObjectType.square:
                    gameData.score += 10
                    particleFileName = ObjectTouchParticle.bonus
                    soundId = GameSound.square
                    
                }
                
                
                // sound after touching
                
                let didLevelUp =  checkLevelUp()
                
                // add audio
                
                AudioServicesPlaySystemSound(
                    didLevelUp ? GameSound.levelUp : soundId)
                
                
                // start particle anmiation based on object type
                
                if let particles = SKEmitterNode(fileNamed: particleFileName) {
                    particles.position = node.position
                    
                    
                    // add particle
                    
                    addChild(particles)
                    
                    // wait and remove particle node
                    
                    let removeParticle = SKAction.sequence([SKAction.wait(forDuration: 2),
                                                            SKAction.removeFromParent()])
                    particles.run(removeParticle)
                }
                
                
                // object fade out animation
                
                let scaleUp = SKAction.scale(to: 1.5, duration: ObjectData.fadeOutDuration)
                let fadeOut = SKAction.fadeOut(withDuration: ObjectData.fadeOutDuration)
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
        
        if randomObjectValue <= ObjectData.randomObjectProbability {
            objectType = ObjectType.circle
        } else {
            objectType = ObjectType.square
        }
        
        drawObject(objectType: objectType)
        
    }
    
    
    //MARK: end of the game
    
    func endGame() {
        
        gameIsOver = true
        
        gameTime?.invalidate()
        
        // call remove all objects function
        removeObject()
        gameOverHandler?(gameData.score, gameData.level)
        
    }
    
    
    //MARK: check level up
    
    func checkLevelUp() -> Bool {
        
        switch gameData.score {
            
        case 80... where gameData.level < 4:
            duration = 1.0
            gameData.level = 4
            return true
            
        case 50... where gameData.level < 3:
            duration = 2.0
            gameData.level = 3
            return true
            
        case 20... where gameData.level < 2:
            duration = 3.0
            gameData.level = 2
            return true
            
        default: return false
        }
    }
    
}
