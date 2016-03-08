//
//  UILabel+Body.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UILabelBody: UILabel {
    
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
    
    func setupViews() {
        self.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.textColor = UIColor.whiteColor()
    }
    
    //required method to present changes in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupViews()
    }
}