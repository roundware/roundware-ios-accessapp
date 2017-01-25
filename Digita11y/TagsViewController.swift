//
//  TagsViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import UIKit
import RWFramework
import Crashlytics
import SwiftyJSON
import CoreLocation
import SVProgressHUD
import AVFoundation

//https://github.com/Akkyie/AKPickerView-Swift
class TagsViewController: BaseViewController, RWFrameworkProtocol, AKPickerViewDataSource, AKPickerViewDelegate {
    var viewModel: TagsViewModel!
    var tagViews : [TagView] = []
    var waitingToStart: Bool = false

    // MARK: Outlets and Actions

    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var parentTagPickerView: AKPickerView!

    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var itemsScrollView: UIScrollView!

    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!

    @IBAction func cycleSpeed(_ sender: AnyObject) {
        //TODO cycle speed
        debugPrint("cycle speed")
    }

    @IBAction func toggleStream(_ sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        if (rwf.isPlaying) {
            SVProgressHUD.dismiss()
            DebugLog("pause timer")
            timer.invalidate()
            rwf.stop()
            self.playPauseButton.showButtonIsPlaying(false)
            self.nextButton.isEnabled = false
            self.previousButton.isEnabled = false
            UIApplication.shared.isIdleTimerDisabled = false
        } else {
            startPlaying()
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }

    //really next asset
    //TODOsoon rewrite with api update
    @IBAction func nextTag(_ sender: AnyObject) {
        DebugLog("next item")
        let rwf = RWFramework.sharedInstance
        if (rwf.isPlaying) {
            //set to first item if none is selected
            guard let index = self.viewModel.selectedItemIndex else {
                selectItemAtIndex(0)
                return
            }

            //switch to next asset if available
            if(index < tagViews.count &&
                //does not account for new assets since start
                tagViews[index].currentAssetIndex + 1 < tagViews[index].arrayOfAssetIds.count){
                rwf.next()
                return
            }

            //switch to next item if available
            var nextIndex = index + 1
            if(self.viewModel.itemTags.count - 1 >= nextIndex){
                selectItemAtIndex(nextIndex)
            } else {
                //switch to next room if available
                guard let roomIndex = self.viewModel.selectedRoomIndex else {
                    return
                }
                nextIndex = roomIndex + 1
                if(self.viewModel.roomTags.count - 1 >= nextIndex){
                    self.parentTagPickerView.selectItem(nextIndex)
                } else {
                    //TODO notification if next room finished
                    // or restart
                }

            }
        }
    }

    @IBAction func previousTag(_ sender: AnyObject) {
        //TODOsoon will restart current asset or
        //move to previous asset
        DebugLog("previous tag")

    }

    @IBAction func contribute(_ sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        if (rwf.isPlaying) {
            self.toggleStream(self)
        }
        self.performSegue(withIdentifier: "ContributeSegue", sender: sender)
    }

    @IBAction func seeMap(_ sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        if (rwf.isPlaying) {
            self.toggleStream(self)
        }
        self.performSegue(withIdentifier: "MapSegue", sender: sender)
    }


    // MARK: Asset Actions

    //do not confuse with pickerView delegate method
    @IBAction func selectItem(_ sender: UIButton) {
        DebugLog("selected tag at index \(String(sender.tag))")
        selectItemAtIndex(sender.tag)
    }

    var countdownTime = 60
    var timer = Timer()
    @IBAction func selectItemAtIndex(_ index: Int) {
        let tagView = tagViews[index]
        if (tagView.selected){
            DebugLog("this item is already selected")
        } else {
            tagView.selected = true
            self.viewModel.selectedItemIndex = index
            //deselect others
            let others = tagViews.filter({$0 !== tagView})
            others.forEach({$0.selected = false })
            //start playing if not playing
            let rwf = RWFramework.sharedInstance
            if(!rwf.isPlaying){
                self.playPauseButton.showButtonIsPlaying(true)
                startPlaying()
            }

            //set times
            countdownTime = Int(tagView.totalLength)
        }
    }

    func countdown() {
//        debugPrint("counting")
        if countdownTime > 0 {
            let seconds = countdownTime % 60
            let minutes = (countdownTime / 60) % 60
//            debugPrint("seconds \(seconds)")
//            debugPrint("minutes \(minutes)")
            let countdownText = String(format: "%02d:%02d", minutes, seconds)
            countdownLabel.text = countdownText
            countdownLabel.accessibilityLabel = "\(minutes) minutes and \(seconds) seconds total for this tag"
            countdownTime -= 1
        }
    }

    //item must be set already and stored in rwdata
    @IBAction func seeGalleryForAsset(_ sender: UIButton) {
        let rwf = RWFramework.sharedInstance
        if (rwf.isPlaying) {
            self.toggleStream(self)
        }
        self.performSegue(withIdentifier: "GallerySegue", sender: sender)
        
    }

    //item must be set already and stored in rwdata
    @IBAction func seeTextForAsset(_ sender: UIButton) {
        let rwf = RWFramework.sharedInstance
        if (rwf.isPlaying) {
            self.toggleStream(self)
        }
        self.performSegue(withIdentifier: "ReadSegue", sender: sender)
    }


    // MARK: Segue Actions


    //back from modals
    @IBAction func prepareForTagsDimiss(_ segue: UIStoryboardSegue) {
        //TODOsoon move focus to current asset
    }
    //back from contribute
    @IBAction func prepareForTagsUnwind(_ segue: UIStoryboardSegue) {
        //TODOsoon move focus to current asset
    }


    // MARK: Views

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.view.addBackground("bg-comment.png")
        self.viewModel = TagsViewModel(data: self.rwData!)

        self.navigationItem.title = self.viewModel.title

        //set room pickerview
        self.parentTagPickerView.delegate = self
        self.parentTagPickerView.dataSource = self
        self.parentTagPickerView.pickerViewStyle = .flat
        self.parentTagPickerView.viewDepth = 0
        self.parentTagPickerView.maskDisabled = true
        self.parentTagPickerView.font = UIFont(name: "AvenirNext-Medium", size: 30)!
        self.parentTagPickerView.highlightedFont = UIFont(name: "AvenirNext-Medium", size: 30)!
        self.parentTagPickerView.reloadData()
        self.parentTagPickerView.selectItem(0)
        self.contributeButton.isEnabled = true

        self.roomsLabel.accessibilityLabel = "Rooms"
        self.roomsLabel.accessibilityTraits = UIAccessibilityTraitHeader
        self.itemsLabel.accessibilityLabel = "Items"
        self.itemsLabel.accessibilityTraits = UIAccessibilityTraitHeader
        self.playerLabel.accessibilityLabel = "Player"
        self.playerLabel.accessibilityTraits = UIAccessibilityTraitHeader

        //TODO double check for location...
        let rwf = RWFramework.sharedInstance
        rwf.addDelegate(object: self)
        self.playPauseButton.showButtonIsPlaying(false)

        if !self.rwData!.selectedProject!.mapURL.isEmpty {
            let button: UIButton = UIButton(type:UIButtonType.custom)
            //set image for button
            button.setImage(UIImage(named: "map.png"), for: UIControlState())
            //add function for button
            button.addTarget(self, action: #selector(self.seeMap(_:)), for: UIControlEvents.touchUpInside)
            //set frame
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let barButton = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButton
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
        let rwf = RWFramework.sharedInstance
        if(rwf.isPlaying){
            rwf.stop()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: true)

    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        let scroll = itemsScrollView
        let newContentOffsetX = ((scroll?.contentSize.width)!/2) - ((scroll?.bounds.size.width)!/2)
        scroll?.contentOffset = CGPoint(x: newContentOffsetX, y: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func startPlaying() -> Bool {
        //TODO rework for geolocation toggle && project settings
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            let rwf = RWFramework.sharedInstance
            rwf.play()
            SVProgressHUD.show(withStatus: "Loading Stream")
            self.playPauseButton.showButtonIsPlaying(true)
            waitingToStart = true
            return true
        } else {
            var alertController = UIAlertController (title: "Location services", message: "Please enable location detection for streaming", preferredStyle: .alert)

            var settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            }

            var cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
            return false
        }
    }

    func resetRoomItems(){
        let duration = 0.5
        let delay = 0.1
        let springDamping = CGFloat(0.5)
        let springVelocity = CGFloat(0.5)
        let scroll = itemsScrollView

        //hide old assets
        for (index, item) in (scroll?.subviews.enumerated())!{
            UIView.animate(withDuration: duration, delay: Double(index) * delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations: {
                item.alpha = 0
                item.center.y -= 30
            }, completion: { finished in
                item.removeFromSuperview()
            })
        }

        //show new assets
        let total = self.viewModel.itemTags.count
        DebugLog("\(total) items in this room")
//        dump(self.viewModel.itemTags)
        scroll?.delegate = self
        let itemWidth = 300
        let itemHeight = 80
        scroll?.contentSize.width = CGFloat(itemWidth)
        scroll?.contentSize.height = CGFloat(itemHeight * total)

        tagViews = []

        for index in 0..<total {
            let tagView = TagView()
            let tag = self.viewModel.itemTags[index]
            let images = self.viewModel.data.getAssetsForTagIdOfMediaType(tag.id, mediaType: MediaType.photo)
            let texts = self.viewModel.data.getAssetsForTagIdOfMediaType(tag.id, mediaType: MediaType.text)

            tagView.hasImages = images.count > 0
//            debugPrint("tagview index \(index) has \(images.count) images")

            tagView.hasTexts = texts.count > 0
            tagView.setTag(tag, index: index, total: total)

            //TODO should really go into setTag and use delegate...
            tagView.tagTitle.addTarget(self,
                               action: #selector(selectItem),
                               for: UIControlEvents.touchUpInside)
            tagView.tagTitle.tag = index
            if(tagView.hasTexts){
                tagView.textButton.addTarget(self,
                                     action: #selector(seeTextForAsset(_:)),
                                     for: UIControlEvents.touchUpInside)
                tagView.textButton.tag = tag.id
            }
            if(tagView.hasImages){
                tagView.cameraButton.addTarget(self,
                                       action: #selector(seeGalleryForAsset(_:)),
                                       for: UIControlEvents.touchUpInside)
                tagView.cameraButton.tag = tag.id
            }

            let audioAssets : [Asset] = self.viewModel.data.getAssetsForTagIdOfMediaType(tagView.id!, mediaType: MediaType.audio)
//            debugPrint("audio assets for tag \(tagView.id!)")
//            dump(audioAssets)
            let totalLength = audioAssets.map({$0.audioLength}).reduce(0, +)
//            debugPrint("total length is \(totalLength)")
            let arrayOfAssetIds = audioAssets.map({ String($0.assetID)})
            tagView.arrayOfAssetIds = arrayOfAssetIds
            tagView.totalLength = totalLength

            let frame = CGRect(
                x: 0,
                y: index * itemHeight,
                width: Int(itemWidth),
                height: itemHeight)
            tagView.frame = frame
            tagView.alpha = 0
            tagView.center.y -= 30
            scroll?.addSubview(tagView)
            UIView.animate(withDuration: duration, delay: Double(index) * delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations: {
                tagView.alpha = 1
                tagView.center.y += 30
                }, completion: { finished in
            })
            tagViews.append(tagView)
        }

        if(tagViews.count > 0){
            selectItemAtIndex(0)
        }

    }


    // MARK: - AKPickerViewDataSource

    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return self.viewModel.roomTags.count
    }

    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.viewModel.roomTags[item].locMsg
    }
    func pickerView(_ pickerView: AKPickerView, accessibilityLabelForItem item: Int) -> String {
        return self.viewModel.roomTags[item].locMsg + ", \(item + 1) of \(self.viewModel.roomTags.count)"
    }

