//
//  GameScene.swift
//  pop-the-lock
//
//  Created by Nathan McGuire on 5/12/2015.
//  Copyright (c) 2015 Nathan McGuire. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var Circle = SKSpriteNode()
    var Person = SKSpriteNode()
    
    var Path = UIBezierPath()
    
    var gameStarted = Bool()
    var movingClockwise = Bool()
    
    override func didMoveToView(view: SKView) {
        Circle = SKSpriteNode(imageNamed: "circle")
        Circle.size = CGSize(width: 300, height: 300)
        Circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(Circle)
        
        Person = SKSpriteNode(imageNamed: "person")
        Person.size = CGSize(width: 40, height: 7)
        Person.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 122)
        Person.zRotation = 3.14/2
        self.addChild(Person)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameStarted == false {
            moveClockwise(); movingClockwise = true
            gameStarted = true
            
        } else if gameStarted == true {
            if movingClockwise == true {
                moveCounterClockwise(); movingClockwise = false
                
                
            } else if movingClockwise == false {
                moveClockwise()
                movingClockwise = true
            }
            
        }
        
    }
    
    func moveClockwise() {
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let radian = atan2(dy, dx)
        
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 122, startAngle: radian, endAngle: radian + CGFloat(M_PI * 4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow).reversedAction())
    }
    
    func moveCounterClockwise() {
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let radian = atan2(dy, dx)
        
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 122, startAngle: radian, endAngle: radian + CGFloat(M_PI * 4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
