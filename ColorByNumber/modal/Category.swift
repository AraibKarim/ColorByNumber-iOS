//
//  Category.swift
//  SKCamera Demo
//
//  Created by Araib on 7/22/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import Foundation
public class Category{
   
    var categoryID = 0
    var categoryName = "";
    var image = ""
    var levels = [Level] ()
    
    init(categoryID : Int, categoryName : String, image : String) {
      
        self.categoryID =  categoryID
        self.categoryName = categoryName
        self.image = image
        
        buildLevels(categoryID: categoryID)
        
    }
    
    func buildLevels (categoryID : Int){
        switch categoryID {
        case 1:
              levels.append(Level(id : 1,size:  32, levelName : "",categoryID : categoryID, categoryName: self.categoryName, isLocked: false, fileName : "dog1"))
              
            break
        default:
            break
        }
    }
    
}
