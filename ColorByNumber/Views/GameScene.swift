//
//  GameScene.swift
//  SKCamera Demo
//
//  In any scene implementing the demo camera you will need to:
//    1. Configure the camers
//    2. Set the scene's camera to the demo camera instance
//    3. Add the camera node as a child of the scene (so HUD can be displayed)
//    4. Call the camera's update function from the scene's update function
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import SpriteKit
import GameplayKit
var NumColumns =  0;
var NumRows =  0;

// MARK: Particle Enum
enum ColorsForParticles {
    
    static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
    static let blue = UIColor.blue
    static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
    static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
    
}

enum Images {
    
    static let box = UIImage(named: "Box")!
    static let triangle = UIImage(named: "Triangle")!
    static let circle = UIImage(named: "Circle")!
    static let swirl = UIImage(named: "Spiral")!
    
}

class GameScene: SKScene, DemoCameraOnChange {
    // MARK: Zoom Delegate
    func onChange(x: CGFloat, y: CGFloat, size: CGFloat) {
       
        if(size > 4){
            let columns = NumColumns
            let rows = NumRows
            DispatchQueue.main.async {
                //Your code
                for column in 0...columns - 1 {
                    for row in 0...rows - 1 {
                        
                        let colorPixel =  self.gridAT(column: column, row: row)
                        if(colorPixel != nil){
                            if(colorPixel?.isWhiteArea)!{
                                
                            }else{
                                colorPixel?.node.hideNumber()
                            }
                        }
                    }
                    
                }
                
            }
        }else {
            let columns = NumColumns
            let rows = NumRows
            DispatchQueue.main.async {
                //Your code
                for column in 0...columns - 1 {
                    for row in 0...rows - 1 {
                        
                        let colorPixel =  self.gridAT(column: column, row: row)
                        if(colorPixel != nil){
                            if(colorPixel?.isWhiteArea)!{
                                
                            }else{
                                colorPixel?.node.showNumber()
                            }
                        }
                    }
                    
                }
                
            }
        }
    }
    // MARK: Particle Emitter
    
    var emitter = CAEmitterLayer()
    
    var colors:[UIColor] = [
        ColorsForParticles.red,
        ColorsForParticles.blue,
        ColorsForParticles.green,
        ColorsForParticles.yellow
    ]
    
    var images:[UIImage] = [
        Images.box,
        Images.triangle,
        Images.circle,
        Images.swirl
    ]
    
    var velocities:[Int] = [
        100,
        90,
        150,
        200
    ]
    
    // MARK: Properties
    
    // The game layer node holds our demo game objects.
    // In a typical game this might be called backgroundLayer to hold all the background nodes,
    // or enemyLayer to hold all of the enemy sprite nodes, these types of SKNodes are used to keep the
    // game objects organized and easier to work with.
    
    
    var categoryData : Category!
    var currentLeveL : Level!
    var gameViewController : GameViewController!
    let PREFS_ColoredPixel = "ColoredPixel"
    
    let gameLayer: SKNode!
    fileprivate var grid  : Array2D<ColorPixel>!
    var allPointColors = [String]()
    var uniqueColors = [Colors]()
    var allHexColors = [String]()
    var allColorsArrayToTrackCount = [AllColors] ()
    // The whole point of this project is to demonstrate our SKCameraNode subclass!
    let demoCamera: DemoCamera!
    var colorBoxArray  = [ColorBox] ()
    
    
    // MARK: Initializers
    
    // Init
    override init(size: CGSize) {
        
        // Initialize the game layer node that will hold our game pieces and
        // move the gameLayer node to the center of the scene
        gameLayer = SKNode()
        gameLayer.position = CGPoint(x: 0, y: 0)
        
        // Initailize the demo camera
        demoCamera = DemoCamera()
        demoCamera.showScale()
        demoCamera.showPosition()
        demoCamera.showViewport()
        
        
        // Call the super class initializer
        super.init(size: size)
        
        // Set the scene's camera
        // If you do not add the camera as a child of the scene panning and zooming will still work,
        // but none of the children of the camera will be rendered. So, no HUD or game controls.
        addChild(demoCamera)
        camera = demoCamera
        
        
        // Add the game layer node to the scene
        addChild(gameLayer)
        self.backgroundColor = UIColor.white
        demoCamera.delegate = self

    }
    
