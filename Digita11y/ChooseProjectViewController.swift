//
//  ChooseProjectViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/23/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
class ChooseProjectViewController: BaseViewController, UIScrollViewDelegate {
    var viewModel: ChooseProjectViewModel!

    // MARK: Outlets and Actions
    @IBOutlet weak var ProjectsScrollView: UIScrollView!

    @IBAction func selectedThis(sender: UIButton) {
        let projectId = sender.tag
        self.viewModel.selectedProject = self.viewModel.data.getProjectById(projectId)
        self.performSegueWithIdentifier("ProjectSegue", sender: sender)
    }
    

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        super.view.addBackground("bg-blue.png")
        
        self.viewModel = ChooseProjectViewModel(data: self.rwData!)
        
        //set scroll view for options
        let scroll = ProjectsScrollView
        scroll.delegate = self
        let total = self.viewModel.projects.count
        let buttons = self.createButtonsForScroll(total, scroll: scroll)
        
        //set titles and action
        for (index, button) in buttons.enumerate(){
            let project = viewModel.projects[index]
            button.setTitle(project.name, forState: .Normal)
            button.addTarget(self,
                             action: "selectedThis:",
                             forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = project.id
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //hide nav bar on this page
        self.navigationController!.setNavigationBarHidden(true, animated: true)

    }
    
    override func viewWillDisappear(animated: Bool) {
        //show nav bar everywhere else
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated);
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        //correct offset for scrollview
        let scroll = ProjectsScrollView
        let newContentOffsetX = (scroll.contentSize.width - scroll.bounds.size.width) / 2
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }

}