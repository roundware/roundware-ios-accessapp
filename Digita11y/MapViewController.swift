//
//  MapViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/12/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import ImageScrollView
class MapViewController: BaseViewController {
    var viewModel: MapViewModel!

    // MARK: Outlets and Actions

    @IBOutlet weak var imageScrollView: ImageScrollView!

    @IBAction func close(sender: AnyObject) {
        self.performSegueWithIdentifier("closeMap", sender: sender)
    }


    // MARK: View
    override func viewDidLoad() {
        self.viewModel = MapViewModel(data: self.rwData!)

        super.viewDidLoad()
        
        let url = NSURL(string: self.viewModel.mapURL)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                self.imageScrollView.displayImage( UIImage(data: data!)!)
            });
        }
    }
}
