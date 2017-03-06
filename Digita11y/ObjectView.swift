//
//  ObjectView.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit

@IBDesignable class ObjectView: UIView {

    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var objectProgress: UIProgressView!
    @IBOutlet weak var objectTitle: UIButton!
    @IBOutlet weak var audioImage: UIImageView!

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
    var audioAssets : [Asset] = []

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
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
                addSubview(view)
    }

    func setObject(_ tagModel:Tag, index: Int, total: Int){
//        debugPrint("setting tag for \(tagModel.id) at index \(index)")
//        debugPrint("hasImage \(String(hasImages)) and hasText \(String(hasTexts))")
        objectTitle.setTitle(tagModel.locMsg, for: UIControlState())
        objectTitle.accessibilityLabel = tagModel.locMsg + ", \(index + 1) of \(total)"


        id = tagModel.id
        let subviews : [UIView] = [audioImage, textButton, cameraButton, objectProgress]

        subviews.forEach{
            $0.isHidden = true
            $0.alpha = 0
            $0.center.x -= 50
        }
        objectProgress.progress = 0
//        objectProgress.layer.cornerRadius = 0.0

        self.cameraButton.accessibilityLabel = "Images for " + tagModel.locMsg
        self.textButton.accessibilityLabel = "Texts for " + tagModel.locMsg
        self.objectProgress.accessibilityLabel = "Progress of " + tagModel.locMsg

        self.layoutIfNeeded()

    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ObjectView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    // MARK: actions
    let duration = 0.5
    let delay = 0.0
    let springDamping = CGFloat(0.5)
    let springVelocity = CGFloat(0.5)

    func select(){
        self.selected = true
        self.objectTitle.isSelected = true

        var hiddenSubviews      : [UIView] = [self.audioImage, self.objectProgress]

        if hasImages {
            hiddenSubviews.append(self.cameraButton)
        }
        if hasTexts {
            hiddenSubviews.append(self.textButton)
        }

        hiddenSubviews.forEach{
            $0.isHidden = false
        }

//        self.objectTitle.backgroundColor = UIColor.clearColor()

        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations:
            {
                hiddenSubviews.forEach{
                    $0.alpha = 1
                    $0.center.x += 30
                }
                self.objectTitle.contentEdgeInsets.right += 20
                self.objectTitle.superview!.layoutIfNeeded()

            }, completion: { finished in
        })
    }

    func deselect(){
        self.selected = false
        self.objectTitle.isSelected = false

        var hiddenSubviews      : [UIView] = [self.audioImage, self.objectProgress]
        if hasImages {
            hiddenSubviews.append(self.cameraButton)
        }
        if hasTexts {
            hiddenSubviews.append(self.textButton)
        }

        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations:
            {

                hiddenSubviews.forEach{
                    $0.alpha = 0
                    $0.center.x -= 0

                }
                self.objectTitle.contentEdgeInsets.right -= 20
                self.objectTitle.superview!.layoutIfNeeded()
                self.objectProgress.progress = 0

        }, completion: { finished in
            hiddenSubviews.forEach{
                $0.isHidden = true
            }
//            self.objectTitle.backgroundColor = UIColor.GreenishTeal85Color()

        })
    }
}
