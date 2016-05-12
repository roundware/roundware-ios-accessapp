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

    // MARK: Outlets and Actions

    @IBOutlet weak var ThanksScroll: UIScrollView!
    @IBOutlet weak var thanksHeadline: UILabelHeadline!
    @IBOutlet weak var thanksBody: UILabelBody!

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
        thanksHeadline.text = self.viewModel.title

        thanksBody.text = "While you’re on a roll would you care to contribute another for: " + self.viewModel.uiGroup.headerTextLoc
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()

        //scroll
        let scroll = ThanksScroll
        let newContentOffsetX = (scroll.contentSize.width - scroll.bounds.size.width) / 2
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
