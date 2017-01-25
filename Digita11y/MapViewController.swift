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

    @IBAction func close(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "closeMap", sender: sender)
    }


    // MARK: View
    override func viewDidLoad() {
        self.viewModel = MapViewModel(data: self.rwData!)

        super.viewDidLoad()
        
        let url = URL(string: self.viewModel.mapURL)
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            DispatchQueue.main.async(execute: {
                self.imageScrollView.display(image: UIImage(data: data!)!)
            });
        }
    }
}
