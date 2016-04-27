//
//  ContributeViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import Foundation
import Crashlytics
import RWFramework
import AVFoundation

class ContributeViewController: BaseViewController, UIScrollViewDelegate, UITextViewDelegate, RWFrameworkProtocol{
    var viewModel: ContributeViewModel!

    // MARK: Actions and Outlets
    @IBAction func selectAudio(sender: AnyObject) {
        //TODO setup audio (for recording, right?)
        textButton.hidden = true
        viewModel.mediaType = MediaType.Audio
        ContributeAsk.text = "What do you want to speak about?"
        showTags()
        

        //TODO hide text
        //TODO record
        //TODO playback
        //TODO stop
    }
    @IBAction func selectText(sender: AnyObject) {
        //TODO launch text subview/modal
        viewModel.mediaType = MediaType.Text
        audioButton.hidden = true
        ContributeAsk.text = "What do you want to speak about?"
        showTags()
    }
    
    func showTags(){
        //Scroll view for subviews of tags
        let scroll = ContributeScroll
        scroll.hidden = false
        scroll.delegate = self
        //TODO set some real tags
        let tags = self.viewModel.data.tags
        let total = tags.count
        let buttons = self.createTagButtonsForScroll(total, scroll: scroll)
        
        //set titles and actions
        for (index, button) in buttons.enumerate(){
            let tag = tags[index]
            button.setTitle(tag.value, forState: .Normal)
            button.addTarget(self,
                             action: #selector(ContributeViewController.selectedThis(_:)),
                             forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = tag.id
        }
        
        // set scroll view
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
        
        tagLabel.hidden = false
    }
    
    @IBAction func selectedThis(sender: AnyObject) {
        let scroll = ContributeScroll
        let others = scroll.subviews.filter({$0 as UIView != sender as! UIView})
        for (index, button) in others.enumerate(){
            button.hidden = true
        }
        //TODO set height?
        scroll.layoutIfNeeded()
        
        if(viewModel.mediaType == MediaType.Audio){
            progressLabel.hidden = false
            setupAudio() { granted, error in
                if granted == false {
                    debugPrint("Unable to setup audio: \(error)")
                    if let error = error {
                        CLSNSLogv("Unable to setup audio: \(error)", getVaList([error]))
                    }
                }
            }
        } else {
            //is text
            
        }
        //TODO more tags?
        //TODO prep media
    }
    @IBAction func cancel(sender: AnyObject) {
        self.performSegueWithIdentifier("cancel", sender: nil)
    }
    
    @IBAction func undo(sender: AnyObject) {
    }

    @IBAction func upload(sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
//        for image in self.viewModel.images {
//            rwf.setImageDescription(image.path, description: image.text)
//        }
        
//        self.images.removeAll()
//        self.uploadText = ""

        if self.viewModel.uploadText.isEmpty == false {
            rwf.addText(self.viewModel.uploadText)
        } else {
            rwf.addRecording()
        }
        //TODO collect tags
//        rwf.setSpeakTagsCurrent(group.code, value: [tag.tagId])

        rwf.uploadAllMedia(self.viewModel.tagIds)
    }

    
    @IBOutlet weak var ContributeAsk: UILabelHeadline!
    @IBOutlet weak var ContributeScroll: UIScrollView!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!

    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var responseTextView: UITextView!

    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ContributeScroll.hidden = true
        uploadButton.hidden = true
        undoButton.hidden = true
        tagLabel.hidden = true
        progressLabel.hidden = true
        responseLabel.hidden = true
        responseTextView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        debugPrint("contribute view did load")
        super.view.addBackground("bg-comment.png")
        self.viewModel = ContributeViewModel(data: self.rwData!)
        //TODO make a button image
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancel(_:)))
        
        ContributeAsk.text = "How would you like to contribute to \(self.viewModel.exhibitionTag.value)?"
        
        ContributeScroll.delegate = self
        responseTextView.delegate = self
        //TODO instantiate rwf

    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        // set scroll view
//        let scroll = ContributeScroll
//        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
//        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View after tag has been selected
//
//    func displayPreviewAudio() {
//        audioButton.accessibilityLabel = "Preview audio"
////        progressView.progress = 0.0
//        audioButton.setImage(UIImage(named: "play"), forState: .Normal)
//    }
    
//    func displayStopPlayback() {
//        audioButton.accessibilityLabel = "Stop playback"
//        audioButton.setImage(UIImage(named: "stop"), forState: .Normal)
//        progressLabel.text = "00:00"
//        progressLabel.accessibilityLabel = "0 seconds"
//    }
    
//    func displayRecordAudio() {
//        audioButton.accessibilityLabel = "Record audio"
//        progressView.progress = 0.0
//        audioButton.setImage(UIImage(named: "record"), forState: .Normal)
//        progressLabel.text = "00:30"
//        progressLabel.accessibilityLabel = "0 seconds"
//    }
//    
//    func updateAudioPercentage(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
//        var dt = maxDuration - (percentage*maxDuration) // countdown
//        var sec = Int(dt%60.0)
//        var milli = Int(100*(dt - floor(dt)))
//        var secStr = sec < 10 ? "0\(sec)" : "\(sec)"
//        progressLabel.text = "00:\(secStr)"
//        progressLabel.accessibilityLabel = "\(secStr) seconds"
    
//        progressView.progress = Float(percentage)
//    }
    
    
    // MARK: RWFramework Protocol

//
//    func rwImagePickerControllerDidFinishPickingMedia(info: [NSObject : AnyObject], path: String) {
//        print(path)
//        print(info)
//        let rwf = RWFramework.sharedInstance
//        rwf.setImageDescription(path, description: "Hello, This is an image!")
//    }
//    
    /// Sent when the framework determines that recording is possible (via config)
    func rwReadyToRecord(){
    }
    

    func rwRecordingProgress(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
        //        speakProgress.setProgress(Float(percentage), animated: true)
    }

    
    func rwAudioRecorderDidFinishRecording() {
        let rwf = RWFramework.sharedInstance
//        speakRecordButton.setTitle(rwf.isRecording() ? "Stop" : "Record", forState: UIControlState.Normal)
//        speakProgress.setProgress(0, animated: false)
    }
    
    func rwPlayingBackProgress(percentage: Double, duration: NSTimeInterval, peakPower: Float, averagePower: Float) {
        debugPrint("playback progress")
        debugPrint(Float(percentage))
//        progressView.setProgress(Float(percentage), animated: true)
        let seconds = duration % 60
        let minutes = (duration / 60) % 60
        let time = String(format: "%02d:%02d", minutes, seconds)
        progressLabel.text = time
    }
    
    func rwAudioPlayerDidFinishPlaying() {
//        let rwf = RWFramework.sharedInstance
//        displayPreviewAudio()
        debugPrint("stopped playing")
    }
    
    func rwPostEnvelopesSuccess(data: NSData?){
        debugPrint("post envelope success")

        
    }
    /// Sent in the case that the server can not return a new envelope id
    func rwPostEnvelopesFailure(error: NSError?){
        debugPrint("post envelope failure")

    }

    func rwPatchEnvelopesIdSuccess(data: NSData?){
    /// Sent in the case that the server can not accept an envelope item (media upload)
        debugPrint("patch envelope success")

    }
    func rwPatchEnvelopesIdFailure(error: NSError?){
        debugPrint("patch envelope failure")

    }
}