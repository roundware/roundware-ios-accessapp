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
import SVProgressHUD
import AVFoundation

class ContributeViewController: BaseViewController, UIScrollViewDelegate, UITextViewDelegate, RWFrameworkProtocol{
    var viewModel: ContributeViewModel!

    // MARK: Outlets and Actions

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


    @IBAction func selectAudio(sender: AnyObject) {
        if(!self.viewModel.mediaSelected){
            let duration = 0.1
            UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                self.textButton.hidden = true
                self.ContributeAsk.text = self.viewModel.uiGroup.headerTextLoc
                self.tagLabel.hidden = false
                self.tagLabel.text = self.viewModel.itemTag.locMsg
                self.audioButton.enabled = false
            }, completion: { finished in
            })

            showTags()

            viewModel.mediaType = MediaType.Audio
            viewModel.mediaSelected = true
            //TODOnow move focus to question

        } else {
            if(self.viewModel.tagsSelected){
            //record, play, stop
                var rwf = RWFramework.sharedInstance
                if rwf.isRecording() {
//                    delay(0.5) {  // HACK: Let the buffers in the framework flush.
                        rwf.stopRecording()
                        rwAudioRecorderDidFinishRecording()
//                    }
                } else if rwf.isPlayingBack() {
                    rwf.stopPlayback()
                    displayPreviewAudio()
                } else if rwf.hasRecording() {
                    rwf.startPlayback()
                    displayStopPlayback()
                } else {
                    rwf.startRecording()
                    displayStopRecording()
                }
            }

        }

    }

    @IBAction func selectText(sender: AnyObject) {
        if(!self.viewModel.mediaSelected){

            let duration = 0.1
            UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                self.audioButton.hidden = true
                self.ContributeAsk.text = self.viewModel.uiGroup.headerTextLoc
                self.tagLabel.text = "Text"
                self.textButton.enabled = false
                }, completion: { finished in
            })

            showTags()

            viewModel.mediaType = MediaType.Text
            self.viewModel.mediaSelected = true
            //TODOnow move focus to question
        }
    }

    @IBAction func selectedThis(sender: AnyObject) {
        let scroll = ContributeScroll
        let selectedView = sender as! UIView

        //hide others
        let others = scroll.subviews.filter({$0 as UIView != selectedView})
        for (index, button) in others.enumerate(){
            button.hidden = true
        }

        //move selected to top
        selectedView.frame =  CGRect(
            x: selectedView.frame.origin.x,
            y: 0,
            width: selectedView.frame.width,
            height: selectedView.frame.height
        )
        scroll.contentSize.width = selectedView.frame.width
        scroll.contentSize.height = selectedView.frame.height


        //set tag into viewmodel
        self.viewModel.selectedTag = self.viewModel.data.getTagById(sender.tag)
        if(!self.viewModel.tagsSelected){
            self.ContributeAsk.text = self.viewModel.uiGroup.headerTextLoc
            showTags()
            //TODOnow move focus to question
        } else {
            if let button = sender as? UIButton {
                button.enabled = false
            }
            if(viewModel.mediaType == MediaType.Audio){
                setupAudio() { granted, error in
                    if granted == false {
                        debugPrint("Unable to setup audio: \(error)")
                        if let error = error {
                            CLSNSLogv("Unable to setup audio: \(error)", getVaList([error]))
                        }
                        //TODOnow alert message
                    } else {
                        debugPrint("Successfully setup audio")
                        let duration = 0.1
                        UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                            self.audioButton.enabled = true
                            self.progressLabel.hidden = false
                            self.progressLabel.text = "00:30"
                        }, completion: { finished in
                        })
                        //TODOnow move focus, set audio label
                    }
                }
            } else {
                //is text
                let duration = 0.1

                UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                    self.responseTextView.hidden = false
                    self.tagLabel.hidden = true
                    self.textButton.hidden = true
                }, completion: { finished in
                })
            }
        }

    }

    @IBAction func cancel(sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        if(rwf.hasRecording()){
            rwf.deleteRecording()
        }
        self.performSegueWithIdentifier("cancel", sender: nil)
    }

    @IBAction func undo(sender: AnyObject) {
        debugPrint("undoing")
        let rwf = RWFramework.sharedInstance
        if(self.viewModel.mediaType == MediaType.Audio){
            rwf.deleteRecording()
            displayRecordAudio()
            let duration = 0.1
            UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
            }, completion: { finished in
                self.undoButton.hidden = true
                self.uploadButton.hidden = true
                self.progressLabel.text = "00:30"
            })
        } else {
            self.viewModel.uploadText = ""
            let duration = 0.1
            UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                }, completion: { finished in
                    self.undoButton.hidden = true
                    self.uploadButton.hidden = true
                    self.responseTextView.hidden = true
                    self.responseTextView.text = "Your response here"
                    self.responseTextView.textColor = UIColor.lightGrayColor()
            })
        }
    }

    @IBAction func upload(sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
//        for image in self.viewModel.images {
//            rwf.setImageDescription(image.path, description: image.text)
//        }

//        self.images.removeAll()
//        self.uploadText = ""
        if self.viewModel.mediaType == MediaType.Text {
            rwf.addText(self.viewModel.uploadText)
            debugPrint("text added")
        } else {
            rwf.addRecording()
            debugPrint("recording added")
        }

        rwf.uploadAllMedia(self.viewModel.tagIds())
        SVProgressHUD.showWithStatus("Uploading")
    }


    // MARK: Segue Actions
    //back from thank you
    @IBAction func prepareForRecontribute(segue: UIStoryboardSegue) {

        debugPrint("prepare for recontribute")

        //set header
        self.ContributeAsk.text = self.viewModel.uiGroup.headerTextLoc
        let scroll = ContributeScroll

        //set selected tag
        let tags = [self.viewModel.data.getTagById(self.viewModel.uiGroup.selectedUIItem!.tagId)]
        let total = tags.count
        let buttons = createTagButtonsForScroll(total, scroll: scroll)
        buttons[0].setTitle(tags[0]!.locMsg, forState: .Normal)

        //reset audio
        if(viewModel.mediaType == MediaType.Audio){
            setupAudio() { granted, error in
                if granted == false {
                    debugPrint("Unable to setup audio: \(error)")
                    if let error = error {
                        CLSNSLogv("Unable to setup audio: \(error)", getVaList([error]))
                    }
                    //TODOnow alert message
                } else {
                    debugPrint("Successfully setup audio")
                    let duration = 0.1
                    UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                        self.audioButton.enabled = true
                        self.progressLabel.hidden = false
                        self.progressLabel.text = "00:30"
                        }, completion: { finished in
                    })
                    //TODOnow move focus, set audio label
                }
            }
        } else {
            //is text
            let duration = 0.1
            UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                self.responseTextView.hidden = false
                self.tagLabel.hidden = true
                self.textButton.hidden = true
                }, completion: { finished in
            })
        }
        self.responseTextView.text = "Your response here"
        uploadButton.hidden = true
        undoButton.hidden = true
    }

    // MARK: View
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //keyboard with view adjustment as well as done button and outside tap dismissal

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(dismissKeyboard))
        let toolBar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        responseTextView.inputAccessoryView = toolBar

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        super.view.addBackground("bg-comment.png")
        self.viewModel = ContributeViewModel(data: self.rwData!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancel(_:)))
        ContributeAsk.text = "How would you like to contribute to \(self.viewModel.itemTag.locMsg)?"

        let rwf = RWFramework.sharedInstance
        rwf.addDelegate(self)
        ContributeScroll.delegate = self
        responseTextView.delegate = self

        ContributeScroll.hidden = true
        uploadButton.hidden = true
        undoButton.hidden = true
        tagLabel.hidden = true
        progressLabel.hidden = true
        responseLabel.hidden = true
        responseTextView.hidden = true

        //http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name:UIKeyboardWillHideNotification, object: self.view.window)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Tags layout
    func showTags(){
        let scroll = ContributeScroll
        scroll.hidden = false
        scroll.delegate = self

        let tags = self.viewModel.tags
        let total = tags.count

        let buttons = createTagButtonsForScroll(total, scroll: scroll)
        //set titles and actions
        for (index, button) in buttons.enumerate(){
            let tag = tags[index]
            button.setTitle(tag.locMsg, forState: .Normal)
            button.accessibilityLabel = tag.locMsg + ", \(index + 1) of \(buttons.count)"

            button.addTarget(self,

                             action: #selector(self.selectedThis(_:)),
                             forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = tag.id
        }
    }

    // MARK: Audio layout
    func displayPreviewAudio() {
        audioButton.accessibilityLabel = "Preview audio"
        progressLabel.text = "00:00"
        audioButton.setImage(UIImage(named: "playContribute"), forState: .Normal)
        //TODOnow fix upload undo index order
        //TODOnow fix upload under sizing
    }

    func displayStopPlayback() {
        audioButton.accessibilityLabel = "Stop playback"
        audioButton.setImage(UIImage(named: "stop"), forState: .Normal)
        progressLabel.text = "00:00"
        progressLabel.accessibilityLabel = "0 seconds"
    }

    func displayStopRecording() {
        audioButton.accessibilityLabel = "Stop recording"
        audioButton.setImage(UIImage(named: "stop"), forState: .Normal)
    }

    func displayRecordAudio() {
        audioButton.accessibilityLabel = "Record audio"
//        progressView.progress = 0.0
        audioButton.setImage(UIImage(named: "record"), forState: .Normal)
        progressLabel.text = "00:30"
        progressLabel.accessibilityLabel = "30 seconds"
    }

    // MARK: Text layout
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size

        debugPrint("keyboardSize \(keyboardSize)")
        debugPrint("offset \(offset)")
        if (self.responseTextView.text == "Your response here"){
            self.responseTextView.text = ""
        }

        if keyboardSize.height == offset.height {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }

    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y += keyboardSize.height
        self.viewModel.uploadText = self.responseTextView.text
        self.uploadButton.hidden = false
        self.undoButton.hidden = false
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    // MARK: RWFramework Protocol

    /// Sent when the framework determines that recording is possible (via config)
    func rwReadyToRecord(){
        debugPrint("ready to record")
    }


    func rwRecordingProgress(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
        var dt = maxDuration - (percentage*maxDuration)
        var sec = Int(dt%60.0)
        var milli = Int(100*(dt - floor(dt)))
        var secStr = sec < 10 ? "0\(sec)" : "\(sec)"
        progressLabel.text = "00:\(secStr)"
        progressLabel.accessibilityLabel = "\(secStr) seconds"
    }

    func rwAudioRecorderDidFinishRecording() {
        displayPreviewAudio()
        self.undoButton.hidden = false
        self.uploadButton.hidden = false
    }

    func rwPlayingBackProgress(percentage: Double, duration: NSTimeInterval, peakPower: Float, averagePower: Float) {
        var dt = (percentage*duration)
        var sec = Int(dt%60.0)
        var milli = Int(100*(dt - floor(dt)))
        var secStr = sec < 10 ? "0\(sec)" : "\(sec)"
        progressLabel.text = "00:\(secStr)"
        progressLabel.accessibilityLabel = "\(secStr) seconds"
    }

    func rwAudioPlayerDidFinishPlaying() {
//        let rwf = RWFramework.sharedInstance
//        displayPreviewAudio()
        debugPrint("stopped playing")
        displayPreviewAudio()
    }

    func rwPostEnvelopesSuccess(data: NSData?){
        debugPrint("post envelope success")
    }

    /// Sent in the case that the server can not return a new envelope id
    func rwPostEnvelopesFailure(error: NSError?){
        debugPrint("post envelope failure")
        SVProgressHUD.dismiss()
        //TODOnow display alert
        //TODOnow trigger undo

    }

    func rwPatchEnvelopesIdSuccess(data: NSData?){
    /// Sent in the case that the server can not accept an envelope item (media upload)
        debugPrint("patch envelope success")
        SVProgressHUD.dismiss()

        //TODOnow mark uiitems as contributed
        for (_, tag) in self.viewModel.tags.enumerate(){
//            tag.contributed
        }

        self.performSegueWithIdentifier("Thanks", sender: nil)
    }

    func rwPatchEnvelopesIdFailure(error: NSError?){
        debugPrint("patch envelope failure")
        SVProgressHUD.dismiss()
        //TODO trigger undo
    }

//
//    func rwImagePickerControllerDidFinishPickingMedia(info: [NSObject : AnyObject], path: String) {
//        print(path)
//        print(info)
//        let rwf = RWFramework.sharedInstance
//        rwf.setImageDescription(path, description: "Hello, This is an image!")
//    }
//


    // MARK: UITextView Protocol

    func textViewDidBeginEditing(textView: UITextView) {
        debugPrint("began editing")
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        debugPrint("finished editing")
        if textView.text.isEmpty {
            textView.text = "Your response here"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}
