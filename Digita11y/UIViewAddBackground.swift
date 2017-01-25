//
//  UIViewAddBackground.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/25/16.
//  Copyright © 2016 Roundware. All rights reserved.
//
import UIKit
extension UIView {
    func addBackground(_ imageFileName: String) {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: imageFileName)

        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill

        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}
