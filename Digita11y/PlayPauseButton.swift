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


    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.setTitleColor(UIColor.clearColor(), forState: .Normal)
        showButtonIsPlaying(false)
    }

    func showButtonIsPlaying(playing: Bool) {
//        let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.100)
//        let fillColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
//        let strokeColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1.000)
//        let fillColor3 = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1.000)
        if (playing){
            print("playing")
            self.setTitle("pause", forState:  UIControlState.Normal)
            self.setBackgroundImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)

//
//            //// PauseIcon
//            let stroke2Path = UIBezierPath(ovalInRect: CGRectMake(2.6, 2.5, 64.3, 63.9))
//            fillColor.setFill()
//            stroke2Path.fill()
//
//            //// Stroke- 3 Drawing
//            let stroke3Path = UIBezierPath(ovalInRect: CGRectMake(-0.2, -0.25, 64.3, 63.9))
//            fillColor2.setFill()
//            stroke3Path.fill()
//

        } else {
            print("paused")
            self.setTitle("play", forState:  UIControlState.Normal)
            self.setBackgroundImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
//            let stroke840Path = UIBezierPath(ovalInRect: CGRectMake(2.6, 2.5, 64.3, 63.9))
//            fillColor.setFill()
//            stroke840Path.fill()
//
//            //// Stroke- Drawing
//            let strokePath = UIBezierPath(ovalInRect: CGRectMake(-0.2, -0.25, 64.3, 63.9))
//            fillColor2.setFill()
//            strokePath.fill()
//
//            //// Stroke-837 Drawing
//            let stroke837Path = UIBezierPath()
//            stroke837Path.moveToPoint(CGPointMake(21, 18))
//            stroke837Path.addLineToPoint(CGPointMake(50.72, 32.86))
//            stroke837Path.addLineToPoint(CGPointMake(21, 47.72))
//            stroke837Path.addLineToPoint(CGPointMake(21, 18))
//            stroke837Path.closePath()
//            stroke837Path.miterLimit = 4;
//            stroke837Path.lineCapStyle = .Round;
//            stroke837Path.lineJoinStyle = .Round;
//            stroke837Path.usesEvenOddFillRule = true;
//
//            fillColor3.setFill()
//            stroke837Path.fill()
//            strokeColor.setStroke()
//            stroke837Path.lineWidth = 2
//            stroke837Path.stroke()
//            print("set play button")
        }
        self.setNeedsLayout()
    }
}
