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

    var id : Int?
    var arrayOfAssetIds : [String] = []
    var currentAssetIndex : Int = 0
    var totalLength : Float = 0.0

    var hasTexts: Bool = false
    var hasImages: Bool = false

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

    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
//        view.frame = CGRectMake(bounds.origin.x, bounds.origin.y, 50, 300);
//        view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 50, 300);
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
                addSubview(view)
    }

    func setTag(tagModel:Tag, index: Int){
        debugPrint("setting tag for \(tagModel.id) at index \(index)")
        debugPrint("hasImage \(String(hasImages)) and hasText \(String(hasTexts))")
        tagTitle.setTitle(tagModel.value, forState: .Normal)
        id = tagModel.id
        var subviews : [UIView] = [audioImage, textButton, cameraButton, tagProgress]

        subviews.forEach{
            $0.hidden = true
            $0.alpha = 0
            $0.center.x -= 50
        }
        tagProgress.progress = 0

        self.cameraButton.accessibilityLabel = "Images for " + tagModel.value
        self.textButton.accessibilityLabel = "Texts for " + tagModel.value
        self.tagProgress.accessibilityLabel = "Progress of " + tagModel.value

        self.layoutIfNeeded()

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

    func select(){
        self.selected = true
        self.tagTitle.selected = true

        var hiddenSubviews      : [UIView] = [self.audioImage, self.tagProgress]

        if hasImages {
            hiddenSubviews.append(self.cameraButton)
        }
        if hasTexts {
            hiddenSubviews.append(self.textButton)
        }

        hiddenSubviews.forEach{
            $0.hidden = false
        }

//        self.tagTitle.backgroundColor = UIColor.clearColor()

        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations:
            {
                hiddenSubviews.forEach{
                    $0.alpha = 1
                    $0.center.x += 30
                }
                self.tagTitle.contentEdgeInsets.right += 20
                self.tagTitle.superview!.layoutIfNeeded()

            }, completion: { finished in
        })
    }

    func deselect(){
        self.selected = false
        self.tagTitle.selected = false

        var hiddenSubviews      : [UIView] = [self.audioImage, self.tagProgress]
        if hasImages {
            hiddenSubviews.append(self.cameraButton)
        }
        if hasTexts {
            hiddenSubviews.append(self.textButton)
        }

        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations:
            {

                hiddenSubviews.forEach{
                    $0.alpha = 0
                    $0.center.x -= 0

                }
                self.tagTitle.contentEdgeInsets.right -= 20
                self.tagTitle.superview!.layoutIfNeeded()
                self.tagProgress.progress = 0

        }, completion: { finished in
            hiddenSubviews.forEach{
                $0.hidden = true
            }
//            self.tagTitle.backgroundColor = UIColor.GreenishTeal85Color()

        })
    }
}
