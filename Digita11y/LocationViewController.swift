//
//  LocationViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import CoreLocation
class LocationViewController: UIViewController {
    // MARK: Actions and Outlets

    @IBAction func getLocationPermission(sender: AnyObject) {
        //TODO set location ask text
        let locationManager: CLLocationManager = CLLocationManager()
        //var lastRecordedLocation: CLLocation = CLLocation()
        locationManager.requestWhenInUseAuthorization()
        self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
    }
    
    @IBAction func next(sender: AnyObject) {
        //No Thanks
        self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
    }

    

    
    // MARK: View
    
    override func viewDidLoad() {
        //TODO skip this view controller if permission available
        super.viewDidLoad()
        super.view.addBackground("bg-green.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}