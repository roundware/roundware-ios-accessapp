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
    // MARK: Actions and Outlets
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    @IBAction func close(sender: AnyObject) {
    }

    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO set from project map url
        let url = NSURL(string: "https://jasonstravelsdotcom.files.wordpress.com/2013/03/national-gallery-of-art-west-building-map-washington-dc.jpg")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                self.imageScrollView.displayImage( UIImage(data: data!)!)
            });
        }
    }
}