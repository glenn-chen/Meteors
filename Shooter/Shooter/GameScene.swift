//
//  GameScene.swift
//  Shooter
//
//  Created by Glenn Chen on 7/3/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

func distance(_ from: CGPoint, _ to: CGPoint) -> Double {
    let distanceSquared = (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    return sqrt(Double(distanceSquared))
}

class GameScene: SKScene {
    
    enum GameState {
        case active, gameOver
    }
    var gameState = GameState.active
    
    var meteorLayer: SKNode!
    var meteorSource: SKNode!
    var scoreLabel: SKLabelNode!
    var restartButton: MSButtonNode!
    var laser: SKNode!
    
    var laserTimer: CFTimeInterval = 0 {
        didSet {
            if laserTimer > 0.3 {
                laser.isHidden = true
            }
        }
    }
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 50.0 /* 50 FPS */
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    let meteorRadius = 20.0
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        laser = self.childNode(withName: "laser")
        laser.isHidden = true
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        
        restartButton = self.childNode(withName: "restartButton") as! MSButtonNode
        restartButton.state = .MSButtonNodeStateHidden
        /* Setup restart button selection handler */
        restartButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFill
            
            /* Restart game scene */
            skView?.presentScene(scene)
        }
        
        /* Set reference to meteor layer node */
        meteorLayer = self.childNode(withName: "meteorLayer")
        
        meteorSource = self.childNode(withName: "meteor")
        
        scoreLabel.text = "\(score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if gameState == .gameOver {
            return
        }
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        laserTimer = 0
        laser.position.x = touchLocation.x
        laser.isHidden = false
        
        for meteor in meteorLayer.children {
            let meteorNode = meteor.children[0].children[0]
            let meteorPosition = meteorNode.convert(meteorNode.position, to: self)
            
    /*        print("touch \(touchLocation)")
            print(meteorPosition) */
            
            if abs(meteorPosition.x - touchLocation.x) <= CGFloat(meteorRadius) {
                meteor.removeFromParent()
                score += 1
                
                let particles = SKEmitterNode(fileNamed: "Explosion")!
                /* Position particles at the Seal node
                 If you've moved Seal to an sks, this will need to be
                 node.convert(node.position, to: self), not node.position */
                particles.position = CGPoint(x: touchLocation.x, y: meteorPosition.y + size.height - 100)
                /* Add particles to scene */
                addChild(particles)
                let wait = SKAction.wait(forDuration: 0.7)
                let removeParticles = SKAction.removeFromParent()
                let seq = SKAction.sequence([wait, removeParticles])
                particles.run(seq)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if gameState == .gameOver {
            return
        }
        
        spawnTimer += fixedDelta
        
        laserTimer += fixedDelta
        
        updateMeteors()
    }
    
    func updateMeteors() {
        /* Loop through meteor layer nodes */
        for meteor in meteorLayer.children as! [SKReferenceNode] {
           // print(meteorLayer.children.count)
            /* Get obstacle node position, convert node position to scene space */
            let meteorNode = meteor.children[0].children[0]
            let realPosition = meteorNode.convert(meteorNode.position, to: self)
          //  print(realPosition)
            /* Check if obstacle has left the scene */
            if realPosition.y <= -size.height {
                /* Game over */
                meteor.removeFromParent()
                scoreLabel.text = "how disappointing"
                laser.isHidden = true
                gameState = .gameOver
                restartButton.state = .MSButtonNodeStateActive
            }
        }
        
        if spawnTimer >= 1.0 {
            /* Create a new meteor by copying the source meteor */
            let newMeteor = meteorSource.copy() as! SKNode
            
            /* Generate new meteor position */
            let randomPosition = CGPoint(x: CGFloat.random(min: 20, max: 548), y: 350)
            newMeteor.position = self.convert(randomPosition, to: meteorLayer)
            meteorLayer.addChild(newMeteor)
            // Reset spawn timer
            spawnTimer = 0
        }
    }
}


/*
 * Copyright (c) 2013-2014 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CoreGraphics

/** The value of π as a CGFloat */
let π = CGFloat(M_PI)

public extension CGFloat {
    /**
     * Converts an angle in degrees to radians.
     */
    public func degreesToRadians() -> CGFloat {
        return π * self / 180.0
    }
    
    /**
     * Converts an angle in radians to degrees.
     */
    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / π
    }
    
    /**
     * Ensures that the float value stays between the given values, inclusive.
     */
    public func clamped(v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
    
    /**
     * Ensures that the float value stays between the given values, inclusive.
     */
    public mutating func clamp(v1: CGFloat, _ v2: CGFloat)  {
        self = clamped(v1: v1, v2)
        // return self
    }
    
    /**
     * Returns 1.0 if a floating point value is positive; -1.0 if it is negative.
     */
    public func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }
    
    /**
     * Returns a random floating point number between 0.0 and 1.0, inclusive.
     */
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    /**
     * Returns a random floating point number in the range min...max, inclusive.
     */
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
    /**
     * Randomly returns either 1.0 or -1.0.
     */
    public static func randomSign() -> CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
}

/**
 * Returns the shortest angle between two angles. The result is always between
 * -π and π.
 */
public func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    
    var angle = (angle2 - angle1) .truncatingRemainder(dividingBy: twoπ)
    if (angle >= π) {
        angle = angle - twoπ
    }
    if (angle <= -π) {
        angle = angle + twoπ
    }
    return angle
}
