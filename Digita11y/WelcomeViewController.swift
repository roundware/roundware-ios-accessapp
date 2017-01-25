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

    // MARK: Outlets and Actions
    @IBOutlet weak var WelcomeLabelBody: UILabelBody!
    @IBOutlet weak var WelcomeLabelHeadline: UILabelHeadline!
    @IBOutlet weak var WelcomeLogo: UIImageView!


    @IBAction func next(_ sender: UIButton) {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            DebugLog("authorized when in use")
            self.performSegue(withIdentifier: "SkipToExhibitSegue", sender: nil)
        } else {
            DebugLog("location not authorized for in use")
            debugPrint(CLLocationManager.authorizationStatus())
            self.performSegue(withIdentifier: "LocationSegue", sender: nil)
        }
    }

    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.view.addBackground("bg-blue.png")
        self.viewModel = WelcomeViewModel(data: self.rwData!)
        WelcomeLabelHeadline.text = self.viewModel.title
        WelcomeLabelBody.text = self.viewModel.body
//        dump(self.viewModel.logoImage)
        if (self.viewModel.logoImage != nil) {
            WelcomeLogo.image = self.viewModel.logoImage
        }
    }
}
