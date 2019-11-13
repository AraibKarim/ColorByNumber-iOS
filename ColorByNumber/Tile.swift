//
//  Tile.swift
//  SKCamera Demo
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import Foundation
import SpriteKit

class Tile: SKNode {
    var row = 0;
    var column = 0
    var mainColor =  String ()
    var background : SKSpriteNode!
     var backgroundStroke : SKSpriteNode!
    var text : SKLabelNode!
    
    var shape : SKShapeNode!
    
    
    func hideNumber (){
        
        text.isHidden = true
    }
    func showNumber (){
        text.isHidden = false
    }
 
}
