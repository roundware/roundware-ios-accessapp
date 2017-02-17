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

    // MARK: Outlets and Actions

    @IBOutlet weak var prompt: UILabel!
    @IBOutlet weak var responses: UIStackView!

    @IBAction func close(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "closeRead", sender: sender)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ReadViewModel(data: self.rwData!)
        prompt.text = self.viewModel.prompt
        //TODO as separate ui items
        self.viewModel.responses.forEach { (text) in
            let body = UILabelBody()
            body.text = text
            DebugLog(text)
            responses.addArrangedSubview(body)
        }
    }
}
