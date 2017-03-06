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

    @IBAction func selectedThis(_ sender: UIButton) {
        self.viewModel.uiGroup.selectedUIItem = self.viewModel.uiGroup.uiItems.filter({$0.tagId == sender.tag}).first
        DebugLog("selected tag id \(sender.tag)")
//        dump(self.viewModel.uiGroup.selectedUIItem )
        self.viewModel.data.updateUIGroup(self.viewModel.uiGroup)
        self.performSegue(withIdentifier: "Recontribute", sender: nil)
    }

    @IBAction func noThanks(_ sender: UIButton) {
        self.performSegue(withIdentifier: "NoThanksSegue", sender: nil)
    }

    // MARK: View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ThanksViewModel(data: self.rwData!)
        thanksHeadline.text = self.viewModel.title
        thanksBody.text = "While you’re on a roll would you care to contribute another for: " + self.viewModel.uiGroup.headerTextLoc

        //Scroll view for subviews of tags
        let scroll = ThanksScroll
        scroll?.delegate = self
        let tags = self.viewModel.tags
        let total = tags.count
        let buttons = createCenteredTagButtonsForScroll(total, scroll: scroll!)

        //set titles and actions
        for (index, button) in buttons.enumerated(){
            let tag = tags[index]
            button.setTitle(tag.locMsg, for: UIControlState())
            button.accessibilityLabel = tag.locMsg + ", \(index + 1) of \(buttons.count)"
            button.addTarget(self,
                             action: #selector(self.selectedThis(_:)),
                             for: UIControlEvents.touchUpInside)
            button.tag = tag.id
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
    }
    
}
