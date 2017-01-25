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

    override var intrinsicContentSize : CGSize {
        return CGSize(width: width, height: height)
    }

    override class var requiresConstraintBasedLayout : Bool {
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


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setTitleColor(UIColor.clear, for: UIControlState())
        showButtonIsPlaying(false)
    }

    func showButtonIsPlaying(_ playing: Bool) {
//        let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.100)
//        let fillColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
//        let strokeColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1.000)
//        let fillColor3 = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1.000)
        if (playing){
            print("playing")
            self.accessibilityLabel = "Pause"
            self.setTitle("pause", for:  UIControlState())
            self.setBackgroundImage(UIImage(named: "pause.png"), for: UIControlState())

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
            self.setTitle("play", for:  UIControlState())
            self.accessibilityLabel = "Play"

            self.setBackgroundImage(UIImage(named: "play.png"), for: UIControlState())
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
