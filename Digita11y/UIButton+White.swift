//
//  UIButton+Border.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UIButtonWhite: UIButton {

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

    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        self.setType()
    }

    //include insets in intrinsic content size
    override func intrinsicContentSize() -> CGSize {
        let s = super.intrinsicContentSize()
        return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
            s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    }

//    override class func requiresConstraintBasedLayout() -> Bool {
//        return true
//    }

    func setType(){
        self.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        self.titleLabel!.textAlignment = .Center
    }

    func setupViews() {
        self.backgroundColor = UIColor.whiteColor()
        self.titleEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.setType()
    }
}
