//
//  ColorPixel.swift
//  SKCamera Demo
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import Foundation
import SpriteKit
public class ColorPixel {
    
    var strokeColor = UIColor.black
    var currentState = 0
    var currentColor =  UIColor ()
    var hex : Colors!
    var row = 0
    var col = 0
    
    var node : Tile!
    
    var isNOT_Touchable = false
    var isWhiteArea = false
    
    init(col: Int, row : Int, hex : Colors )
    {
   // print("colored " + "\(col)" + " " + "\(row)")
        self.col = col
        self.row = row
        self.hex = Colors (hex: hex.mainHex, mainColor: hex.mainColor, grayColor: hex.grayColor, number: hex.number)
        currentColor = hex.grayColor
        strokeColor =  Utility.hexStringToUIColor(hex: "8c8c8c")
        
    }
    
    init (col: Int, row : Int){
       //   print("white " + "\(col)" + " " + "\(row)")
        self.hex = Colors (hex: "ffffff", mainColor:UIColor.white, grayColor:UIColor.white, number: 0)
        self.col = col;
        self.row = row;
        self.isNOT_Touchable = true
        self.isWhiteArea = true
        
    }
    
    func getColor () -> UIColor{
        if(currentState == ColorPixel_Constants.STATE_DRAWN_CorrectColor){
            return self.hex.mainColor;
        }else if (currentState == ColorPixel_Constants.STATE_DRAWN_IncorrectCOLOR){
            return self.currentColor;
        }else {
            return self.hex.grayColor;
        }
    }
    
    func getStrokeColor () -> UIColor{
        if(currentState == ColorPixel_Constants.STATE_DRAWN_CorrectColor){
            return self.hex.mainColor;
        }else if (currentState == ColorPixel_Constants.STATE_DRAWN_IncorrectCOLOR){
            return self.strokeColor;
        }else{
            return self.strokeColor;
        }
    }
    
    func getNumber () -> String {
        if(currentState == ColorPixel_Constants.STATE_DRAWN_CorrectColor){
            return "";
        }else if (currentState == ColorPixel_Constants.STATE_DRAWN_IncorrectCOLOR){
            return "\(self.hex.number)";
        }else{
            return "\(self.hex.number)";
        }
    }
    
    func setColor (color: Colors){
        if(color.number == self.hex.number){
            print("index","Match")
            print("index",self.hex.number)
            self.currentState = ColorPixel_Constants.STATE_DRAWN_CorrectColor;
            isNOT_Touchable = true;
            currentColor = hex.mainColor;
        }else{
            print("index","didn't match")
            print("index",self.hex.number)
               currentColor = color.mainColor;
               self.currentState = ColorPixel_Constants.STATE_DRAWN_IncorrectCOLOR;
            
        }
    }
    
    
}


struct ColorPixel_Constants {
    static let  STATE_NOT_DRAWN = 0;
   static let STATE_DRAWN_CorrectColor = 1;
     static let STATE_DRAWN_IncorrectCOLOR = 2;
    static let SAVINGLEVEL = "SavingLevel"
     static let isLevelSolved = "LevelIsSolved"
}
struct ColorPixel_NumbersConstant {
    static let  Show_Number = 0;
    static let Hide_Number = 1;
}
