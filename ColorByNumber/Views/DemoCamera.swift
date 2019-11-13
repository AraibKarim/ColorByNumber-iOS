//
//  DemoCamera.swift
//  SKCamera Demo
//
//  Created by Araib on 8/26/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//
import SpriteKit
import os.log


protocol DemoCameraOnChange {
    func onChange(x: CGFloat,y: CGFloat,size: CGFloat)
}
class DemoCamera: SKCameraNode {
    
    var delegate: DemoCameraOnChange?
    
    var area =  1000
    var saveVelocity : (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
  //   var saveVelocity : (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
    // MARK: Properties
    
    // velocity is the value that the camera should move each frame in the x, y and z direction.
    // x and y are position values and will adjust the pixel location of the camera in the scene.
    // z is a scale value and will adjust the scale of the camera's viewport.
    private var velocity: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
    
    // friction is a used to decrease the velocity of the camera after user interaction has
    // ended to cause the camera to gradually slow to a stop.
    private var friction: CGFloat = 0.95
    
    // attraction is a value derived from the distance the camera's position is outside of the
    // camera's range.  It is used along with the attractive force to provide a 'soft' edge to
    // the camera's range, allowing it to cross its min and max slightly and bounce back.
    private var attraction: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 0)
    
    // attractiveForce sets the 'softness' of the edge of the camera's range.
    // A value of 1.0 will be a hard edge where the camera stops at it min and max ranges with no give or bounce.
    // Smaller values will allow the camera to travel farther past its range and bounce back.
    // A value of 0.0 will allow the camera to completely ignore its defined range.
    private let attractiveForce: CGFloat = 0.25
    
    // The cameras position and scale range
    var range: (x: (min: CGFloat, max: CGFloat),
                y: (min: CGFloat, max: CGFloat),
                z: (min: CGFloat, max: CGFloat)) = ((-1000, 1000), (-1000, 1000),(1, 12))
    
    // A boolean value that indicates whether the camera displays a position indicator.
    private var showsPosition = false
    
    // A boolean value that indicates whether the camera displays a scale indicator.
    private var showsScale = false
    
    // A boolean value that indicates whether the camera displays a viewport indicator.
    private var showsViewport = false
    
    // Position indicator that demonstrates adding game controls to the camera and aids in debugging
    private let positionLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-SemiBold")
    
    // Scale indicator that demonstrates adding game controls to the camera and aids in debugging
    private let scaleLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-SemiBold")
    
    // Viewport indicator that demonstrates adding game controls to the camera and aids in debugging
    private let viewportLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-SemiBold")
    
    
    // MARK: Initializers
    
    // Creates a camera node
    override init() {
        super.init()
    }
    
