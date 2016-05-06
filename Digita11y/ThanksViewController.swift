//
//  ThanksViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
class ThanksViewController: BaseViewController, UIScrollViewDelegate {
    var viewModel: ThanksViewModel!

    // MARK: Actions and Outlets

    @IBOutlet weak var ThanksScroll: UIScrollView!
    
    @IBAction func selectedThis(sender: UIButton) {
        self.performSegueWithIdentifier("Recontribute", sender: nil)
    }
    
    @IBAction func noThanks(sender: UIButton) {
        self.performSegueWithIdentifier("NoThanksSegue", sender: nil)
    }

    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.viewModel = ThanksViewModel(data: self.rwData!)

        //Scroll view for subviews of tags
        let scroll = ThanksScroll
        scroll.delegate = self
        let tags = self.viewModel.tags
        let total = tags.count
        let buttons = createTagButtonsForScroll(total, scroll: scroll)
        //set titles and actions
        for (index, button) in buttons.enumerate(){
            let tag = tags[index]
            button.setTitle(tag.value, forState: .Normal)
            button.addTarget(self,
                             
                             action: #selector(self.selectedThis(_:)),
                             forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = tag.id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}