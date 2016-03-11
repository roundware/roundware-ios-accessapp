//
//  ChooseExhibitViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import RWFramework
class ChooseExhibitController: UIViewController, UIScrollViewDelegate {
    // MARK: Actions and Outlets

    @IBOutlet weak var ExhibitHeadline: UILabelHeadline!
    @IBOutlet weak var ExhibitScroll: UIScrollView!

    @IBAction func selectedThis(sender: UIButton) {
        //TODO set child tags and send as dependency
        self.performSegueWithIdentifier("TagsSegue", sender: nil)
    }
    
    
    // MARK: View
    let projects = Project.availableProjects

    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-blue.png")

        let project = Project.sharedInstance
        let rwf = RWFramework.sharedInstance
        
        
        //TODO get ui group for listen
        //TODO get tags
        //NOTE Halsey: Unfortunately, other tags that are cross-exhibition (like male/female) have null parents, so I don’t think that is good enough, but perhaps null parents AND ui_group index=0?
        //        var a: AnyObject? = getListenTags() // if needed to get various codes, etc.
        //TODO guard
        
        
        // setup scrollview
        ExhibitScroll.delegate = self
        let scroll = ExhibitScroll
        ExhibitHeadline.text = "Welcome to the \(project!.name)! \n Hear some... choose one of the following."
        
        var button  = UIButtonBorder(type: UIButtonType.System)

        let tagsData: AnyObject? = rwf.getListenTags()
        let tags = (tagsData as? NSArray) as Array?
        let tag = tags?.first as? [String: AnyObject]
        print(tag)
        var total = 0
        //TODO ok i'll use guard syntax!
        if let options = tag!["options"] as? [AnyObject]{
            total = options.count
            for index in 0..<options.count {
                if let option = options[index] as? [String: AnyObject]{
                    //make the button
                    button  = UIButtonBorder(type: UIButtonType.System)
                    let indexFloat = CGFloat(index)
                    let frame = CGRect(
                        x: button.buttonMarginX,
                        y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                        width: button.buttonWidth,
                        height: button.buttonHeight )
                    button.frame = frame
                    
                    //set title
                    let description = option["description"] as? String
                    print("option \(index)")
                    print(option)
                    print(description)
                    button.setTitle(description, forState: .Normal)
                    
                    //set action
                    button.addTarget(self,
                        action: "selectedThis:",
                        forControlEvents: UIControlEvents.TouchUpInside)
                    scroll.addSubview(button)
                }
            }
        }

        scroll.contentSize.width = button.buttonWidth + CGFloat(2)
        scroll.contentSize.height = (button.buttonHeight + button.buttonMarginY) * CGFloat(total)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        // set scroll view
        let scroll = ExhibitScroll
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Extension

extension ChooseExhibitController: RWFrameworkProtocol {
    func rwGetProjectsIdTagsSuccess(data: NSData?) {
        let rwf = RWFramework.sharedInstance
        rwf.requestWhenInUseAuthorizationForLocation()
        print(data)
    }
}
    