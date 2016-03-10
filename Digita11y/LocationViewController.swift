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
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-green.png")
    }
    
    @IBAction func getLocationPermission(sender: AnyObject) {
        //TODO get locationpermission
        let locationManager: CLLocationManager = CLLocationManager()
//        var lastRecordedLocation: CLLocation = CLLocation()
        locationManager.requestWhenInUseAuthorization()
        self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
    }
    @IBAction func next(sender: AnyObject) {
        self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}