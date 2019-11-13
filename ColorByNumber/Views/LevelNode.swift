//
//  LevelNode.swift
//  SKCamera Demo
//
//  Created by Araib on 7/29/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import Foundation
import SpriteKit
public class LevelNode : SKNode {
    
    var width = Float();
    var height = Float();
    var gridSize = 0
    var index = 0
    var level : Level!
    
    let PREFS_ColoredPixel = "ColoredPixel"
    fileprivate var grid  = Array2D<ColorPixel>(columns: NumColumns, rows: NumRows)
    func addLevelView (id: Int, width : Float, height : Float, level : Level){
        self.level = level
        self.width = width
        self.height = height
        var node = SKSpriteNode ()
        node = SKSpriteNode(color: UIColor.init(hexString: "#ffffff") ,size: CGSize(width: Int(width), height: Int(height)))
        node.position = CGPoint(x: 0, y: 0 )
        self.addChild(node)
        node.name = "levelNode"
        self.gridSize =  level.size
        grid  = Array2D<ColorPixel>(columns: gridSize, rows: gridSize)
        let columns = level.size
        let rows = level.size
        var i = 0
        readJSON (fileName: level.fileName)
        let sizeForEachItem = width / Float (level.size)
        var trackX = width/2 * -1
        var trackY =  width/2 * -1
        let previouslyPlayedData =  getColorPixelForEachLevel()
    
        for column in 0...columns - 1 {
            for row in 0...rows - 1 {
                print(column,row)
                 let  colorPixel =  gridAT(column: column, row: row)
                if(colorPixel?.isWhiteArea)!{
                    
                } else{
                    let node = Tile()
                    let isSolved =  previouslyPlayedData [i]
                    if(isSolved){
                     node.background = SKSpriteNode(color: (colorPixel?.hex.mainColor)!,size: CGSize(width: CGFloat(sizeForEachItem), height: CGFloat(sizeForEachItem)))
                    }else{
                    node.background = SKSpriteNode(color: (colorPixel?.hex.grayColor)!,size: CGSize(width: CGFloat(sizeForEachItem), height: CGFloat(sizeForEachItem)))
                    }
                    node.background.position = CGPoint(x: 0, y: 0)
                    node.column = column
                    node.row = row
                    node.background.name = "levelNode"
                    node.addChild (node.background)
                    
                    node.position = CGPoint(x: CGFloat(trackX), y: CGFloat(trackY))
                    self.addChild(node)
                    node.name = "levelNode"
                    
           
                   
               
                }
                 trackY = trackY + sizeForEachItem
                
                     i = i + 1
            }
            trackY =  width/2 * -1
            trackX = trackX + sizeForEachItem
            
        }
                
    }
    func gridAT(column: Int, row: Int) -> ColorPixel? {
        assert(column >= 0 && column < gridSize)
        assert(row >= 0 && row < gridSize)
        return grid[column, row]
    }
    func  readJSON (fileName : String){
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        if jsonData != nil {
            do {
                // Set the map style by passing a valid JSON string.
                let datastring = NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue)
                //   print(datastring as! String)
                let dict  = convertToArray(text : datastring! as String)
                //   print(dict)
                
                let allPointColors = dict as! [String]
                var allHex = [String] ()
                var index = 1
                var uniqueColorsForCheck = [String]()
                var allColors = [Colors]()
                var grayColor =  Utility.hexStringToUIColor(hex: "#f7f7f7");
                for img in allPointColors  {
                    //print(img)
                    var   colorString = img.dropFirst(2)
                  
                    if (colorString == "000000"){
                        colorString = "ffffff"
                    }
                    allHex.append(String(colorString))
                    if(uniqueColorsForCheck.contains(String(colorString))){
                        
                    }else{
                        
                         uniqueColorsForCheck.append(String(colorString))
                        
                        if( colorString != "ffffff"){
                           
                        
                            
                            grayColor = grayColor.darker(by: 5)!
                            let uniqueColorObject = Colors (hex: String(colorString), mainColor: Utility.hexStringToUIColor(hex: String(colorString)), grayColor: grayColor, number: index)
                            allColors.append(uniqueColorObject)
                            index =  index + 1
                       }
                        
                    }
                }
              
              setGameColors(allHexColors: allHex, uniqueColors: allColors)
            
            }
        }
    }
    private func setGameColors (allHexColors : [String], uniqueColors : [Colors]){
        
        // for ()
        print(allHexColors)
        print(uniqueColors)
        let columns = self.gridSize
        let rows = self.gridSize
        var i = 0
        var row = rows - 1
        while row > -1 {
            for column in 0...columns - 1 {
                let colorString = allHexColors[i]
                
                if(colorString !=  "ffffff"){
                    
                    for colortype in uniqueColors{
                        if(colortype.mainHex == colorString){
                            let color  = ColorPixel(col: column, row : row, hex : colortype )
                            grid [column,row] =  color
                            break;
                            
                        } else{
                            
                        }
                    }
                }else{
                    let color = ColorPixel  (col: column, row : row)
                    grid [column,row] =  color
                }
                i=i+1
            }
            row -= 1
        }
        
        
    }
    func convertToArray(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String]
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        return nil
        
    }
    
    func getPrefsString () -> String {
        let prefs =  PREFS_ColoredPixel + "_" +  "\(self.level.categoryID)" + "_" + "\(self.level.id)"
        return prefs
    }
    func getColorPixelForEachLevel() -> [Bool]{
        var data =  [Bool] ()
        if let tempData = UserDefaults.standard.array(forKey: getPrefsString ()) as? [Bool] {
            
            data = tempData
            
        }else{
            
            let columns = gridSize
            let rows = gridSize
            for _ in 0...columns - 1 {
                for _ in 0...rows - 1 {
                    data.append(false)
                }
                
            }
        }
        
        return data
    }
}
