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
    @IBAction func playTag(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.addBackground("bg-comment.png")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension TagsViewController: RWFrameworkProtocol {

    func rwUpdateStatus(message: String) {
//        self.statusTextView.text = self.statusTextView.text + "\r\n" + message
//        self.statusTextView.scrollRangeToVisible(NSMakeRange(self.statusTextView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), 0))
    }

    func rwUpdateApplicationIconBadgeNumber(count: Int) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = count
    }

    func rwGetProjectsIdSuccess(data: NSData?) {
        let rwf = RWFramework.sharedInstance
        rwf.requestWhenInUseAuthorizationForLocation()

        // You can now access the project data
        if let projectData = RWFrameworkConfig.getConfigDataFromGroup(RWFrameworkConfig.ConfigGroup.Project) as? NSDictionary {
            print(projectData)


            // Get all assets for the project, can filter by adding other keys to dict as documented for GET api/2/assets/
            let project_id = projectData["project_id"] as! NSNumber
            let dict: [String:String] = ["project_id": project_id.stringValue]
            rwf.apiGetAssets(dict, success: { (data) -> Void in
                if (data != nil) {
                    _ = JSON(data: data!)
                    //                    println(d)
                }
                }) { (error) -> Void in
                    print(error)
            }

            //            // Get specific asset info
            //            rwf.apiGetAssetsId("99", success: { (data) -> Void in
            //                if (data != nil) {
            //                    let d = JSON(data: data!)
            ////                    println(d)
            //                }
            //            }) { (error) -> Void in
            //                println(error)
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