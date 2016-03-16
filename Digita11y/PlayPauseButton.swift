//
//  PlayPauseButton.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/12/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PlayPauseButton : UIButton {
    
    let height = 68.0 as CGFloat
    let width = 68.0 as CGFloat
    
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
        return CGSizeMake(width, height)
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
//    override func setTitle(title: String?, forState state: UIControlState) {
//        super.setTitle(title, forState: state)
//        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        self.setType()
//    }
    
//    func setType(){
//        self.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
//        self.titleLabel!.textAlignment = .Center
//    }
    
    func setupViews() {
    }
    
    override func drawRect(rect: CGRect){
        //// Color Declarations
        let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.100)
        let fillColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let fillColor3 = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1.000)
        
        //// Page-1
        //// Main-view
        //// Group 5
        //// pause
        //// Stroke-840 Drawing
        let stroke840Path = UIBezierPath(ovalInRect: CGRectMake(2.8, 2.75, 64.3, 63.9))
        fillColor.setFill()
        stroke840Path.fill()
        
        
        //// Stroke- Drawing
        let strokePath = UIBezierPath(ovalInRect: CGRectMake(0, 0, 64.3, 63.9))
        fillColor2.setFill()
        strokePath.fill()
        
        
        //// Rectangle-337 Drawing
        let rectangle337Path = UIBezierPath(roundedRect: CGRectMake(22.2, 19.25, 7, 28), cornerRadius: 2)
        fillColor3.setFill()
        rectangle337Path.fill()
        
        
        //// Rectangle-337-Copy Drawing
        let rectangle337CopyPath = UIBezierPath(roundedRect: CGRectMake(35.2, 19.25, 7, 28), cornerRadius: 2)
        fillColor3.setFill()
        rectangle337CopyPath.fill()
    }
}