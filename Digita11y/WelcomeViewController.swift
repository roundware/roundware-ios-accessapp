//
//  WelcomeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import CoreLocation
class WelcomeViewController: BaseViewController, UINavigationControllerDelegate, CLLocationManagerDelegate {
    var viewModel: WelcomeViewModel!
    var viewControllerToInsertBelow : UIViewController?

    
    // MARK: Actions and Outlets
    @IBAction func next(sender: UIButton) {

        if (CLLocationManager.authorizationStatus() == .NotDetermined) {
//            debugPrint("not determined")
            self.performSegueWithIdentifier("LocationSegue", sender: nil)
        } else {
//            debugPrint(CLLocationManager.authorizationStatus())
            self.performSegueWithIdentifier("SkipToExhibitSegue", sender: nil)
        }
    }
    
    @IBOutlet weak var WelcomeLabelBody: UILabelBody!
    @IBOutlet weak var WelcomeLabelHeadline: UILabelHeadline!
    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        self.viewModel = WelcomeViewModel(data: self.rwData!)
        WelcomeLabelHeadline.text = self.viewModel.title
        WelcomeLabelBody.text = self.viewModel.body
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-blue.png")
    }    
}