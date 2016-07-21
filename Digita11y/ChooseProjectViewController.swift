//
//  ChooseProjectViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/23/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import RWFramework
import SwiftyJSON
import SVProgressHUD

class ChooseProjectViewController: BaseViewController, UIScrollViewDelegate, RWFrameworkProtocol {
    var viewModel: ChooseProjectViewModel!

    // MARK: Outlets and Actions
    @IBOutlet weak var ProjectsScrollView: UIScrollView!

    @IBAction func selectedThis(sender: UIButton) {
        let projectId = sender.tag
        SVProgressHUD.showWithStatus("Loading project data")
        let rwf = RWFramework.sharedInstance
        self.viewModel.selectedProject = self.viewModel.data.getProjectById(projectId)
        rwf.setProjectId(String(projectId))
        RWFrameworkConfig.setConfigValue("reverse_domain", value: String(self.viewModel.selectedProject?.reverseDomain))
    }


    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()

        let rwf = RWFramework.sharedInstance
        rwf.addDelegate(self)

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
            if(self.viewModel.projects[index].active == false){
                button.enabled = false
            }
            button.accessibilityLabel = project.name + ", \(index + 1) of \(buttons.count)"
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
        super.viewWillDisappear(animated);
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        //correct offset for scrollview
        let scroll = ProjectsScrollView
        let newContentOffsetX = (scroll.contentSize.width - scroll.bounds.size.width) / 2
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }

    func rwGetProjectsIdSuccess(data: NSData?) {
        let json = JSON(data: data!)
        print("projects id json")
        //TODO update project model and corresponding functionality with info from JSON
//        dump(json)
        SVProgressHUD.dismiss()
        self.performSegueWithIdentifier("ProjectSegue", sender: nil)
    }
}
