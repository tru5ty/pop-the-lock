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
    var Dot = SKSpriteNode()
    
    var Path = UIBezierPath()
    
    var gameStarted = Bool()
    var movingClockwise = Bool()
    
    var intersected = false
    
    var levelLbl = UILabel()
    
    var currentLevel = Int()
    var currentScore = Int()
    var highLevel = Int()
    
    override func didMoveToView(view: SKView) {
        loadView()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.integerForKey("HighLevel") != 0 {
            highLevel = defaults.integerForKey("HighLevel") as Int!
            currentLevel = highLevel
            currentScore = currentLevel
            levelLbl.text = "\(currentScore)"
        } else {
            defaults.setInteger(1, forKey: "HighLevel")
        }
    }
    
    func loadView() {
        movingClockwise = true
        Circle = SKSpriteNode(imageNamed: "circle")
        Circle.size = CGSize(width: 300, height: 300)
        Circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(Circle)
        
        Person = SKSpriteNode(imageNamed: "person")
        Person.size = CGSize(width: 40, height: 7)
        Person.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 122)
        Person.zRotation = 3.14/2
        Person.zPosition = 2.0
        self.addChild(Person)
        
        addDot()
        
        levelLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        levelLbl.center = (self.view!.center)
        levelLbl.text = "\(currentScore)"
        levelLbl.textColor = SKColor.darkGrayColor()
        levelLbl.textAlignment = NSTextAlignment.Center
        levelLbl.font = UIFont.systemFontOfSize(60)
        self.view?.addSubview(levelLbl)
        
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
            dotTouched()
        }
        
    }
    
    func addDot() {
        
        Dot = SKSpriteNode(imageNamed: "dot")
        Dot.size = CGSize(width: 30, height: 30)
        Dot.zPosition = 1.0
        
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        let radian = atan2(dy, dx)
        
        if movingClockwise == true {
            let tempAngle = CGFloat.random(min: radian - 1.0, max: radian - 2.5)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 122, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = path2.currentPoint
            
        } else if movingClockwise == false {
            let tempAngle = CGFloat.random(min: radian + 1.0, max: radian + 2.5)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 122, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = path2.currentPoint
            
        }
        self.addChild(Dot)
        
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
    
    func dotTouched() {
        if intersected == true {
            Dot.removeFromParent()
            addDot()
            intersected = false
            currentScore--
            levelLbl.text = "\(currentScore)"
            if currentScore <= 0 {
                nextLevel()
            }
        } else if intersected == false {
            died()
        }
    }
    
    func nextLevel() {
        currentLevel++
        currentScore = currentLevel
        levelLbl.text = "\(currentScore)"
        won()
        if currentLevel > highLevel {
            highLevel = currentLevel
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(highLevel, forKey: "HighLevel")
        }
    }
    
    func died() {
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.25)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.25)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        levelLbl.removeFromSuperview()
        currentScore = currentLevel
        self.loadView()
    }
    
    func won() {
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1.0, duration: 0.25)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.25)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        levelLbl.removeFromSuperview()
        self.loadView()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if Person.intersectsNode(Dot) {
            intersected = true
        } else {
            if intersected == true {
                if Person.intersectsNode(Dot) == false {
                   died()
                }
            }
        }
    }
    
    
    
    
}
















