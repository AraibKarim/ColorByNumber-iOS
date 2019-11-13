//
//  ColorBoxesCollectionViewCell.swift
//  SKCamera Demo
//
//  Created by Araib on 6/6/18.
//  Copyright © 2018 WoodyApps. All rights reserved.
//

import UIKit

class ColorBoxesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var middleShadow: UIView!
    @IBOutlet weak var lowerBox: UIView!
    @IBOutlet weak var lowestShadow: UIView!
    @IBOutlet weak var upperShadow: UIView!
    @IBOutlet weak var middleBox: UIView!
    
    @IBOutlet weak var black_Top: UIView!
    @IBOutlet weak var blackTop_left: UIView!
    
    @IBOutlet weak var blackTop_right: UIView!
    
    @IBOutlet weak var black_middle: UIView!
    @IBOutlet weak var blackLower1: UIView!
    
    @IBOutlet weak var blackLower2: UIView!
    @IBOutlet weak var blackLower3: UIView!
    
    @IBOutlet weak var numberText: UILabel!
    
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
