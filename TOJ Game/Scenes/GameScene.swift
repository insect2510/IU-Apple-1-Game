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
    
    private var gameData: GameData
    
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
    
   private var duration = ObjectData.startDuration
   private var gameIsOver = false
    
    // Timer
    
    private var gameTime: Timer?
    
    // init object selection - always start with a circle
    
    private var randomObjectValue = 1
    private var objectType: ObjectType = ObjectType.circle
    
    
    override func didMove(to view: SKView) {
        
        // background clear for scene
        
        backgroundColor = .clear
        
        // Timer Setup
        
        startTimer()
        
        spawnObject()
    }
    
    // Start Timer
    
    private func startTimer() {
        
        gameTime?.invalidate()
        
        gameTime = Timer.scheduledTimer(
            withTimeInterval: ObjectData.timerInterval,
            repeats: true
        )
        { [weak self] timer in
            
            guard let self else { return }
            
            if gameIsOver {
                timer.invalidate()
                return
            }
            gameData.timeRemaining -= 1
            if gameData.timeRemaining == 0 {
                endGame()
            }
        }
    }
    
    
    //MARK:  spawn object with random coordinates
    
    private func spawnObject() {
        
        // random select object type
        
        objectType = randomObjectType()
        
        // draw circle or square
        
        let object = createObject(of: objectType)
        
        configureObject(object)
        
        // Fade in animation
        
        animateAppearance(of: object)
        
        // set duration for object display and fade out + delete
        
        scheduleRemoval(of: object)
    }
    
    
    // draw object
    
   private func createObject(
        
        of type: ObjectType
        
    )  -> SKShapeNode {
        
        let object: SKShapeNode
        
        switch type {
            
        case .circle:
            object = SKShapeNode(circleOfRadius: ObjectData.circleRadius)
            object.fillColor = Colors.circlecolor
            
        case .square:
            object = SKShapeNode(
                rectOf: CGSize(width: ObjectData.squareSize,
                               height: ObjectData.squareSize)
            )
            object.fillColor = Colors.squarecolor
            object.zRotation = .pi / 4 // Rotation 45 Grad
        }
        
        object.strokeColor = .clear
        
        return object
    }
    
    
    // add gaming object to the view
    
   private func configureObject(_ object: SKShapeNode) {
        
        object.position = randomPoint()
        object.name = "object"
        object.alpha = 0
        object.setScale(0.1)
        addChild(object)
    }
    
    // fade in animation
    
   private func animateAppearance(of object: SKShapeNode) {
        
        let fadeIn = SKAction.fadeIn(withDuration: ObjectData.fadeInDuration)
        let scaleUp = SKAction.scale(to: 1, duration: ObjectData.fadeInDuration)
        scaleUp.timingMode = .easeOut
        object.run(SKAction.group([fadeIn, scaleUp]))
        
    }
    
    // fade out animation
    
   private func animateFadeOut(of object: SKNode) {
        
        let scaleUp = SKAction.scale(to: 1.5, duration: ObjectData.fadeOutDuration)
        let fadeOut = SKAction.fadeOut(withDuration: ObjectData.fadeOutDuration)
        let remove = SKAction.removeFromParent()
        object.run(SKAction.sequence([scaleUp, fadeOut, remove]))
    }
    
    
   private func scheduleRemoval(of object: SKShapeNode){
        
        object.run(SKAction.sequence([
            SKAction.wait(forDuration: duration),
            SKAction.scale(by: 0.1, duration: ObjectData.fadeOutDuration),
            SKAction.fadeOut(withDuration: ObjectData.fadeOutDuration),
            SKAction.run { [weak self] in
                
                guard let self = self else { return }
                
                //
                handleMissedObject()
            },
            SKAction.removeFromParent()
        ]))
        
    }
    
    // remove one  life if no touch on the object has been detected
    
    private func handleMissedObject() {
        self.gameData.lives -= 1
        
        // check Game Over
        
        if self.gameData.lives <= 0 {
            endGame()
            
        } else {
            
            // play audio file
            
            AudioServicesPlaySystemSound(GameSound.missTouch)
            
            spawnObject()
        }
    }
    
    
    // MARK: Remove old object before drawing new object
    
   private func removeObject() {
        
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
        
        var particleFileName = ObjectTouchParticle.circle
        var soundId: SystemSoundID = GameSound.circle
        
        if gameIsOver { return }
        
        // update score and check for new duration
        for object in nodes {
            
            if object.name == "object" {
                
                // animation after touching
                
                switch objectType {
                    
                // for circle
                    
                case ObjectType.circle:
                    gameData.score += ObjectData.circleScore
                    particleFileName = ObjectTouchParticle.circle
                    soundId = GameSound.circle
                    
                // for square
                    
                case ObjectType.square:
                    gameData.score += ObjectData.squareScore
                    particleFileName = ObjectTouchParticle.square
                    soundId = GameSound.square
                }
                
                // sound after touching
                
                let didLevelUp =  checkLevelUp()
                
                // add audio
                
                AudioServicesPlaySystemSound(
                    didLevelUp ? GameSound.levelUp : soundId)
                
                // start particle anmiation based on object type
                
                if let particles = SKEmitterNode(fileNamed: particleFileName) {
                    particles.position = object.position
                    
                    // add particle
                    
                    addChild(particles)
                    
                    // wait and remove particle node
                    
                    let removeParticle = SKAction.sequence([SKAction.wait(forDuration: 2),
                                                            SKAction.removeFromParent()])
                    particles.run(removeParticle)
                }
                
                // object fade out animation
                
                animateFadeOut(of: object)
                
                // calls a new object to draw
                
                spawnObject()
            }
        }
    }
    
    
    //MARK: ramdomly choose circle or square for object type
    
    private func randomObjectType() -> ObjectType {
        
        Int.random(in: 1...100) <= ObjectData.randomObjectProbability
        ? ObjectType.square
        : ObjectType.circle
        
    }
    
    //MARK: end of the game
    
   private func endGame() {
        
        gameIsOver = true
        
        gameTime?.invalidate()
        
        // call remove all objects function
        removeObject()
        gameOverHandler?(gameData.score, gameData.level)
    }
    
    
    //MARK: check level up
    
    private func checkLevelUp() -> Bool {
        
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