    // Sks files are not used in this demo.
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not used in this app")
    }
    
    func setZoomRange (zoom : CGFloat){
        range = ((-1500, 1500), (-1500, 1500),(1, zoom))
    }
    
    // MARK: Public Functions
    
    // set all forces that act upon the camera to 0, stoping the camera's motion
    func stop() {
        velocity = (0.0, 0.0, 0.0)
        attraction = (0.0, 0.0, 0.0)
    }
    
    // Update tells the camera to update itself
    func update() {
        updatePosition()
        updateScale()
        updateHUD()
    }
    
    // Display the position indicator
    func showPosition() {
        if (!showsPosition) {
            showsPosition = true
            positionLabel.fontSize = 8
            positionLabel.fontColor = .black
            addChild(positionLabel)
        }
    }
    
    // Display the scale indicator
    func showScale() {
        if (!showsScale) {
            showsScale = true
            scaleLabel.fontSize = 8
            scaleLabel.fontColor = .black
            scaleLabel.position = CGPoint(x:0.0, y: -15.0)
            addChild(scaleLabel)
        }
    }
    
    func showViewport() {
        if (!showsViewport) {
            showsViewport = true
            viewportLabel.fontSize = 8
            viewportLabel.fontColor = .white
            viewportLabel.position = CGPoint(x:0.0, y: -30.0)
            addChild(viewportLabel)
        }
    }
    
    // Set the velocity of the camera position and scale
    func setCameraVelocity(x: CGFloat!, y: CGFloat!, z: CGFloat!) {
        setCameraPositionVelocity(x: x, y: y)
        if (z != nil) {
            setCameraScaleVelocity(z: z)
        }
    }
    
    // Set the camera's position velocity
    // We multiply the velocity by scale so that panning appears to happen at the same rate at every zoom level.
    func setCameraPositionVelocity(x: CGFloat!, y: CGFloat!) {
        if (x != nil) {
            velocity.x = x * xScale
        }
        
        if (y != nil) {
            velocity.y = y * yScale
        }
    }
    
    // Set the camsera's scale velocity
    // We multiply the velocity by scale so that zooming appears to happen at the same rate at every zoom level.
    func setCameraScaleVelocity(z: CGFloat) {
        velocity.z = z * xScale
    }
    
    // Set the camera's friction force
    func setCameraFriction(force: CGFloat) {
        if (force <= 0 || force >= 1.0) {
            os_log("Friction should be a number between 0 and 1", type: .error)
        }
        friction = force
    }
    
    // Set the camera's attractive force
    func setCameraAttractiveForce(force: CGFloat) {
        if (force <= 0 || force >= 1.0) {
            os_log("Attractive force should be a number between 0 and 1", type: .error)
        }
    }
    
    // MARK: Private Functions
    
    // Apply's forces to the camera's velocity and then upadtes its position
    private func updatePosition() {
        
        // Update attraction x
        if (position.x < range.x.min) {
            attraction.x = position.x - range.x.min
            attraction.x *= attractiveForce
        } else if (position.x > range.x.max) {
            // Attraction is a positive number
            attraction.x = position.x - range.x.max
            attraction.x *= attractiveForce
        } else {
            attraction.x = 0.0
        }
        
        // Update attraction y
        if (position.y < range.y.min) {
            attraction.y = position.y - range.y.min
            attraction.y *= attractiveForce
        } else if (position.y > range.y.max) {
            attraction.y = position.y - range.y.max
            attraction.y *= attractiveForce
        } else {
            attraction.y = 0.0
        }

        // Apply friction
       
        velocity.x *= friction
        velocity.y *= friction
        
        // And finally update the position
        var x = position.x
        var y = position.y
        x -= velocity.x + attraction.x
        y += velocity.y - attraction.y
        if x.isNaN {
      //      print("infinite")
        }
        if y.isNaN || x.isNaN {
      //      print("infinite")
        }else{
          //  print ("finitePosition",x)
         //     print ("finitePosition",y)
            position.x -= velocity.x + attraction.x
            position.y += velocity.y - attraction.y
        }
        
        
     //    print("infinite",x)
        
     
    }
    
    // Applies forces to the camera's scale velocity and then updates the scale
    private func updateScale() {
        
        // x and y should always be scaling equally in this camera,
        // but just incase something happens to throw them out of whack... set them equal
        yScale = xScale
        
        // Test if xScale is outside its range and set an attraction to the bound it has exceded
        // so that the attraction can be applied when updating the camera's position
        if (xScale < range.z.min) {
            attraction.z = range.z.min - xScale
            attraction.z *= attractiveForce
        } else if (xScale > range.z.max) {
            attraction.z = range.z.max - xScale
            attraction.z *= attractiveForce
        } else {
            attraction.z = 0
        }
        
        // Apply friction to velocity so the camera slows to a stop when user interaction ends.
        
        var z = velocity.z
        z *= friction
        if(z.isNaN){
         //   print("velocity","infinite")
            velocity = self.saveVelocity
        }else{
            velocity.z *= friction
            self.saveVelocity =  velocity
            
            // Update the camera's scale
         //   print("velocityFinite",velocity.z)
            
            setScale(xScale - velocity.z + attraction.z)
        }
       
        
    }
    
    /**
     Update the camera's SKLabelNode children.
     
     - Author:
     Sean Allen
     
     - Important:
     This function is called by the update() method.
     
     - Version:
     0.1
     
     The updateHUD() funcition is called by the update() method so that when the scale and position debug labels are enabled they
     will accurately display the current camera orientation.  This HUD serves to provide information about the camera state and
     serves as an example of how to implement a HUD by adding nodes as children of the camera.
     */
    private func updateHUD() {
        let x = position.x.rounded(FloatingPointRoundingRule.toNearestOrEven)
        let y = position.y.rounded(FloatingPointRoundingRule.toNearestOrEven)
        let scale = round(100 * xScale) / 100.0
        
        if (showsPosition) {
            
            let x = position.x.rounded(FloatingPointRoundingRule.toNearestOrEven)
            let y = position.y.rounded(FloatingPointRoundingRule.toNearestOrEven)
        
            positionLabel.text = "position: (\(x), \(y))"
            
            positionLabel.position = CGPoint(x:parent!.frame.size.width / 2 - 50, y: -parent!.frame.size.height/2 + 130)
        }
        
        if (showsScale) {
            let scale = round(100 * xScale) / 100.0
            scaleLabel.text = "Scale: \(scale)"
            scaleLabel.position = CGPoint(x:parent!.frame.size.width / 2 - 50, y: -parent!.frame.size.height/2 + 40)
        }
        
        if (showsViewport) {
            viewportLabel.text = "Viewport: (\(parent!.frame.size.width), \(parent!.frame.size.height))"
            viewportLabel.position = CGPoint(x:parent!.frame.size.width / 2 - 50, y: -parent!.frame.size.height/2 + 20)
        }
        
        delegate?.onChange(x: x, y: y, size: scale)
    }
}

