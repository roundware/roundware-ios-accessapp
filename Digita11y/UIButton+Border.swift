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

    var buttonHeight :  CGFloat = 50.0
    let buttonWidth :   CGFloat = 297.0
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
        self.setTitleColor(UIColor.white, for: state)
        self.setTitleColor(UIColor.lightGray, for: .disabled)
        setupViews()
    }

    //required method to present changes in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupViews()
    }

    override var intrinsicContentSize : CGSize {
        return CGSize(width: buttonWidth, height: buttonHeight)
    }


    override class var requiresConstraintBasedLayout : Bool {
        return true
    }

    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        self.titleLabel?.numberOfLines = 0
        self.setType()
        let attributeString = NSAttributedString(string: title!, attributes: [NSFontAttributeName: titleLabel!.font])
        let rect = attributeString.boundingRect(with: CGSize(width: buttonWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        buttonHeight = rect.size.height + 18
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: buttonWidth, height: buttonHeight)
    }

    func setType(){
        self.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        self.titleLabel!.textAlignment = .center
    }

    func setupViews() {
        //borders
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = false

        self.backgroundColor = UIColor.DarkSkyBlueColor()
        self.setType()
    }
}
