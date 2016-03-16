//
//  UIButton+Border.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable class UIButtonBorder: UIButton {
    
    let buttonHeight :  CGFloat = 50.0
    let buttonWidth :   CGFloat = 298.0
    let buttonMarginX : CGFloat = 1.0
    let buttonMarginY : CGFloat = 20.0
    
    //this init fires usually called, when storyboards UI objects created:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }

    //during developing IB fires this init to create object
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    //required method to present changes in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupViews()
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(buttonWidth, buttonHeight)
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.setType()
    }
    
    func setType(){
        self.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        self.titleLabel!.textAlignment = .Center
    }
    
    func setupViews() {
        //borders
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.DarkSkyBlueColor()

        self.setType()
    }
}