//
//  WelcomeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
class WelcomeViewController: UIViewController {
    @IBOutlet weak var WelcomeLabelBody: UILabelBody!
    @IBOutlet weak var WelcomeLabelHeadline: UILabelHeadline!

    let project = currentProject! as Project
    
    override func viewDidLoad() {
        print("Selected project: \(project.name)")
        WelcomeLabelHeadline.text = "Welcome to the \(project.name)!"
        super.viewDidLoad()
        super.view.addBackground("bg-blue.png")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}