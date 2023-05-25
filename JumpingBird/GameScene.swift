//
//  GameScene.swift
//  JumpingBird
//
//  Created by Dimas Aristyo Rahadian on 24/05/23.
//

import Foundation
import SpriteKit

class GameScene : SKScene{
    
    enum BirdDirection {
        case right
        case left
    }
    
    var isGameOver: Bool = false
    var isStartGame: Bool = false
    var direction: BirdDirection = .right
    
    let background = SKSpriteNode(imageNamed: "bg")
    let bird = SKSpriteNode(imageNamed: "flappy")
    let gimOver = SKSpriteNode(imageNamed: "gameover")
    let okeButton = SKSpriteNode(imageNamed: "okee")
    let menuButton = SKSpriteNode(imageNamed: "menu")
    let pipes = SKSpriteNode(imageNamed: "pipe")
    let rPipes = SKSpriteNode(imageNamed: "rpipe")
    let scoreLabel = SKLabelNode(fontNamed: "Menlo")
    let scoreLabelEnd = SKLabelNode(fontNamed: "Menlo")
    let playButton = SKSpriteNode(imageNamed: "play")
    
    var score = 0{
        didSet{
            scoreLabel.text = "\(score)"
        }
    }
    
    func gameOver(){
        scoreLabel.removeFromParent()
        isGameOver = true
        bird.removeFromParent()
        print("Game Over")
    }
    
    func checkBirdCollision() {
        if bird.position.y <= 0 && !isGameOver {
            bird.physicsBody?.affectedByGravity = false // Disable gravity
            bird.physicsBody?.isDynamic = false // Make the bird static
            gameOver()
        }
        
        let pipeCollision = bird.intersects(pipes)
        let rPipeCollision = bird.intersects(rPipes)
        
        if (pipeCollision || rPipeCollision) && !isGameOver {
            gameOver()
        }
    }
    
    func birdJump() {
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // Reset the bird's velocity to zero
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20)) // Adjust the dy value for the desired jump height
    }
    
    func haptics(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func checkBirdEdge() {
        if bird.position.x >= self.size.width - bird.size.width / 2 && direction == .right {
            direction = .left
            bird.run(SKAction.scaleX(to: -1.3, duration: 0))
            bird.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0)) // Apply impulse to make the bird bounce
            createObstacle()
            score += 1
            print(direction)
            haptics()
        } else if bird.position.x <= bird.size.width / 2 && direction == .left {
            direction = .right
            bird.run(SKAction.scaleX(to: 1.3, duration: 0))
            bird.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0)) // Apply impulse to make the bird bounce
            createObstacle()
            score += 1
            print(direction)
            haptics()
        }
    }
    
    
    
    func createObstacle(){
        pipes.removeFromParent()
        rPipes.removeFromParent()
        let pipesPosition: CGPoint
        let rPipesPosition: CGPoint
        
        let gapSize: CGFloat = 600.0
        
        if direction == .right {
            print("KANAN!")
            let pipePosition = CGPoint(x: self.frame.maxX, y: .random(in: 1...self.frame.height))
            pipesPosition = CGPoint(x: size.width-5, y: pipePosition.y + gapSize)
            rPipesPosition = CGPoint(x:size.width-5, y: pipePosition.y - gapSize)
        } else {
            print("KIRI!")
            let pipePosition = CGPoint(x: self.frame.minX, y: .random(in: 1...self.frame.height))
            pipesPosition = CGPoint(x: pipePosition.x, y: pipePosition.y + gapSize)
            rPipesPosition = CGPoint(x: pipePosition.x, y: pipePosition.y - gapSize)
        }
        
        pipes.position = pipesPosition
        pipes.zPosition = 50
        
        
        rPipes.zPosition = 50
        rPipes.position = rPipesPosition
        
        addChild(pipes)
        addChild(rPipes)
        
        
    }
    
    func startGame(){
        playButton.removeFromParent()
        isStartGame = true
        addChild(bird)
        addChild(scoreLabel)
        createObstacle()
    }
    
//    func backToMenu(){
//        bird.removeFromParent()
//        pipes.removeFromParent()
//        rPipes.removeFromParent()
//        scoreLabelEnd.removeFromParent()
//        okeButton.removeFromParent()
//        gimOver.removeFromParent()
//        isStartGame = true
////        addChild(playButton)
//    }
    
    func startMovingBirdRight() {
        if !isStartGame{
            startGame()
        }else{
            let moveAction = SKAction.move(by: CGVector(dx: 25, dy: 0), duration: 0.1) // Adjust the dx value for the desired movement speed
            let repeatAction = SKAction.repeatForever(moveAction)
            bird.run(repeatAction, withKey: "moveBird")
            print("kanan")
        }
    }
    
    func startMovingBirdLeft() {
        let moveAction = SKAction.move(by: CGVector(dx: -25, dy: 0), duration: 0.1) // Adjust the dx value for the desired movement speed
        let repeatAction = SKAction.repeatForever(moveAction)
        bird.run(repeatAction, withKey: "moveBird")
        print("kiri")
    }
    
    func resetGame() {
        score = 0
        addChild(scoreLabel)
        addChild(bird)
        isGameOver = false
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.affectedByGravity = true
        bird.removeAllActions()
        gimOver.removeFromParent()
        menuButton.removeFromParent()
        okeButton.removeFromParent()
        createObstacle()
    }
    
    override func update(_ currentTime: TimeInterval) {
    
        if !isGameOver && !isStartGame{
            playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY+25)
            playButton.zPosition = 50
            playButton.setScale(1.5)
            
            if playButton.parent == nil{
                addChild(playButton)
            }
        }
        
        if !isGameOver{
            checkBirdEdge()
            checkBirdCollision()
        } else if isGameOver{
            gimOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY+25)
            gimOver.zPosition = 50
            gimOver.setScale(1)
            
//            menuButton.position = CGPoint(x: self.frame.midX+50, y: self.frame.midY-25)
//            menuButton.zPosition = 50
//            menuButton.setScale(1.3)
            
            okeButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY-25)
            okeButton.zPosition = 50
            okeButton.setScale(1.3)
            
            scoreLabelEnd.text = String(score)
            scoreLabelEnd.position = CGPoint(x: self.frame.midX, y: self.frame.midY-125)
            scoreLabelEnd.setScale(1)
            scoreLabelEnd.fontColor = .black
            scoreLabelEnd.zPosition = 200
            scoreLabelEnd.horizontalAlignmentMode = .center
            scoreLabelEnd.fontSize = 50
            
            if gimOver.parent == nil {
                addChild(gimOver)
                addChild(menuButton)
                addChild(okeButton)
                addChild(scoreLabelEnd)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            birdJump()
            if direction == .right {
                startMovingBirdRight()
            } else {
                startMovingBirdLeft()
            }
        } else {
            for touch in touches {
                let location = touch.location(in: self)
                if okeButton.contains(location) {
                    scoreLabelEnd.removeFromParent()
                    resetGame()
                }
//                if menuButton.contains(location) {
//                    backToMenu()
//                }

            }
        }
    }
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.zPosition = 10
        bird.setScale(1.3)
        
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.restitution = 0.5
        
        scoreLabel.text = String(score)
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+290)
        scoreLabel.setScale(1)
        scoreLabel.fontColor = .black
        scoreLabel.zPosition = 200
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.fontSize = 50
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        background.setScale(0.35)
        
        addChild(background)
    }
    
    
}
