//
//  TagView.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit

@IBDesignable class TagView: UIView {
    
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var tagProgress: UIProgressView!
    @IBOutlet weak var tagTitle: UIButton!
    @IBOutlet weak var audioImage: UIImageView!
    
//    var tagModel: Tag?
    
    var selected : Bool = false {
        didSet {
            if oldValue != self.selected {
                if self.selected == true {
                    self.select()
                } else {
                    self.deselect()
                }
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        self.selected = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.subviews.count == 0 {
            xibSetup()
        }
    }
    
    //TODO progress
    //TODO actions
    
    
    
    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
//        view.frame = CGRectMake(bounds.origin.x, bounds.origin.y, 50, 300);
//        view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 50, 300);
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
                addSubview(view)
    }
    
    func setTag(tagModel:Tag){
        tagTitle.setTitle(tagModel.value, forState: .Normal)
        //TODO set labels
        
        [ cameraButton, textButton, audioImage].forEach{
            $0.hidden = true
            $0.alpha = 0
            $0.center.x -= 50
        }
        
        tagProgress.progress = 0
    }

    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TagView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    // MARK: actions
    let duration = 0.5
    let delay = 0.0
    let springDamping = CGFloat(0.5)
    let springVelocity = CGFloat(0.5)
    
    //TODO toggle button selected state
    //TODO toggle visibility progress view
    //TODO default button background
    func select(){

        [ self.cameraButton, self.textButton, self.audioImage, self.tagProgress].forEach{
            $0.hidden = false
        }
        self.tagTitle.backgroundColor = UIColor.clearColor()
        
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations:
            {
                [ self.cameraButton, self.textButton, self.audioImage].forEach{
                    $0.alpha = 1
                    $0.center.x += 30
                }
                self.tagTitle.contentEdgeInsets.right += 20
                self.tagTitle.superview!.layoutIfNeeded()
                
            }, completion: { finished in
        })
    }
    
    func deselect(){
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations:
            {
                
                [ self.cameraButton, self.textButton, self.audioImage].forEach{
                    $0.alpha = 0
                    $0.center.x -= 0
                    
                }
                self.tagTitle.contentEdgeInsets.right -= 20
                self.tagTitle.superview!.layoutIfNeeded()
                self.tagProgress.progress = 0

        }, completion: { finished in
            [ self.cameraButton, self.textButton, self.audioImage, self.tagProgress].forEach{
                $0.hidden = true
            }
            self.tagTitle.backgroundColor = UIColor.GreenishTeal85Color()

        })
    }
}
