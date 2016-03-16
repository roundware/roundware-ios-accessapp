//
//  ChooseProjectViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/23/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import RWFramework
class ChooseProjectViewController: BaseViewController, UIScrollViewDelegate {
    var viewModel: ChooseProjectViewModel!

    // MARK: Actions and Outlets
    @IBAction func selectedThis(sender: UIButton) {
        let projectName = sender.titleLabel?.text
        self.viewModel.selectByTitle(projectName!)
        self.performSegueWithIdentifier("ProjectSegue", sender: sender)
    }
    
    @IBOutlet weak var ProjectsScrollView: UIScrollView!

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-blue.png")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //hide nav bar on this page
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        
        self.viewModel = ChooseProjectViewModel(data: self.rwData!)
        
        let scroll = ProjectsScrollView
        scroll.delegate = self
        let total = self.viewModel.numberOfProjects()
        let buttons = self.createButtonsForScroll(total, scroll: scroll)
        
        //set titles and actions
        for (index, button) in buttons.enumerate(){
            button.setTitle(viewModel.titleForIndex(index), forState: .Normal)
            button.addTarget(self,
                action: "selectedThis:",
                forControlEvents: UIControlEvents.TouchUpInside)
        }
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
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }

}