    func pickerView(_ pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor.lightGray
        label.highlightedTextColor = UIColor.black
        label.backgroundColor = UIColor.white
    }

    func pickerView(_ pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }



    // MARK: - AKPickerViewDelegate

    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        DebugLog("selected room with index \(item)")
        if( self.viewModel.selectedRoomIndex != item){
            self.viewModel.selectedRoomIndex = item
            resetRoomItems()
        }
        //TODO update labels
        self.viewModel.roomTags[item].locMsg + ", \(item + 1) of \(self.viewModel.roomTags.count)"
    }

    // MARK: RWFramework Protocol
    func rwUpdateStatus(_ message: String) {
//        print("update status")
//        print(message)
    }

    func rwGetStreamsIdCurrentSuccess(_ data: Data?) {
        DebugLog("current success")
//        dump(data)
    }

    func rwPostStreamsSuccess(_ data: Data?) {
        DebugLog("stream success")
//        dump(data)
        DispatchQueue.main.async(execute: { () -> Void in
            self.playPauseButton.isEnabled = true
        })
    }

    func rwPostStreamsError(_ error: NSError?) {
        DebugLog((error?.localizedDescription)!)
    }

    func rwPatchStreamsIdSuccess(_ data: Data?){
        DebugLog("patch stream success")
//        dump(data)

    }

    func rwPatchStreamsIdFailure(_ error: NSError?){
        DebugLog("patch streams failure")
        DebugLog((error?.localizedDescription)!)
    }

    func rwPostStreamsIdHeartbeatSuccess(_ data: Data?) {
//        DebugLog("heartbeat success")
//        dump(data)
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        })
    }

    func rwPostStreamsIdNextSuccess(_ data: Data?) {
        DebugLog("next success")
        dump(data)
    }

    func rwPostStreamsIdNextFailure(_ error: NSError?) {
        DebugLog("rwPostStreamsIdNextFailureerror")
        DebugLog((error?.localizedDescription)!)

    }

    func rwGetAssetsIdSuccess(_ data: Data?){
        DebugLog("get asset id success")
//        dump(data)
    }

    func rwGetAssetsIdFailure(_ error: NSError?){
        DebugLog("get asset id error")
        DebugLog((error?.localizedDescription)!)
    }


    func rwObserveValueForKeyPath(_ keyPath: String, ofObject object: AnyObject, change: [AnyHashable: Any], context: UnsafeMutableRawPointer) {

        //the stream has started
        if keyPath == "timedMetadata" {

            if waitingToStart{
                //start playing actually!
//                debugPrint("starting time")
                DebugLog("playback has begun in UI")
                waitingToStart = false
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TagsViewController.countdown), userInfo: nil, repeats: true)
                SVProgressHUD.dismiss()
                self.playPauseButton.showButtonIsPlaying(true)
//                self.nextButton.enabled = true
//                self.previousButton.enabled = true
            }

            //get values
            guard let newChange = change["new"] as? NSArray,
                let avMetadataItem = newChange.firstObject as? AVMetadataItem else{
                return
            }

            guard var value = avMetadataItem.value as? String else{
                    DebugLog("value problem")
                    return
            }
            value = value.replacingOccurrences(of: "Roundware - ", with: "?", options: NSString.CompareOptions.literal, range: nil)

            guard let params = URL(string: value) else{
                DebugLog("param problem")
                DebugLog(value)
                return
            }
            guard let queryItems = params.queryItems else{
                DebugLog("query problem")
                DebugLog(String(describing: params))
                return
            }

            //ok we have our values
            //let see what asset we are on
            guard let assetID = queryItems["asset"] else{
//                DebugLog("no assetID set")
//                DebugLog(String(queryItems))
                return
            }

            //TODO soon api update will mean we look at remaining and total in queryItems and update progress based on that

