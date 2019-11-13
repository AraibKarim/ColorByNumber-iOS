//
//  GameScene+ParticleExtension.swift
//  SKCamera Demo
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension GameScene {
   
    
    func addParticleEffect (){
        self.emitter.emitterPosition = CGPoint(x: (self.view?.frame.size.width)! / 2, y: -10)
        self.emitter.emitterShape = kCAEmitterLayerLine
        self.emitter.emitterSize = CGSize(width: (self.view?.frame.size.width)!, height: 2.0)
       self.emitter.emitterCells = generateEmitterCells()
        self.emitter.beginTime = CACurrentMediaTime();
        self.view?.layer.addSublayer(self.emitter)
        
        let wait = SKAction.wait(forDuration: 5)
       
        
        self.run(wait, completion:{
            self.stopParticleEffect()
        })
    }
    func stopParticleEffect (){
        self.emitter.birthRate = 0
       // self.emitter.removeFromSuperlayer()
    }
    func removeParticleEffect (){
        self.emitter.birthRate = 0
        self.emitter.removeFromSuperlayer()
    }
    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 4.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            
            cells.append(cell)
            
        }
        
        return cells
        
    }
    
    private func getRandomVelocity() -> Int {
        return velocities[getRandomNumber()]
    }
    
    private func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }
    
    private func getNextColor(i:Int) -> CGColor {
        if i <= 4 {
            return colors[0].cgColor
        } else if i <= 8 {
            return colors[1].cgColor
        } else if i <= 12 {
            return colors[2].cgColor
        } else {
            return colors[3].cgColor
        }
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return images[i % 4].cgImage!
    }

}
