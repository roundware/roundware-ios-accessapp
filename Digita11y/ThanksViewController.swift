//
//  ThanksViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
class ThanksViewController: UIViewController, UIScrollViewDelegate {
    // MARK: Actions and Outlets

    @IBOutlet weak var ThanksScroll: UIScrollView!
    
    @IBAction func selectedThis(sender: UIButton) {
        //TODO set tags and send as dependency
        self.performSegueWithIdentifier("TagsSegue", sender: nil)
        //TODO get available exhibits via tags
    }
    
    @IBAction func GoToTagsView(sender: AnyObject) {
        
    }
    
    // MARK: View
    let projects = Project.availableProjects

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Scroll view for subviews of tags
        ThanksScroll.delegate = self
        var button  = UIButtonBorder(type: UIButtonType.System)
        let scroll = ThanksScroll
        let total = CGFloat(projects.count)
        
        for index in 0..<projects.count {
            let project = projects[index]
            button  = UIButtonBorder(type: UIButtonType.System)
            let indexFloat = CGFloat(index)
            let frame = CGRect(
                x: button.buttonMarginX,
                y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                width: button.buttonWidth,
                height: button.buttonHeight )
            button.frame = frame
            
            //set title
            button.setTitle(project.name, forState: .Normal)
            
            //set action
            button.addTarget(self,
                action: "selectedThis:",
                forControlEvents: UIControlEvents.TouchUpInside)
            scroll.addSubview(button)
        }
        scroll.contentSize.width = button.buttonWidth + CGFloat(2)
        scroll.contentSize.height = (button.buttonHeight + button.buttonMarginY) * total
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        // set scroll view
        let scroll = ThanksScroll
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}