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

    @IBAction func selectedThis(_ sender: UIButton) {
        self.viewModel.selectedTag = self.viewModel.data.getTagById(sender.tag)
        self.performSegue(withIdentifier: "RoomsSegue", sender: nil)
    }

    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.view.addBackground("bg-blue.png")

        self.viewModel = ChooseExhibitViewModel(data: self.rwData!)
        ExhibitHeadline.text = self.viewModel.title

        //scroll
        let scroll = ExhibitScroll
        scroll?.delegate = self
        let titles = self.viewModel.tags.map{$0.locMsg}
        let buttons = self.createButtonsForScroll(titles, scroll: scroll!)

        for (index, button) in buttons.enumerated(){
            let tag = self.viewModel.tags[index]
            let uiItem = self.viewModel.uiItems[index]
            if(uiItem.active == false || self.rwData?.getChildren(uiItem).count == 0){
                button.isEnabled = false
            }
            button.accessibilityLabel = tag.locMsg + ", \(index + 1) of \(buttons.count)"

            button.addTarget(self,
                             action: #selector(ChooseExhibitController.selectedThis(_:)),
                             for: UIControlEvents.touchUpInside)
            button.tag = tag.id
        }
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()

        //scroll
        let scroll = ExhibitScroll
        let newContentOffsetX = ((scroll?.contentSize.width)! - (scroll?.bounds.size.width)!) / 2
        scroll?.contentOffset = CGPoint(x: newContentOffsetX, y: 0)
    }
}