    // When not using an .sks file to build our scenes, we must have this method
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not used in this app")
    }
    
    // MARK: Scene Lifecycle
    
    override func didMove(to view: SKView) {
        // Call any custom code to setup the scene
        NumRows =  currentLeveL.size
        NumColumns =  currentLeveL.size
        demoCamera.setZoomRange(zoom: CGFloat(currentLeveL.zoom))
        grid  = Array2D<ColorPixel>(columns: NumColumns, rows: NumRows)
        gameViewController.initCollectionView (gameScene : self)
        gameViewController.showBackButton ()
        readJSON()
        removeCharactersFromColor ()
        setGameColors()
        addGamePieces()
        //addParticleEffect ()
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        // Update the camera each frame
        demoCamera.update()
    }
    
    // MARK: Init Methods
    
    // This function just sets up a bunch of shape nodes so we can demonstrate the camera panning and zooming.
    private func addGamePieces() {
        // Keeping column and row numbers even will keep the game centered about the origin because we're working with integers
        let previouslyPlayedData =  getColorPixelForEachLevel()
        let columns = NumColumns
        let rows = NumRows
        var i = 0
        for column in 0...columns - 1 {
            for row in 0...rows - 1 {
                print("\(column)"+"-"+"\(row)")
                let  colorPixel =  gridAT(column: column, row: row)
                if(colorPixel?.isWhiteArea)!{
                    
                } else{
                    // let node = Tile(color: (colorPixel?.hex.grayColor)!,size: CGSize(width: 100, height: 100))
                    let isSolved =  previouslyPlayedData [i]
                    
                    let node = Tile()
                    node.background = SKSpriteNode(color: (colorPixel?.hex.grayColor)!,size: CGSize(width: 100, height: 100))
                    node.background.position = CGPoint(x: 0, y: 0)
                    node.column = column
                    node.row = row
                    node.background.name = "Tile"
                    node.backgroundStroke = SKSpriteNode(color: UIColor.black,size: CGSize(width: 104, height: 104))
                    node.addChild ( node.backgroundStroke);
                    node.addChild (node.background)
                    node.backgroundStroke.name = "Tile"
                    node.text = SKLabelNode.init(fontNamed: "DisposableDroidBB")
                    node.text.text = colorPixel?.getNumber()
                    node.text.fontSize = 30
                    node.text.position = CGPoint(x: 0, y: 0)
                    node.text.fontColor =  SKColor.black
                    node.addChild (node.text)
                    node.text.name = "Tile"
                    
                    /* node.shape  = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
                     node.shape.lineWidth = 2
                     node.shape.fillColor = (colorPixel?.hex.grayColor)!
                     node.shape.strokeColor = UIColor.black
                     */
                    //  node.addChild (node.shape)
                    
                    node.mainColor = (colorPixel?.hex.mainHex)!
                    node.name = "\(column)"+"-"+"\(row)"
                    node.position = CGPoint(x: (column * 103) - (columns * 60) + 60, y: (row * 103) - (rows * 60) + 60)
                    if(isSolved){
                        colorPixel?.setColor(color: (colorPixel?.hex)!)
                        node.text.removeFromParent()
                        node.background.color = (colorPixel?.hex.mainColor)!
                        node.background.alpha =  1.0
                        node.background.isHidden = false
                        node.backgroundStroke.color = (colorPixel?.hex.mainColor)!
                        
                        for i in 0...self.allColorsArrayToTrackCount.count - 1 {
                            let colorObject = self.allColorsArrayToTrackCount [i]
                            if (colorObject.index == colorPixel?.hex.number){
                                let countEnded = colorObject.subtractToCount()
                                if(countEnded){
                                    print("CountEnded")
                                    for j in 0...self.gameViewController.colorBoxArray.count - 1 {
                                        let colorBox = self.gameViewController.colorBoxArray[j]
                                        if(colorBox.index == colorPixel?.hex.number){
                                            colorBox.isTouchAble = false
                                            self.gameViewController.reloadDataAfterColorCountCompletion ()
                                            print("CountEnded","Turn into Tick")
                                            
                                            break
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    }else{
                        
                    }
                    colorPixel?.node =  node
                    
                    
                    
                    
                    gameLayer.addChild(node)
                }
                i = i + 1
            }
        }
        let centerGamePiece = SKShapeNode(circleOfRadius: 5.0)
        centerGamePiece.strokeColor = .red
        centerGamePiece.fillColor = .red
        centerGamePiece.position = CGPoint(x: 0, y: 0)
        gameLayer.addChild(centerGamePiece)
        
    }
    
    private func setGameColors (){
        
        // for ()
        let columns = NumColumns
        let rows = NumRows
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
    
    func removeCharactersFromColor  (){
        for  i in (0..<allPointColors.count) {
            let colorString = allPointColors [i]
            if colorString != nil {
               if (colorString == "0x000000"){
                    allHexColors.append("ffffff")
                }else{
                    let   color = colorString.dropFirst(2)
                    allHexColors.append(String(color))
                }
            }
        }
    }
    func  readJSON (){
        let path = Bundle.main.path(forResource: currentLeveL.fileName, ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        if jsonData != nil {
            do {
                let datastring = NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue)
                let dict  = convertToArray(text : datastring! as String)
                allPointColors = dict as! [String]
                
                var index = 1
                var uniqueColors = [String]()
                var grayColor =  Utility.hexStringToUIColor(hex: "#f7f7f7");
                for img in allPointColors  {
                    //print(img)
                    var   colorString = img.dropFirst(2)
                    if (colorString == "000000"){
                        colorString = "ffffff"
                    }
                    if(uniqueColors.contains(String(colorString))){
                        for i in 0...allColorsArrayToTrackCount.count - 1 {
                            
                            let colorObject = allColorsArrayToTrackCount [i]
                            if(colorObject.name == String(colorString)){
                                colorObject.updateCount(addition:  1)
                                break;
                            }
                            
                        }
                    }else{
                        if( colorString != "ffffff"){
                            uniqueColors.append(String(colorString))
                            let colorObject = AllColors (index: index, name: String(colorString))
                            colorObject.updateCount(addition: 1)
                            allColorsArrayToTrackCount.append(colorObject)
                            
                            grayColor = grayColor.darker(by: 5)!
                            let uniqueColorObject = Colors (hex: String(colorString), mainColor: Utility.hexStringToUIColor(hex: String(colorString)), grayColor: grayColor, number: index)
                            self.uniqueColors.append(uniqueColorObject)
                            let colorBox =  ColorBox ()
                            colorBox.color = uniqueColorObject
                            colorBox.middleBox = Utility.hexStringToUIColor(hex: String(colorString))
                            colorBox.upperShadow = Utility.hexStringToUIColor(hex: String(colorString))
                            colorBox.lowerBox = Utility.hexStringToUIColor(hex: String(colorString))
                            colorBox.lowestShadow = Utility.hexStringToUIColor(hex: String(colorString)).darker(by: 20)
                            colorBox.middleShadow = Utility.hexStringToUIColor(hex: String(colorString)).darker(by: 20)
                            colorBox.index = index
                            colorBoxArray.append(colorBox)
                            index =  index + 1
                        }
                    }
                }
                gameViewController.colorBoxArray =  colorBoxArray
                gameViewController.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: Touch Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!)
        if(targetNode.name == "Tile"){
            if let targetNode = atPoint(touchLocation!) as?
                Tile{
                if(!gameViewController.isScrolling){
                     paintTappedTile(tile: targetNode)
                }
            }else  if let targetNode = atPoint(touchLocation!) as?
                SKLabelNode{
              
                if(!gameViewController.isScrolling){
                   paintTappedTile(tile: targetNode.parent as! Tile)
                }
            }else  if let targetNode = atPoint(touchLocation!) as?
                SKSpriteNode{
                if(!gameViewController.isScrolling){
                    // targetNode.background.color = Utility.hexStringToUIColor(hex: targetNode.mainColor)
                    paintTappedTile(tile: targetNode.parent as! Tile)
                }
            }
        }
        
    }
    
    func paintTappedTile (tile : Tile){
        let col =  tile.column
        let row = tile.row
        let colorPixel =  gridAT(column: col, row: row)
        
        if(!self.gameViewController.isFill_Selected){
            self.gameViewController.isFill_Selected = false
            if(colorPixel?.currentState ==  ColorPixel_Constants.STATE_DRAWN_CorrectColor){
                
            }else{
                for color in colorBoxArray {
                    if (color.index == gameViewController.currentColorIndex){
                        print("indexCurrentIndex",gameViewController.currentColorIndex);
                        colorPixel?.setColor(color: color.color)
                        break;
                    }
                }
                if(colorPixel?.currentState ==  ColorPixel_Constants.STATE_DRAWN_CorrectColor){
                    saveColorPixelForEachLevel ()
                    colorPixel?.node.text.removeFromParent()
                    colorPixel?.node.background.color = (colorPixel?.hex.mainColor)!
                    colorPixel?.node.background.alpha =  1.0
                    colorPixel?.node.background.isHidden = false
                    colorPixel?.node.backgroundStroke.color = (colorPixel?.hex.mainColor)!
                    for i in 0...self.allColorsArrayToTrackCount.count - 1 {
                        let colorObject = self.allColorsArrayToTrackCount [i]
                        if (colorObject.index == colorPixel?.hex.number){
                            let countEnded = colorObject.subtractToCount()
                            if(countEnded){
                                print("CountEnded")
                                for j in 0...self.gameViewController.colorBoxArray.count - 1 {
                                    let colorBox = self.gameViewController.colorBoxArray[j]
                                    if(colorBox.index == colorPixel?.hex.number){
                                        colorBox.isTouchAble = false
                                        self.gameViewController.reloadDataAfterColorCountCompletion ()
                                        print("CountEnded","Turn into Tick")
                                        endGame()
                                        break
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    
                }else if(colorPixel?.currentState ==  ColorPixel_Constants.STATE_DRAWN_IncorrectCOLOR){
                    //     colorPixel?.node.background.alpha =  0.5
                    colorPixel?.node.background.color = (colorPixel?.currentColor)!
                    //   colorPixel?.node.background.isHidden = true
                    //    colorPixel?.node.backgroundStroke.color = (colorPixel?.currentColor)!
                    //   colorPixel?.node.backgroundStroke.alpha =  0.5
                }else if(colorPixel?.currentState ==  ColorPixel_Constants.STATE_NOT_DRAWN){
                    
                }
            }
        }else{
            useFill(x: col, y: row)
        }
        
    }
    // MARK: Fill Function
    
    func useFill (x : Int, y : Int){
        let startingCol = x - 3
        let endingCol = x + 3
        let startingRow = y - 3
        let endingRow = y + 3
        let colorPixel =  gridAT(column: x, row: y)
        if(colorPixel?.currentState ==  ColorPixel_Constants.STATE_DRAWN_CorrectColor){
            
            return
        }
        if(self.gameViewController.UseFill()){
            for col in startingCol...endingCol  {
                for row in startingRow...endingRow  {
                    if(col < 0 || row < 0){
                        
                    }else if (col >= NumColumns || row >= NumRows){
                        
                    }else {
                        let colorPixel =  gridAT(column: col, row: row)
                        if(colorPixel?.isWhiteArea)!{
                            
                        } else{
                            colorPixel?.setColor(color: (colorPixel?.hex)!)
                            saveColorPixelForEachLevel ()
                            colorPixel?.node.text.removeFromParent()
                            colorPixel?.node.background.color = (colorPixel?.hex.mainColor)!
                            colorPixel?.node.background.alpha =  1.0
                            colorPixel?.node.background.isHidden = false
                            colorPixel?.node.backgroundStroke.color = (colorPixel?.hex.mainColor)!
                            for i in 0...self.allColorsArrayToTrackCount.count - 1 {
                                let colorObject = self.allColorsArrayToTrackCount [i]
                                if (colorObject.index == colorPixel?.hex.number){
                                    let countEnded = colorObject.subtractToCount()
                                    if(countEnded){
                                        print("CountEnded")
                                        for j in 0...self.gameViewController.colorBoxArray.count - 1 {
                                            let colorBox = self.gameViewController.colorBoxArray[j]
                                            if(colorBox.index == colorPixel?.hex.number){
                                                colorBox.isTouchAble = false
                                                self.gameViewController.reloadDataAfterColorCountCompletion ()
                                                print("CountEnded","Turn into Tick")
                                                endGame()
                                                break
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: EndGame
    func endGame (){
        var gameEnded =  true
        
        for i in 0...self.gameViewController.colorBoxArray.count - 1 {
            let colorObject = self.allColorsArrayToTrackCount [i]
            if(colorObject.count == 0){
                
            }else{
                gameEnded =  false
                break
            }
        }
        
        if(gameEnded){
            print("GAMEENDED")
            addParticleEffect ()
        }else{
            
        }
        
        
    }
    
    func saveColorPixelForEachLevel (){
        let queue = DispatchQueue(label: "com.app.queue", qos: .background)
        queue.sync {
            var arrayOfBoolToSave = [Bool] ()
            let columns = NumColumns
            let rows = NumRows
            for column in 0...columns - 1 {
                for row in 0...rows - 1 {
                    let pixel = gridAT(column: column, row: row)
                    if(pixel?.currentState ==  ColorPixel_Constants.STATE_DRAWN_CorrectColor){
                        let isColored = true
                        arrayOfBoolToSave.append(isColored)
                    }else{
                        let isColored = false
                        arrayOfBoolToSave.append(isColored)
                    }
                }
                
            }
            
            UserDefaults.standard.set(arrayOfBoolToSave, forKey: getPrefsString ())
        }
        
        
    }
    func getPrefsString () -> String {
        let prefs =  PREFS_ColoredPixel + "_" +  "\(self.currentLeveL.categoryID)" + "_" + "\(self.currentLeveL.id)"
        return prefs
    }
    func getColorPixelForEachLevel() -> [Bool]{
        var data =  [Bool] ()
        if let tempData = UserDefaults.standard.array(forKey: getPrefsString ()) as? [Bool] {
            data = tempData
        }else{
            
            let columns = NumColumns
            let rows = NumRows
            for _ in 0...columns - 1 {
                for _ in 0...rows - 1 {
                    data.append(false)
                }
            }
        }
        
        return data
    }
    // MARK: Back to Level Screen
    public func moveBackToLevelScreen (){
        moveToLevelScreen (categoryData: self.categoryData)
    }
    
    func moveToLevelScreen (categoryData : Category){
        self.removeParticleEffect()
        removeGestures()
        let levelScreen = LevelScreen(size: (self.view?.bounds.size)!)
        levelScreen.scaleMode = .resizeFill
        levelScreen.gameViewController = self.gameViewController
        levelScreen.categoryData =  categoryData
        let skView = self.view
        skView?.presentScene(levelScreen)
    }
    // MARK: Remove Gestures
    func removeGestures(){
        for gesture in (self.view?.gestureRecognizers)!{
            self.view?.removeGestureRecognizer(gesture)
        }
    }
    
    // MARK: Utiliy methods
    public func UIColorFromRGB(_ rgbValue: String) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue.hexaToInt & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue.hexaToInt & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue.hexaToInt & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func setInitialColors (UniqueColorArray : [String]){
        var color =  Utility.hexStringToUIColor(hex: "#f7f7f7");
        for i in 0 ..< UniqueColorArray.count {
            let main_ColorHex =  UniqueColorArray [i]
            color = color.darker(by: 5)!
            let colorObject = Colors (hex: main_ColorHex, mainColor: Utility.hexStringToUIColor(hex: main_ColorHex), grayColor: color, number: i + 1)
            self.uniqueColors.append(colorObject)
        }
    }
    
    func gridAT(column: Int, row: Int) -> ColorPixel? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return grid[column, row]
    }
    
    func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
        
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
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            print("weird",hex);
            return UIColor.cyan
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
// MARK: Extensions
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
    
}
extension String {
    var hexaToInt      : Int    { return Int(strtoul(self, nil, 16))      }
    var hexaToDouble   : Double { return Double(strtoul(self, nil, 16))   }
    var hexaToBinary   : String { return String(hexaToInt, radix: 2)      }
    var decimalToHexa  : String { return String(Int(self) ?? 0, radix: 16)}
    var decimalToBinary: String { return String(Int(self) ?? 0, radix: 2) }
    var binaryToInt    : Int    { return Int(strtoul(self, nil, 2))       }
    var binaryToDouble : Double { return Double(strtoul(self, nil, 2))   }
    var binaryToHexa   : String { return String(binaryToInt, radix: 16)  }
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}
extension Int {
    var binaryString: String { return String(self, radix: 2)  }
    var hexaString  : String { return String(self, radix: 16) }
    var doubleValue : Double { return Double(self) }
}
