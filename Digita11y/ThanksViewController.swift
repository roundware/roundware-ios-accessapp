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
        //TODO set tags and send as dependency
        self.performSegueWithIdentifier("TagsSegue", sender: nil)
        //TODO get available exhibits via tags
    }
    
    @IBAction func GoToTagsView(sender: AnyObject) {
        
    }
    

    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = ThanksViewModel(data: self.rwData!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Scroll view for subviews of tags
        let scroll = ThanksScroll
        scroll.delegate = self
        let total = self.viewModel.numberOfTags()
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
        let scroll = ThanksScroll
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}