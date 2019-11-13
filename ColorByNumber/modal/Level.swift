//
//  Level.swift
//  SKCamera Demo
//
//  Created by Araib on 8/26/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//
import Foundation

public class Level{
    var id = 0
    var categoryID = 0
    var categoryName = ""
    var levelName = "";
    var isSolved = false
    var isLocked = false
    var fileName =  ""
    var size = 0
    var zoom = 0
    
    init(id : Int, size : Int, levelName : String,categoryID : Int,categoryName : String, isLocked: Bool, fileName : String) {
        self.id =  id
        self.categoryName = categoryName
        self.categoryID =  categoryID
        self.levelName = levelName
        self.isLocked = isLocked
        self.fileName =  fileName
        self.isSolved = isLevelSolved ()
        self.size =  size
        
        if(size > 55){
            zoom = 20
        }else {
            zoom = 13
        }
    }
    
    
    fileprivate func isLevelSolved () -> Bool {
        var isSolved = false
        let pref = ColorPixel_Constants.isLevelSolved + "_\(id)"
        isSolved =  UserDefaults.standard.bool(forKey: pref)
        
        return isSolved
    }
    
}