//            debugPrint("assetID is \(assetID)")
            guard let assetTagView = tagViews.filter({ $0.arrayOfAssetIds.contains( assetID )}).first else {
//                DebugLog("no assetTagView found")
                return
            }

            guard let index = self.viewModel.selectedItemIndex else {
//                DebugLog("no item selected")
                return
            }

            DebugLog("selectedItemIndex is \(index) and its tag id is \(self.tagViews[index].id)")
//                    debugPrint("and that tag has these audio assets such as...")
//                    dump(self.viewModel.data.getAssetsForTagIdOfMediaType(self.tagViews[index].id!, mediaType: MediaType.Audio))

            //TODO should have a check on the index

            if tagViews[index] == assetTagView {
//                debugPrint("the current asset belongs to our current tagview")

                if let remaining = queryItems["remaining"] {

                    assetTagView.currentAssetIndex = assetTagView.arrayOfAssetIds.count - Int(remaining)! - 1

                    if assetTagView.arrayOfAssetIds.count > 0 {
                        //update tag progress based on remaining count
//                        debugPrint("there are \(remaining) assets remaining of \(assetTagView.arrayOfAssetIds.count)")
                        let percentage = Float((Float(assetTagView.arrayOfAssetIds.count) - Float(remaining)!) / Float(assetTagView.arrayOfAssetIds.count))
                        assetTagView.tagProgress.isHidden = false
//                        DebugLog("we are \(percentage) through this tag's assets")
                        assetTagView.tagProgress.setProgress(percentage, animated: true)

                    } else {
                        DebugLog("0 assets in tagview")
                    }

                    //TODO mark as completed in uiItem and ui
                    //completed an asset
//                            if let complete = queryItems["complete"]  {
//                                if Int(remaining)! == 0 {
//                                    debugPrint("we finished this tag's assets")
//                                    assetTagView.selected = false
//                                    self.viewModel.selectedItemIndex = nil

//                                    elapsedTimeLabel.text = "00:00"
//                                    elapsedTimeLabel.accessibilityLabel = "estimated time elapsed for tag playback"
//                                }
//                            }
                }
            }
        }
//        debugPrint("keypath")
//        dump(keyPath)
//        debugPrint("object")
//        dump(object)
//        debugPrint("change")
//        dump(change)
//        debugPrint("context")
//        dump(context)
    }

    func rwAudioPlayerDidFinishPlaying() {
        self.playPauseButton.showButtonIsPlaying(false)
    }
}
