//
//  WelcomeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import CoreLocation
class WelcomeViewController: BaseViewController, CLLocationManagerDelegate {
    var viewModel: WelcomeViewModel!
    
    
    // MARK: Actions and Outlets
    @IBAction func next(sender: UIButton) {
        if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            debugPrint("authorized when in use")
            self.performSegueWithIdentifier("SkipToExhibitSegue", sender: nil)
        } else {
            debugPrint(CLLocationManager.authorizationStatus())
            self.performSegueWithIdentifier("LocationSegue", sender: nil)
        }
    }
    
    @IBOutlet weak var WelcomeLabelBody: UILabelBody!
    @IBOutlet weak var WelcomeLabelHeadline: UILabelHeadline!
    
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        super.view.addBackground("bg-blue.png")
        self.viewModel = WelcomeViewModel(data: self.rwData!)
        WelcomeLabelHeadline.text = self.viewModel.title
        WelcomeLabelBody.text = self.viewModel.body
    }
}