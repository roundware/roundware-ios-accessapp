//
//  WelcomeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
class WelcomeViewController: UIViewController {
    // MARK: Actions and Outlets

    @IBAction func next(sender: UIButton) {
        //TODO skip location ask if available
        self.performSegueWithIdentifier("LocationSegue", sender: nil)
    }
    
    @IBOutlet weak var WelcomeLabelBody: UILabelBody!
    @IBOutlet weak var WelcomeLabelHeadline: UILabelHeadline!
    
    // MARK: View

    let project = Project.sharedInstance! as Project
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-blue.png")
        
        WelcomeLabelHeadline.text = "Welcome to the \(project.name)!"
        WelcomeLabelBody.text = project.welcome
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}