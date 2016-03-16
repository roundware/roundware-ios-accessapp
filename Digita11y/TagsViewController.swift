//
//  TagsViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
//import AVFoundation
import RWFramework
import SwiftyJSON

//TODO audio player delegate?
class TagsViewController: BaseViewController, RWFrameworkProtocol {
    var viewModel: TagsViewModel!

    // MARK: Actions and Outlets

    //TODO likely need to rename some of these...
    @IBAction func toggleStream(sender: AnyObject) {
        //TODO
    }
    
    @IBAction func nextTag(sender: AnyObject) {
        //TODO
    }
    
    @IBAction func previousTag(sender: AnyObject) {
        //TODO
    }
    
    @IBAction func selectParentTag(sender: AnyObject) {
        //TODO add/remove children
    }
    
    @IBAction func selectAsset(sender: AnyObject) {
        //TODO send message to stream, expand options, collapse others
    }
    
    @IBAction func openModal(sender: AnyObject) {
    }
    
    @IBAction func closeModal(sender: AnyObject) {
        //TODO expand options, collapse others
    }
    
    @IBAction func pageAsset(sender: AnyObject) {
        //TODO expand options, collapse others
    }
    
    @IBAction func contribute(sender: AnyObject) {
        //TODO pause playback?
        self.performSegueWithIdentifier("ContributeSegue", sender: sender)
    }
    
    @IBAction func seeGalleryForAsset(sender: AnyObject) {
        //TODO might be subview?
        self.performSegueWithIdentifier("GallerySegue", sender: sender)
        //TODO launch gallery subview/modal
    }
    
    @IBAction func seeTextForAsset(sender: AnyObject) {
        //TODO might be subview?
        self.performSegueWithIdentifier("TextSegue", sender: sender)
        //TODO launch text subview/modal
    }
    
    @IBAction func seeMap(sender: AnyObject) {
        //TODO might be subview?
        self.performSegueWithIdentifier("MapSegue", sender: sender)
        //TODO reset after coming back from contribute
    }

    @IBAction func prepareForTagsUnwind(segue: UIStoryboardSegue) {
        //TODO reset after coming back from contribute
    }
    @IBAction func prepareForTagsDismiss(segue: UIStoryboardSegue) {
        //TODO reset after coming back from contribute
    }
    
    // MARK: Views

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO instantiate  and start rwf
        super.view.addBackground("bg-comment.png")        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = TagsViewModel(data: self.rwData!)
        //TODO set parent tags
        //TODO start stream if not playing
        //TODO once stream starts, select asset
        //TODO at end of asset, move to next asset? or next parentTag?
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Gallery Modal
    
    // MARK: Map Modal

    // MARK: Text Modal
    
    
    // MARK: RWFramework Protocol

    func rwGetStreamsIdCurrentSuccess(data: NSData?) {
        _ = JSON(data: data!)
        debugPrint(data)
    }

    func rwPostStreamsSuccess(data: NSData?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.listenPlayButton.enabled = true
//            self.listenNextButton.enabled = true
//            self.listenCurrentButton.enabled = true
        })
    }

    func rwPostStreamsIdHeartbeatSuccess(data: NSData?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                self.heartbeatButton.alpha = 0.0
                }, completion: { (Bool) -> Void in
//                    self.heartbeatButton.alpha = 1.0
            })
        })
    }

    func rwPlayingBackProgress(percentage: Double, duration: NSTimeInterval, peakPower: Float, averagePower: Float) {
//        speakProgress.setProgress(Float(percentage), animated: true)
    }

//    func rwAudioRecorderDidFinishRecording() {
//        let rwf = RWFramework.sharedInstance
//        speakRecordButton.setTitle(rwf.isRecording() ? "Stop" : "Record", forState: UIControlState.Normal)
//        speakProgress.setProgress(0, animated: false)
//    }

    func rwAudioPlayerDidFinishPlaying() {
        let rwf = RWFramework.sharedInstance
//        speakPlayButton.setTitle(rwf.isPlayingBack() ? "Stop" : "Play", forState: UIControlState.Normal)
//        speakProgress.setProgress(0, animated: false)
    }
}