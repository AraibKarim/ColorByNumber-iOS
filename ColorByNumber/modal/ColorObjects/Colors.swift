//
//  Colors.swift
//  SKCamera Demo
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//
import Foundation
import SpriteKit

public class Colors {
    var mainColor = UIColor ()
     var grayColor = UIColor ()
    var mainHex = String ()
    var number  = 0
    
    init(hex: String, mainColor : UIColor, grayColor : UIColor, number : Int )
    {
        self.mainHex = hex
          self.mainColor = mainColor
          self.grayColor = grayColor
          self.number = number
    }
    
}
