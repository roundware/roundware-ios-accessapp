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

class TagsViewController: UIViewController {
    // MARK: Actions and Outlets

    @IBAction func playTag(sender: AnyObject) {
    }
    
    @IBAction func nextTag(sender: AnyObject) {
    }
    
    @IBAction func previousTag(sender: AnyObject) {
    }
    
    @IBAction func selectParentTag(sender: AnyObject) {
    }
    
    @IBAction func selectTag(sender: AnyObject) {
    }
    
    @IBAction func seeImageForTag(sender: AnyObject) {
        //TODO launch gallery subview/modal
    }
    
    @IBAction func seeTextForTag(sender: AnyObject) {
        //TODO launch text subview/modal
    }

    @IBAction func prepareForTagsUnwind(segue: UIStoryboardSegue) {
    }
    
    // MARK: Views

    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-comment.png")        
        //TODO tags
        //TODO populate parent tags
        //TODO if first time show tip modal subview
    }
    

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        //TODO progress
        //TODO volume
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: Extension

extension TagsViewController: RWFrameworkProtocol {

    func rwGetProjectsIdSuccess(data: NSData?) {
        let rwf = RWFramework.sharedInstance
        rwf.requestWhenInUseAuthorizationForLocation()

        if let projectData = RWFrameworkConfig.getConfigDataFromGroup(RWFrameworkConfig.ConfigGroup.Project) as? NSDictionary {
            print(projectData)


            // Get all assets for the project, can filter by adding other keys to dict as documented for GET api/2/assets/
//            let project_id = projectData["project_id"] as! NSNumber
//            let dict: [String:String] = ["project_id": project_id.stringValue]
//            rwf.apiGetAssets(dict, success: { (data) -> Void in
//                if (data != nil) {
//                    _ = JSON(data: data!)
//                    //                    println(d)
//                }
//                }) { (error) -> Void in
//                    print(error)
//            }
        }
    }

    func rwGetStreamsIdCurrentSuccess(data: NSData?) {
        _ = JSON(data: data!)
        //        println(d)
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

    func rwImagePickerControllerDidFinishPickingMedia(info: [NSObject : AnyObject], path: String) {
        print(path)
        print(info)
        let rwf = RWFramework.sharedInstance
        rwf.setImageDescription(path, description: "Hello, This is an image!")
    }

    func rwRecordingProgress(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
//        speakProgress.setProgress(Float(percentage), animated: true)
    }

    func rwPlayingBackProgress(percentage: Double, duration: NSTimeInterval, peakPower: Float, averagePower: Float) {
//        speakProgress.setProgress(Float(percentage), animated: true)
    }

    func rwAudioRecorderDidFinishRecording() {
        let rwf = RWFramework.sharedInstance
//        speakRecordButton.setTitle(rwf.isRecording() ? "Stop" : "Record", forState: UIControlState.Normal)
//        speakProgress.setProgress(0, animated: false)
    }

    func rwAudioPlayerDidFinishPlaying() {
        let rwf = RWFramework.sharedInstance
//        speakPlayButton.setTitle(rwf.isPlayingBack() ? "Stop" : "Play", forState: UIControlState.Normal)
//        speakProgress.setProgress(0, animated: false)
    }
}