//
//  UIButton+Border.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UIButtonBorder: UIButton {
    
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
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(306, 54)
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        self.setType()
    }

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    func setType(){
        self.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        self.titleLabel!.textAlignment = .Center
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func setupViews() {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = false
        self.setType()
        self.backgroundColor = UIColor.DarkSkyBlueColor()
    }
    
    //required method to present changes in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupViews()
    }
}