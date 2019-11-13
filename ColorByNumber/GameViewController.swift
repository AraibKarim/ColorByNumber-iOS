//
//  GameViewController.swift
//  SKCamera Demo
//
//  This demo application implements the gesture recognizers which manipulate the demo camera in the view controller.
//  The purpose is for compatibility in universal applications.  Universal apps can share a single scene and will have
//  a separate view controller for each target platform.
//
//  Created by Araib on 8/26/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var belowView: UIView!
    
    // MARK: Properties
    let prefs_Fills = "ColorPixel_Fills"
    var numberOfFills = 0;
    var isFillButton_Selected  = false
    var storedOffsets = [Int: CGFloat]()
    
    var colorBoxArray  = [ColorBox] ()
    
    @IBOutlet weak var tableView: Table!
    
    var currentColorIndex = 0;
    var demoScene: GameScene!
    var isFill_Selected =  false
    @IBOutlet weak var numberOfFill_Label: UILabel!
    
   
    var levelScreen : LevelScreen!
    var panGesture = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var move = true
    var isScrolling = false
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var fillButton: UIButton!
    // MARK: Fill Button functions
    @IBAction func fillButtonClicked(_ sender: Any) {
         unSelectAllColorBoxes ()
        if(numberOfFills == 0){
            //no more fills remain
        }else {
            isFillButton_Selected = true
            fillButton.setBackgroundImage(UIImage.init(named: "fill_selected"), for: UIControlState.normal)
        }
        
    }
    
    func UseFill () -> Bool{
        if(numberOfFills == 0){
            return false
        }else{
            numberOfFills =  numberOfFills - 1
            numberOfFill_Label.text = "\(numberOfFills)"
            setNumberOfFills()
            if(numberOfFills == 0){
                fillButton.setBackgroundImage(UIImage.init(named: "fill_empty"), for: UIControlState.normal)
            }
            return true
        }
    }
    func hideFillButton (){
        fillButton.isEnabled = false
        fillButton.isHidden = true
    }
    func  showFillButton(){
        fillButton.isEnabled = true
        fillButton.isHidden = false
        
    }
    func getNumberOfFills (){
        self.numberOfFills = UserDefaults.standard.integer(forKey: prefs_Fills)
    }
    func setNumberOfFills (){
        UserDefaults.standard.set(numberOfFills, forKey: prefs_Fills)
    }
    // MARK: Back Button
    @IBAction func backButtonClicked(_ sender: Any) {
        hideBackButton ()
        tableView.isHidden = true
        belowView.isHidden = true
        tableView.delegate = nil
        tableView.dataSource = nil
        
        demoScene.moveBackToLevelScreen()
    }
    
    func hideBackButton (){
        backButton.isEnabled = false
        backButton.isHidden = true
    }
    func  showBackButton(){
        backButton.isEnabled = true
        backButton.isHidden = false
        
    }
    // MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isFirstTime = UserDefaults.standard.bool(forKey: "firstTime")
        
        if(isFirstTime){
            
        }else{
            UserDefaults.standard.set(true, forKey: "firstTime")
            UserDefaults.standard.set(5, forKey: self.prefs_Fills)
            numberOfFills =  5
        }
        
        
        
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Configure the scene.
        demoScene = GameScene(size: skView.bounds.size)
        demoScene.scaleMode = .resizeFill
        
        // Configure the pan gesture recognizer
        // panGesture.addTarget(self, action: #selector(handlePanGesture(recognizer:)))
        //    panGesture.delegate = self
        //   self.view.addGestureRecognizer(panGesture)
        
        // Configure the pinch gesture recognizer
        //  pinchGesture.addTarget(self, action: #selector(handlePinchGesture(recognizer:)))
        //   self.view.addGestureRecognizer(pinchGesture)
        
        // Present the scene.
        demoScene.gameViewController = self
        // skView.presentScene(demoScene)
        tableView.gameViewController = self
        //  tableView.delegate = self
        //  tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        hideFillButton ()
        levelScreen = LevelScreen(size: skView.bounds.size)
        levelScreen.scaleMode = .resizeFill
        levelScreen.gameViewController = self
        levelScreen.categoryData =  Category (categoryID: 1, categoryName: "Dogs", image: "category1")
        skView.presentScene(levelScreen)
    }
    func initCollectionView (gameScene : GameScene){
        demoScene =  gameScene
        panGesture = UIPanGestureRecognizer()
        pinchGesture = UIPinchGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePanGesture(recognizer:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        pinchGesture.delegate = self
        pinchGesture.addTarget(self, action: #selector(handlePinchGesture(recognizer:)))
        self.view.addGestureRecognizer(pinchGesture)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        belowView.isHidden = false
        getNumberOfFills ()
        numberOfFill_Label.text = "\(numberOfFills)"
        showFillButton ()
        print("PinPanTable")
    }
    
    // MARK: Touch-based event handling
    
    /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     // use stop to give the effect of pinning the camera under your finger when touching the screen.
     let touch: UITouch = touches.first as! UITouch
     print ("ttoch",touch.view?.tag)
     //print (touch.view)
     if(touch.view?.tag ==  2){
     //    print ("tag 2 touch",touch.view?.tag)
     move = false;
     }else{
     //   print ("tag 2 not touch",touch.view?.tag)
     move = true;
     }
     demoScene.demoCamera.stop()
     }
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     let touch: UITouch = touches.first as! UITouch
     //  print (touch.view)
     print ("ttoch",touch.view?.tag)
     if(touch.view?.tag ==  2){
     move = false;
     }else{
     move = true;
     }
     }
     */
    // MARK: Touch functions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        move = true
        isScrolling = false
        print("scroll","off")
    }
    // MARK: Gestures
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        //    print(recognizer.view)
        // Update the camera's position velocity based on user interaction.
        // The velocity of the recognizer is much larger than what feels comfortable to the user, so it is reduced by a factor of 100.
        // If your game needs a faster or slower camera feel reduce or increase the number that velocity is being divided by.
        if(move){
            let panVelocity = (recognizer.velocity(in: demoScene.view))
            demoScene.demoCamera.setCameraPositionVelocity(x: panVelocity.x / 100, y: panVelocity.y / 100)
            isScrolling = true
            //        print("scroll","true")
        }
        
        if(recognizer.state == .ended)
        {
            //   isScrolling = false
            //     print("scroll","off")
            //All fingers are lifted.
        }
    }
    
    @objc func handlePinchGesture(recognizer: UIPinchGestureRecognizer) {
        // Update the camera's scale velocity based on user interaction.
        // Recognizer velocity is reduced to provide a more pleasant user experience.
        // Increase or decrease the divisor to create a faster or slower camera.
        if(move){
            let pinchVelocity = recognizer.velocity
            demoScene.demoCamera.setCameraScaleVelocity(z: pinchVelocity / 100)
            isScrolling = true
            //  print("scroll","true")
        }
        if(recognizer.state == .ended)
        {
            //  isScrolling = false
            // print("scroll","off")
            //All fingers are lifted.
        }
    }
    
    // MARK: Gesture Recognizer Delegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Since this demo only configures two gesture recognizers and we want them to work simultaneously we only need to return true.
        // If additional gesture recognizers are added there could be a need to add aditional logic here to setup which specific
        // recognizers should be working together.
        return true;
    }
    
    // MARK: View Controller Configuration
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: Table Delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        tableViewCell.setGameViewControllerToCollectionView (gameViewController: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    // MARK: Refresg Selected Logic
    
    func unSelectAllColorBoxes (){
        currentColorIndex = 0
        for colorBox in colorBoxArray {
            colorBox.isSelected = false
        }
        self.tableView.reloadData()
        
    }
    
    
}
// MARK: CollectionView Extension

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorBoxArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let colorBoxObject = colorBoxArray[indexPath.row]
        
        if(colorBoxObject.isTouchAble){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorBoxesCollectionViewCell", for: indexPath) as! ColorBoxesCollectionViewCell
            
            
            cell.middleBox.backgroundColor = colorBoxArray[indexPath.row].middleBox
            cell.lowerBox.backgroundColor = colorBoxArray[indexPath.row].lowerBox
            cell.upperShadow.backgroundColor = colorBoxArray[indexPath.row].upperShadow
            cell.upperShadow.alpha = 0.5
            cell.lowestShadow.backgroundColor = colorBoxArray[indexPath.row].lowestShadow
            cell.middleShadow.backgroundColor = colorBoxArray[indexPath.row].middleShadow
            cell.index = colorBoxArray[indexPath.row].index
            cell.isSelected = colorBoxArray[indexPath.row].isSelected
            let num = indexPath.row + 1
            cell.numberText.text = "\(num)"
            if(cell.isSelected){
                cell.black_Top.isHidden =  false
                cell.blackTop_left.isHidden =  false
                cell.blackTop_right.isHidden =  false
                
                cell.black_middle.isHidden =  false
                cell.blackLower1.isHidden =  false
                cell.blackLower2.isHidden =  false
                cell.blackLower3.isHidden =  false
                print("showBlackBorder",indexPath.row)
            }else{
                cell.black_Top.isHidden =  true
                cell.blackTop_left.isHidden =  true
                cell.blackTop_right.isHidden =  true
                cell.black_middle.isHidden =  true
                cell.blackLower1.isHidden =  true
                cell.blackLower2.isHidden =  true
                cell.blackLower3.isHidden =  true
                print("dontShowBlackBorder",indexPath.row)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoneTickTableViewCell", for: indexPath) as! DoneTickTableViewCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        let selectedColorBox = colorBoxArray [indexPath.row]
        if(selectedColorBox.isTouchAble){
            currentColorIndex = selectedColorBox.index
            for colorBox in colorBoxArray {
                if(colorBox.index == selectedColorBox.index){
                    colorBox.isSelected = true
                    isFillButton_Selected = false
                    fillButton.setBackgroundImage(UIImage.init(named: "fill"), for: UIControlState.normal)
                }else{
                    colorBox.isSelected = false
                }
            }
            collectionView.reloadData()
        }
        
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        move = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        move = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        move = true
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        move = false
    }
    
    func reloadDataAfterColorCountCompletion (){
        
        tableView.reloadData()
    }
}
