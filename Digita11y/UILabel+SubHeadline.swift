//
//  UILabel+SubHeadline.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/9/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class UILabelSubHeadline: UILabelHeadline {


    override func setupViews() {
        self.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.textColor = UIColor.whiteColor()
    }

}
