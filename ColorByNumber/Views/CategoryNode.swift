//
//  CategoryNode.swift
//  SKCamera Demo
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import Foundation
import SpriteKit
public class CategoryNode : SKNode {
    
    var width = Float();
    var height = Float();
    var categoryData : Category!
    
    func addCategoryView (categoryData: Category, width : Float, height : Float, image : String, text : String){
        self.width = width
        self.height = height
        self.categoryData = categoryData
        var node = SKSpriteNode ()
        node = SKSpriteNode(color: UIColor.init(hexString: "#f3f3f3") ,size: CGSize(width: Int(width), height: Int(height)))
        
       
        
      
        
        
        let cropNode = SKCropNode()
     //   cropNode.zPosition = 2
        cropNode.name = "crop node"
        let mask = SKShapeNode(rect: CGRect(x: -Int(width)/2, y: -Int(height)/2, width: Int(width), height: Int(height)), cornerRadius: 15)
        mask.fillColor = SKColor.white
     //   mask.zPosition = 2
        mask.name = "mask node"
        cropNode.maskNode = mask
       // self.addChild(cropNode)
         node.position = CGPoint(x: 0, y: 0 )
        node.name = "categoryNode"
        self.addChild(node)
     //   cropNode.addChild(node)
        
        let categoryImage = SKSpriteNode.init(imageNamed: image)
        categoryImage.position =  CGPoint(x: Int(width * 0.25), y: 0 )
        self.addChild(categoryImage)
          categoryImage.name = "categoryNode"
        
        let label = SKLabelNode.init(fontNamed: "DisposableDroidBB")
        label.text = text
        label.fontSize = 30
        label.fontColor = SKColor.black
        label.position = CGPoint(x: 0 -  CGFloat (width/2.2) + label.frame.width/2, y: CGFloat(height/2 * 0.5))
        self.addChild(label)
           label.name = "categoryNode"
    }
    
    
}
