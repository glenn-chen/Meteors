//
//  MainMenu.swift
//  Shooter
//
//  Created by Glenn Chen on 7/6/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    /* UI Connections */
    var playButton: MSButtonNode!
    var quoteLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        quoteLabel = self.childNode(withName: "quoteLabel") as! SKLabelNode

        changeQuote()
        
        /* Set UI connections */
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        
        playButton.selectedHandler = {
            self.loadGame()
        }
        
    }
    
    func changeQuote() {
        let num = Int(arc4random_uniform(6))
        
        switch num {
        case 0:
            quoteLabel.text = "No matter where you go, everyone's connected"
        case 1:
            quoteLabel.text = "A chain is only as strong as its weakest link"
        case 2:
            quoteLabel.text = "An idea is like a virus, resilient, highly contagious"
        case 3:
            quoteLabel.text = "Even a small lighter can burn a bridge"
        case 4:
            quoteLabel.text = "It's a beautiful thing, the destruction of words"
        case 5:
            quoteLabel.text = "The perfect man is no exception to the rule"
        default:
            break;
        }
    }
    
    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = GameScene.loadGameScene() else {
            print("Could not load GameScene")
            return
        }
        
        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFit
        
        /* Show debug */
        /* skView.showsPhysics = true
         skView.showsDrawCount = true*/
        //skView.showsFPS = true
        
        /* 4) Start game scene */
        skView.presentScene(scene)
    }
}
