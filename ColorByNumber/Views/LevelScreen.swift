//
//  LevelScreen.swift
//  SKCamera Demo
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelScreen : SKScene {
    var levelNumber = 0
    var allLevels = [Level]()
    var gameViewController : GameViewController!
    var moveableArea = SKNode ()
    var startY =  Float ()
    var lastY =  Float ()
    var bottamOFMoveableArea =  Float ()
    var runOnce =  false
    var categoryData : Category!
    var tapGesture : UITapGestureRecognizer!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not used in this app")
    }
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.init(hexString: "#f3f3f3")
        
        gameViewController.belowView.isHidden = true
        tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(self.tapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view?.addGestureRecognizer(self.tapGesture)
        
        
        //gameViewController.belowView.isHidden = true
        initListView()
        
    }
  
    func initListView (){
        moveableArea =  SKNode ()
        moveableArea.position =  CGPoint(x: 0, y: 0)
        self.addChild(moveableArea)
        var startingY = self.frame.height * 0.8 - 50;
        let width =  150.0
        let height =  150.0
        var index = 0
        for _ in 0...categoryData.levels.count - 1 {
            for column in 0...1
            {
                if(index < categoryData.levels.count){
                    if(column == 0){
                        let node =  LevelNode ()
                        node.index = index
                        node.addLevelView(id: index,width: Float(width), height: Float(height), level: categoryData.levels[index])
                        node.position = CGPoint(x: self.frame.midX - CGFloat (node.width/2) - 10, y: startingY)
                        
                        moveableArea.addChild(node)
                        index = index + 1
                        
                    }else{
                        let node =  LevelNode ()
                        node.addLevelView(id: index,width: Float(width), height: Float(height),  level: categoryData.levels[index])
                        node.position = CGPoint(x: self.frame.midX +  CGFloat (node.width/2) + 10, y: startingY)
                        node.index = index
                        moveableArea.addChild(node)
                        index = index + 1
                    }
                }
            }
            startingY = startingY - CGFloat (height) * 1.12
            bottamOFMoveableArea =  Float(startingY)
        }
        bottamOFMoveableArea = bottamOFMoveableArea - Float (height*2)
        print(bottamOFMoveableArea)
        let upperView   = SKSpriteNode(color: UIColor.init(hexString: "#ffffff") ,size: CGSize(width: self.frame.width, height: self.frame.height * 0.2))
        upperView.position = CGPoint(x: self.frame.midX, y: self.frame.height - upperView.size.height/2 + 50)
        upperView.zPosition =  10000
        self.addChild(upperView)
        
        let label = SKLabelNode.init(fontNamed: "DisposableDroidBB")
        label.text = categoryData.categoryName
        label.fontSize =  37
        label.fontColor = SKColor.black
        label.position = CGPoint(x: self.frame.midX -  CGFloat (width) + label.frame.width/2, y: self.frame.height * 0.9)
        self.addChild(label)
        label.zPosition =  10001
        
        
        
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        
        if(sender.state == UIGestureRecognizerState.ended){
            print ("tap")
            let touchLocation =  sender.location(in: self.view)
            let pointFromView = self.convertPoint(toView: touchLocation)
            let node = self.nodes(at: pointFromView)
            if node.count == 0 {
                
                print("you very like tapped 'nowhere'")
                return
            }
            /*print(node.count)
             if node.count != 1 {
             
             // in almost all games or physics scenes,
             // it is not possible this would happen
             print("something odd happened - overlapping nodes?")
             return
             }
             */
            if let categoryNode = node.first! as? SKNode, categoryNode.name == "levelNode" {
                print("levelNodeTouched")
                if node.first! is SKSpriteNode {
                    //var parentNode =  categoryNode.parent as! LevelNode
                    
                    if let parentNode =  categoryNode.parent as? LevelNode{
                        moveToGamePlayScreen (level: parentNode.level, index:  parentNode.index)
                        return
                    }else if let parentNode =  categoryNode.parent as? Tile {
                        
                        if let node =  parentNode.parent as? LevelNode{
                            print("tile")
                            moveToGamePlayScreen (level: node.level, index:  node.index)
                            return
                        }
                    }
                    
                    
                }
                
            }
            
            
        }
    }
    
    func removeGestures(){
        for gesture in (self.view?.gestureRecognizers)!{
            self.view?.removeGestureRecognizer(gesture)
        }
    }
    func moveToGamePlayScreen (level : Level, index :  Int){
        removeGestures()
        let levelScreen = GameScene(size: (self.view?.bounds.size)!)
        levelScreen.scaleMode = .resizeFill
        levelScreen.gameViewController = self.gameViewController
        levelScreen.currentLeveL =  level
        levelScreen.categoryData = self.categoryData
        let skView = self.view
        skView?.presentScene(levelScreen)
    }
    
    
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}
