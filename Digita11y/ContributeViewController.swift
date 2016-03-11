//
//  ContributeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import Foundation
class ContributeViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var ContributeAsk: UILabelHeadline!
    @IBOutlet weak var ContributeScroll: UIScrollView!
    
    
    @IBAction func tagSelected(sender: AnyObject) {
        //TODO check for more uigroups
        //TODO add to tag group
    }
    
    @IBAction func unwind(sender: AnyObject) {
        //TODO unwind subviews....
    }
    
    
    @IBAction func mediaSelected(sender: AnyObject) {
        //TODO launch gallery subview/modal
    }
    
    @IBAction func audioToggle(sender: AnyObject) {
        //TODO launch text subview/modal
    }
    
    @IBAction func textToggle(sender: AnyObject) {
        //TODO launch text subview/modal
    }
    
    @IBAction func upload(sender: AnyObject) {
        //TODO launch text subview/modal
    }

    
    //TODO should be current tag
    let project = Project.sharedInstance

    
    override func viewDidLoad() {
        //TODO add close to navbar
        super.viewDidLoad()
        super.view.addBackground("bg-comment.png")

        
        //Scroll view for subviews of tags
        ContributeAsk.text = "How would you like to contribute to \(project!.name)!"
        ContributeScroll.delegate =  self
        
        var button  = UIButtonBorder(type: UIButtonType.System)
        let scroll = ContributeScroll
        let tags = [1,2,3]
        let total = CGFloat(tags.count)
        
        for index in 0..<tags.count {
            let tag = tags[index]
            button  = UIButtonBorder(type: UIButtonType.System)
            let indexFloat = CGFloat(index)
            let frame = CGRect(
                x: button.buttonMarginX,
                y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                width: button.buttonWidth,
                height: button.buttonHeight )
            button.frame = frame
            
            //set title
            button.setTitle(String(tag), forState: .Normal)
            
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
        let scroll = ContributeScroll
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}