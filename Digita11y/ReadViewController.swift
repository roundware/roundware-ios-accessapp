//
//  ReadViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//
import UIKit
class ReadViewController: BaseViewController {
    var viewModel: ReadViewModel!
    
    @IBAction func close(sender: AnyObject) {
        self.performSegueWithIdentifier("closeRead", sender: sender)
    }
    @IBOutlet weak var prompt: UILabel!
    @IBOutlet weak var response: UILabelBody!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ReadViewModel(data: self.rwData!)
        prompt.text = self.viewModel.prompt
        response.text = self.viewModel.response
    }
}