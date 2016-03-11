//
//  ContributeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
class ContributeViewController: UIViewController {
    
    @IBOutlet weak var ContributeAsk: UILabelHeadline!
    
    //TODO should be current tag
    let project = Project.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        ContributeAsk.text = "How would you like to contribute to \(project!.name)!"
        super.view.addBackground("bg-comment.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}