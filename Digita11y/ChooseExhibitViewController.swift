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
    @IBOutlet weak var ExhibitHeadline: UILabelHeadline!
    @IBOutlet weak var ExhibitScroll: UIScrollView!

    let projects = Project.availableProjects

    @IBAction func selectedThis(sender: UIButton) {
        let projectName = sender.titleLabel?.text
        let project = projects[projects.indexOf({$0.name == projectName})!]
        //TODO end of new project selected
        
        let rwf = RWFramework.sharedInstance
        rwf.setProjectId(project.id)
        rwf.start()
        Project.sharedInstance = project
        self.performSegueWithIdentifier("TagsSegue", sender: nil)
    }
    
    let buttonHeight    = 54 //     button.intrinsicContentSize()
    let buttonWidth     = 306 //     button.intrinsicContentSize()
    let buttonMarginX   = 0
    let buttonMarginY   = 21
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO get available exhibits
        //or set available exhibits
        let project = Project.sharedInstance


        ExhibitHeadline.text = "Welcome to the \(project!.name)! Hear some... choose one of the following."

        // populate buttons in a scrollview
        ExhibitScroll.delegate = self
        for index in 0..<projects.count {
            let project = projects[index]
            let frame = CGRect(x: buttonMarginX, y: index * (buttonMarginY + buttonHeight), width: buttonWidth, height: buttonHeight )
            let button  = UIButtonBorder(type: UIButtonType.System) as UIButton
            
            button.frame = frame
            button.setTitle(project.name, forState: .Normal)
            print(project.name)
            button.addTarget(self, action: "selectedThis:", forControlEvents: UIControlEvents.TouchUpInside)
            ExhibitScroll.addSubview(button)
        }
        super.view.addBackground("bg-blue.png")
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        // set scroll view
        let target = ExhibitScroll
        target.contentSize.width = CGFloat((buttonWidth) + 2)
        target.contentSize.height = CGFloat((buttonHeight + buttonMarginY)*projects.count)
        let newContentOffsetX = (target.contentSize.width/2) - (target.bounds.size.width/2)
        target.contentOffset = CGPointMake(newContentOffsetX, 0)
        
        //debug for multiple runs
        //print(ProjectsScrollView.contentSize.width)
        //print(ProjectsScrollView.bounds.size.width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}