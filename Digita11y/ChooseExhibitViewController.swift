//
//  ChooseExhibitViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import RWFramework
import SwiftyJSON
import Crashlytics
class ChooseExhibitController: BaseViewController, UIScrollViewDelegate {
    var viewModel: ChooseExhibitViewModel!

    // MARK: Actions and Outlets

    @IBOutlet weak var ExhibitHeadline: UILabelHeadline!
    @IBOutlet weak var ExhibitScroll: UIScrollView!

    @IBAction func selectedThis(sender: UIButton) {
        //TODO set child tags and send as dependency
        self.performSegueWithIdentifier("TagsSegue", sender: nil)
    }
    
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-blue.png")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = ChooseExhibitViewModel(data: self.rwData!)
        dump(self.viewModel.exhibitions)
        
        // setup scrollview
        ExhibitHeadline.text = "Welcome to the \(self.viewModel.project.name)! \n Hear some... choose one of the following."
        let scroll = ExhibitScroll
        scroll.delegate = self
        let total = self.viewModel.numberOfExhibits()
        let buttons = self.createButtonsForScroll(total, scroll: scroll)
        
        //set titles and actions
        for (index, button) in buttons.enumerate(){
            button.setTitle(viewModel.titleForIndex(index), forState: .Normal)
            button.addTarget(self,
                action: "selectedThis:",
                forControlEvents: UIControlEvents.TouchUpInside)
        }

    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        // set scroll view
        let scroll = ExhibitScroll
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }


}