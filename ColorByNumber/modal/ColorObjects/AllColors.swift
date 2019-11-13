//
//  AllColors.swift
//  SKCamera Demo
//
//  Created by Araib on 6/11/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import Foundation
public class AllColors {
    //For keep track of count only.
    var index = 0;
    var name = String ()
    var count = 0;
    
    init(index : Int, name : String) {
        self.index = index
        self.name = name
    }
    
    func updateCount (addition : Int){
        count = count + addition
    }
    func subtractToCount() -> Bool {
        if (self.count == 0){
            return true
        }else {
            self.count =  self.count - 1
            print("Counting","Index ", self.index, " count ", self.count)
            if (count == 0){
                return true
            }else {
                return false
            }
        }
    }
}
