//
//  ContributeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import Foundation
import RWFramework
class ContributeViewController: BaseViewController, UIScrollViewDelegate, RWFrameworkProtocol{
    var viewModel: ContributeViewModel!

    // MARK: Actions and Outlets
    
    @IBAction func selectTag(sender: AnyObject) {
        //TODO segue to self and stack 
        //TODO or move forward
    }
    
    @IBAction func unwind(sender: AnyObject) {
        //TODO unwind subviews back to subview on cancel
    }
    
    @IBAction func selectAudio(sender: AnyObject) {
        //TODO setup audio (for recording, right?)
        //        setupAudio() { granted, error in
        //            if granted == false {
        //                debugPrint("Unable to setup audio: \(error)")
        //                if let error = error {
        //                    CLSNSLogv("Unable to setup audio: \(error)", getVaList([error]))
        //                }
        //            }
        //        }
        //TODO launch text subview/modal
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        //TODO 
    }
    
    @IBAction func playback(sender: AnyObject) {
        //TODO
    }
    
    @IBAction func selectText(sender: AnyObject) {
        //TODO launch text subview/modal
    }
    
    @IBAction func upload(sender: AnyObject) {
        //TODO launch
        //add delegate to pop tag out of our tag list for the thanks follow up
    }
    
    //TODO select camera?!?
    
    @IBAction func cancel(sender: AnyObject) {
        //TODO
    }
    
    @IBOutlet weak var ContributeAsk: UILabelHeadline!
    @IBOutlet weak var ContributeScroll: UIScrollView!
    
    
    // MARK: View

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = ContributeViewModel(data: self.rwData!)
        
        //Scroll view for subviews of tags
        ContributeAsk.text = "How would you like to contribute to \(self.viewModel.tag.tagDescription)!"
        
        //Scroll view for subviews of tags
        let scroll = ContributeScroll
        scroll.delegate = self
        
        //TODO set some real tags
        let tags = [1,2,3]
        let total = tags.count
        let buttons = self.createButtonsForScroll(total, scroll: scroll)
        
        //set titles and actions
        for (index, button) in buttons.enumerate(){
            button.setTitle(viewModel.titleForIndex(index), forState: .Normal)
            button.addTarget(self,
                action: "selectedThis:",
                forControlEvents: UIControlEvents.TouchUpInside)
        }

    }
    
    override func viewDidLoad() {
        //TODO add close to navbar
        super.viewDidLoad()
        super.view.addBackground("bg-comment.png")
        //TODO instantiate rwf
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        // set scroll view
        let scroll = ContributeScroll
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Protocol

//
//    func rwImagePickerControllerDidFinishPickingMedia(info: [NSObject : AnyObject], path: String) {
//        print(path)
//        print(info)
//        let rwf = RWFramework.sharedInstance
//        rwf.setImageDescription(path, description: "Hello, This is an image!")
//    }
//    
//    func rwRecordingProgress(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
//        //        speakProgress.setProgress(Float(percentage), animated: true)
//    }

    
    //    func rwAudioRecorderDidFinishRecording() {
    //        let rwf = RWFramework.sharedInstance
    //        speakRecordButton.setTitle(rwf.isRecording() ? "Stop" : "Record", forState: UIControlState.Normal)
    //        speakProgress.setProgress(0, animated: false)
    //    }

}