//
//  LocationViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import CoreLocation
class LocationViewController: BaseViewController, CLLocationManagerDelegate {
    let locationManager =  CLLocationManager()

    // MARK: Outlets and Actions
    @IBAction func next(sender: AnyObject) {
        //TODO needs a hint "requests location services permissions"
        debugPrint("getting location authorization")
        let status = CLLocationManager.authorizationStatus()
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
        } else {
            debugPrint("request in use")
            locationManager.requestWhenInUseAuthorization()
        }
    }

    @IBAction func noThanks(sender: AnyObject) {
        //No Thanks
        self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
    }
    
    
    // MARK: View
    override func viewDidLoad() {
        //TODO skip this view controller if permission available
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        super.view.addBackground("bg-green.png")
        locationManager.delegate = self
    }

    
    // MARK: LocationManager Protocol

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        debugPrint("authorization status changed")
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
        } else {
            //TODO warning
            debugPrint("we need your location")
        }
    }
}