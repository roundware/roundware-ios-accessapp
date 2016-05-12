//
//  ChooseExhibitViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import Crashlytics
class ChooseExhibitController: BaseViewController, UIScrollViewDelegate {
    var viewModel: ChooseExhibitViewModel!

    // MARK: Outlets and Actions
    @IBOutlet weak var ExhibitHeadline: UILabelHeadline!
    @IBOutlet weak var ExhibitScroll: UIScrollView!

    @IBAction func selectedThis(sender: UIButton) {
        self.viewModel.selectedTag = self.viewModel.data.getTagById(sender.tag)
        self.performSegueWithIdentifier("TagsSegue", sender: nil)
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        super.view.addBackground("bg-blue.png")
        
        self.viewModel = ChooseExhibitViewModel(data: self.rwData!)
        ExhibitHeadline.text = self.viewModel.title
        
        //scroll
        let scroll = ExhibitScroll
        scroll.delegate = self
        let total = self.viewModel.tags.count
        let buttons = self.createButtonsForScroll(total, scroll: scroll)
        
        for (index, button) in buttons.enumerate(){
            let tag = self.viewModel.tags[index]
            button.setTitle(tag.value, forState: .Normal)
            button.addTarget(self,
                             action: #selector(ChooseExhibitController.selectedThis(_:)),
                             forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = tag.id
        }
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        //scroll
        let scroll = ExhibitScroll
        let newContentOffsetX = (scroll.contentSize.width - scroll.bounds.size.width) / 2
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
}