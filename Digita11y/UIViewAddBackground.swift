//
//  UIViewAddBackground.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/25/16.
//  Copyright © 2016 Roundware. All rights reserved.
//
import UIKit
extension UIView {
    func addBackground(imageFileName: String) {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: imageFileName)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}