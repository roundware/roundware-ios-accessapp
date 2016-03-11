//
//  ChooseProjectViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/23/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import RWFramework
class ChooseProjectViewController: UIViewController, UIScrollViewDelegate {

    // MARK: Actions and Outlets
    @IBAction func selectedThis(sender: UIButton) {
        //set selected projectName
        let projectName = sender.titleLabel?.text
        //select project from available projects
        let project = projects[projects.indexOf({$0.name == projectName})!]
        //set our singleton
        //NOTE not using dependcy injection because it's ugly with storyboards
        Project.sharedInstance = project
        //start framework
        let rwf = RWFramework.sharedInstance
        rwf.setProjectId(project.id)
        //TODO set project info in our model
        self.performSegueWithIdentifier("ProjectSegue", sender: project)
        //NOTE not using dependcy injection because it's
    }
    
    @IBOutlet weak var ProjectsScrollView: UIScrollView!

    // MARK: View

    let projects        = Project.availableProjects
    

    override func viewDidLoad() {
        //TODO check network
        
        super.viewDidLoad()
        super.view.addBackground("bg-blue.png")
        
        // populate buttons in a scrollview
        ProjectsScrollView.delegate = self
        var button  = UIButtonBorder(type: UIButtonType.System)
        let scroll = ProjectsScrollView
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
        let scroll = ProjectsScrollView
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated);
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}