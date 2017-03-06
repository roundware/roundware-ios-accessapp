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
    @IBAction func next(_ sender: AnyObject) {
        //TODOnow needs a hint "requests location services permissions"
        DebugLog("getting location authorization")
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.performSegue(withIdentifier: "ExhibitSegue", sender: nil)
        } else {
            DebugLog("requesting location when in use")
            locationManager.requestWhenInUseAuthorization()
        }
    }

    @IBAction func noThanks(_ sender: AnyObject) {
        //No Thanks
        self.performSegue(withIdentifier: "ExhibitSegue", sender: nil)
    }


    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.view.addBackground("bg-green.png")
        locationManager.delegate = self
    }


    // MARK: LocationManager Protocol

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DebugLog("authorization status changed")
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.performSegue(withIdentifier: "ExhibitSegue", sender: nil)
        } else {
            //TODO
            DebugLog("location not authorized but needed?")
        }
    }
}
