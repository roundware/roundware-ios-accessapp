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

    // MARK: Actions and Outlets
    
    @IBAction func cycleSpeed(sender: AnyObject) {
        //TODO cycle speed
        debugPrint("cycle speed")
    }
    
    @IBAction func toggleStream(sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        if (rwf.isPlaying) {
            rwf.stop()
            self.playPauseButton.showButtonIsPlaying(false)
            self.nextButton.enabled = false
            self.previousButton.enabled = false
        } else {
            startPlaying()
        }
    }
    
    func startPlaying() -> Bool {
        if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            let rwf = RWFramework.sharedInstance
            rwf.play()
            SVProgressHUD.showWithStatus("Loading Stream")
            self.playPauseButton.showButtonIsPlaying(true)
            waitingToStart = true
            return true
        } else {
            var alertController = UIAlertController (title: "Location services", message: "Please enable location detection for streaming", preferredStyle: .Alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    //really next asset
    @IBAction func nextTag(sender: AnyObject) {
        debugPrint("next asset really")
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
    
    @IBAction func previousTag(sender: AnyObject) {
        //TODO will restart current asset or
        //move to previous asset
        debugPrint("previous tag")

    }
    
    @IBAction func contribute(sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        if(rwf.isPlaying){
            rwf.stop()
        }
        self.performSegueWithIdentifier("ContributeSegue", sender: sender)
    }
    
    @IBAction func seeMap(sender: AnyObject) {
        self.performSegueWithIdentifier("MapSegue", sender: sender)
    }
    
    // MARK: Asset Actions
    //do not confuse with pickerView delegate method
    @IBAction func selectItem(sender: UIButton) {
        debugPrint("selected tag at index \(String(sender.tag))")
        selectItemAtIndex(sender.tag)
    }
    
    //TODO mark item as played
    @IBAction func selectItemAtIndex(index: Int) {
        let tagView = tagViews[index]
        if (tagView.selected){
            debugPrint("this item is already selected")
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
            let seconds = tagView.totalLength % 60
            let minutes = (tagView.totalLength / 60) % 60
            debugPrint("seconds \(seconds)")
            debugPrint("minutes \(minutes)")
            let time = String(format: "%02d:%02d", Int(minutes), Int(seconds))
            totalTimeLabel.text = time
            totalTimeLabel.accessibilityLabel = "\(minutes) minutes and \(seconds) seconds total for this tag"
            
            //TODO start timer?
            elapsedTimeLabel.text = "00:00"
            elapsedTimeLabel.accessibilityLabel = "estimated time elapsed for tag playback"
        }

    }


    //item must be set already and stored in rwdata
    @IBAction func seeGalleryForAsset(sender: UIButton) {
        self.performSegueWithIdentifier("GallerySegue", sender: sender)
    }
    
    //item must be set already and stored in rwdata
    @IBAction func seeTextForAsset(sender: UIButton) {
        self.performSegueWithIdentifier("ReadSegue", sender: sender)
    }

    // MARK: Segue Actions
    //back from modals
    @IBAction func prepareForTagsDimiss(segue: UIStoryboardSegue) {
        //TODO reset after coming back from contribute
    }
    //back from contribute
    @IBAction func prepareForTagsUnwind(segue: UIStoryboardSegue) {
        //TODO reset after coming back from contribute
    }

    @IBOutlet weak var parentTagPickerView: AKPickerView!
    @IBOutlet weak var itemsScrollView: UIScrollView!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        super.view.addBackground("bg-comment.png")
        self.viewModel = TagsViewModel(data: self.rwData!)
        
        self.navigationItem.title = self.viewModel.title

        //set room pickerview
        self.parentTagPickerView.delegate = self
        self.parentTagPickerView.dataSource = self
        self.parentTagPickerView.pickerViewStyle = .Flat
        self.parentTagPickerView.viewDepth = 0
        self.parentTagPickerView.maskDisabled = true
        self.parentTagPickerView.font = UIFont(name: "AvenirNext-Medium", size: 30)!
        self.parentTagPickerView.highlightedFont = UIFont(name: "AvenirNext-Medium", size: 30)!
        self.parentTagPickerView.reloadData()
        self.parentTagPickerView.selectItem(0)
        
        //TODO double check for location...
        let rwf = RWFramework.sharedInstance
        rwf.addDelegate(self)
        self.playPauseButton.showButtonIsPlaying(false)
        
        let button: UIButton = UIButton(type:UIButtonType.Custom)
        //set image for button
        button.setImage(UIImage(named: "map.png"), forState: UIControlState.Normal)
        //add function for button
        button.addTarget(self, action: "seeMap", forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        button.frame = CGRectMake(0, 0, 50, 50)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func resetRoomItems(){
        //TODO check if old assets are same as new assets
        let duration = 0.5
        let delay = 0.1
        let springDamping = CGFloat(0.5)
        let springVelocity = CGFloat(0.5)
        let scroll = itemsScrollView
        
        //hide old assets
        for (index, item) in scroll.subviews.enumerate(){
            UIView.animateWithDuration(duration, delay: Double(index) * delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations: {
                item.alpha = 0
                item.center.y -= 30
            }, completion: { finished in
                item.removeFromSuperview()
            })
        }
        
        //show new assets
        let total = self.viewModel.itemTags.count
        scroll.delegate = self
        let itemWidth = 300
        let itemHeight = 80
        scroll.contentSize.width = CGFloat(itemWidth)
        scroll.contentSize.height = CGFloat(itemHeight * total)
        
        tagViews = []
        for index in 0..<total {
            let tagView = TagView()
            let tag = self.viewModel.itemTags[index]
            let images = self.viewModel.data.getAssetsForTagIdOfMediaType(tag.id, mediaType: MediaType.Photo)
            let texts = self.viewModel.data.getAssetsForTagIdOfMediaType(tag.id, mediaType: MediaType.Text)

            tagView.hasImages = images.count > 0
            debugPrint("tagview index \(index) has \(images.count) images")
            
            tagView.hasTexts = texts.count > 0
            tagView.setTag(tag, index: index)
            
            //TODO should really go into setTag and use delegate...
            tagView.tagTitle.addTarget(self,
                               action: #selector(selectItem),
                               forControlEvents: UIControlEvents.TouchUpInside)
            tagView.tagTitle.tag = index
            if(tagView.hasTexts){
                tagView.textButton.addTarget(self,
                                     action: #selector(seeTextForAsset(_:)),
                                     forControlEvents: UIControlEvents.TouchUpInside)
                tagView.textButton.tag = tag.id
            }
            if(tagView.hasImages){
                tagView.cameraButton.addTarget(self,
                                       action: #selector(seeGalleryForAsset(_:)),
                                       forControlEvents: UIControlEvents.TouchUpInside)
                tagView.cameraButton.tag = tag.id
            }

            let audioAssets : [Asset] = self.viewModel.data.getAssetsForTagIdOfMediaType(tagView.id!, mediaType: MediaType.Audio)
            debugPrint("audio assets for tag \(tagView.id!)")
            dump(audioAssets)
            let totalLength = audioAssets.map({$0.audioLength}).reduce(0, combine: +)
            debugPrint("total length is \(totalLength)")
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
            scroll.addSubview(tagView)
            UIView.animateWithDuration(duration, delay: Double(index) * delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations: {
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
        let rwf = RWFramework.sharedInstance
        if(rwf.isPlaying){
            rwf.stop()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        let scroll = itemsScrollView
        let newContentOffsetX = (scroll.contentSize.width/2) - (scroll.bounds.size.width/2)
        scroll.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - AKPickerViewDataSource
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.viewModel.roomTags.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.viewModel.roomTags[item].value
    }
    
    func pickerView(pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor.lightGrayColor()
        label.highlightedTextColor = UIColor.blackColor()
        label.backgroundColor = UIColor.whiteColor()
    }
    
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(20, 20)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }
    
    
    
    // MARK: - AKPickerViewDelegate
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        debugPrint("selected room with index \(item)")
        if( self.viewModel.selectedRoomIndex != item){
            self.viewModel.selectedRoomIndex = item
            resetRoomItems()
        }
    }
    
    // MARK: RWFramework Protocol
    func rwUpdateStatus(message: String) {
        print("update status")
        print(message)
    }
    
    func rwGetStreamsIdCurrentSuccess(data: NSData?) {
        print("current success")
        dump(data)
    }

    func rwPostStreamsSuccess(data: NSData?) {
        print("stream success")
        dump(data)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.playPauseButton.enabled = true
            self.nextButton.enabled = true
            self.previousButton.enabled = true
            //TODO enable
        })
    }
    
    func rwPostStreamsError(error: NSError?) {
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }

    func rwPatchStreamsIdSuccess(data: NSData?){
//        print("patch stream success")
//        dump(data)

    }
    
    func rwPatchStreamsIdFailure(error: NSError?){
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
    func rwPostStreamsIdHeartbeatSuccess(data: NSData?) {
        debugPrint("heartbeat success")
//        dump(data)
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        })
    }
    
    func rwPostStreamsIdNextSuccess(data: NSData?) {
        debugPrint("next success")
        dump(data)
    }

    func rwGetAssetsIdSuccess(data: NSData?){
        debugPrint("get asset id success")
        dump(data)
    }

    func rwGetAssetsIdFailure(error: NSError?){
        debugPrint("get asset id error")
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
    func rwObserveValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        //the stream has started
        if keyPath == "timedMetadata" {
            if waitingToStart{
                waitingToStart = false
                SVProgressHUD.dismiss()
                //push tags as selected
                let rwf = RWFramework.sharedInstance
                var tagsToSubmit : [String] = []
//                tagsToSubmit.append(String(self.viewModel.exhibitionTag.id))
//                if let roomTag = self.viewModel.selectedRoomTag {
//                    tagsToSubmit.append(String(roomTag.id))
//                }
                if let itemTag = self.viewModel.selectedItemTag {
                    tagsToSubmit.append(String(itemTag.id))
                }
                let tagsString = tagsToSubmit.joinWithSeparator(",")
                debugPrint("patching stream with tags \(tagsString)")
                rwf.submitTags(tagsString)
                self.playPauseButton.showButtonIsPlaying(true)
                self.nextButton.enabled = true
                self.previousButton.enabled = true
            }

            //get values
            guard let newChange = change["new"] as? NSArray,
                let avMetadataItem = newChange.firstObject as? AVMetadataItem else{
                return
            }
            guard var value = avMetadataItem.value as? String else{
                    debugPrint("value problem")
                    return
            }
            value = value.stringByReplacingOccurrencesOfString("Roundware - ", withString: "?", options: NSStringCompareOptions.LiteralSearch, range: nil)
            guard let params = NSURL(string: value) else{
                debugPrint("param problem")
                dump(value)
                return
            }
            guard let queryItems = params.queryItems else{
                debugPrint("query problem")
                dump(params)
                return
            }

            //ok we have our values
            //let see what asset we are on
            guard let assetID = queryItems["asset"] else{
                debugPrint("no assetID set")
                dump(queryItems)
                return
            }
            
            debugPrint("assetID is \(assetID)")
            
            //TODO api update will mean we look at remaining and total in queryItems and update progress based on that
            
            if let assetTagView = tagViews.filter({ $0.arrayOfAssetIds.contains( assetID )}).first {
                if let index = self.viewModel.selectedItemIndex{
                    debugPrint("selectedItemIndex is \(index) and its tag id is \(self.tagViews[index].id)")
                    debugPrint("and that tag has these audio assets such as...")
                    dump(self.viewModel.data.getAssetsForTagIdOfMediaType(self.tagViews[index].id!, mediaType: MediaType.Audio))
                    //TODO should really have a check on the index
                    if tagViews[index] == assetTagView {
                        debugPrint("the current asset belongs to our current tagview")
                        if let remaining = queryItems["remaining"] {
                            assetTagView.currentAssetIndex = assetTagView.arrayOfAssetIds.count - Int(remaining)! - 1
                            if assetTagView.arrayOfAssetIds.count > 0 {
                                //update tag progress
                                debugPrint("there are \(remaining) assets remaining of \(assetTagView.arrayOfAssetIds.count)")
                                let percentage = (Float(assetTagView.arrayOfAssetIds.count) - Float(remaining)!) / Float(assetTagView.arrayOfAssetIds.count)
                                debugPrint("we are \(percentage) through this tag's assets")
                                assetTagView.tagProgress.setProgress(percentage, animated: true)
                                
                                //update elapsed time
                                let seconds = (assetTagView.totalLength * percentage) % 60
                                let minutes = ((assetTagView.totalLength * percentage) / 60) % 60
                                let time = String(format: "%02d:%02d", Int(minutes), Int(seconds))
                                elapsedTimeLabel.text = time
                                elapsedTimeLabel.accessibilityLabel = "and about \(minutes) minutes and \(seconds) seconds have elapsed for this tag"
                            } else {
                                debugPrint("0 assets in tagview")
                            }
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
                    } else {
                        debugPrint("its a new tagview")
                        selectItemAtIndex(tagViews.indexOf(assetTagView)!)
                    }
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