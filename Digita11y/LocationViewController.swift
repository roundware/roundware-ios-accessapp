//
//  LocationViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import CoreLocation
import RWFramework
class LocationViewController: BaseViewController, RWFrameworkProtocol, CLLocationManagerDelegate {
    
    
    // MARK: Actions and Outlets
    @IBAction func next(sender: AnyObject) {
        //TODO needs a hint "requests location services permissions"
        let rwf = RWFramework.sharedInstance
        if !rwf.requestWhenInUseAuthorizationForLocation() || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
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
    }
    
    
    // MARK: RWFramework Protocol
    //TODO not quite working, might need to do with CLLocation manage delegate...
    func rwLocationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        debugPrint("authorization status changed")
        self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
    }
    
    // MARK: LocationManager Protocol

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        debugPrint("authorization status changed")
        self.performSegueWithIdentifier("ExhibitSegue", sender: nil)
    }
}