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
import Crashlytics
import SwiftyJSON

//TODO audio player delegate?

//https://github.com/Akkyie/AKPickerView-Swift
class TagsViewController: BaseViewController, RWFrameworkProtocol, AKPickerViewDataSource, AKPickerViewDelegate {
    var viewModel: TagsViewModel!
    var items : [TagView] = []

    // MARK: Outlets
    @IBOutlet weak var parentTagPickerView: AKPickerView!
    @IBOutlet weak var itemsScrollView: UIScrollView!
    @IBOutlet weak var exhibitionLabel: UILabelHeadline!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var playbackProgress: UIProgressView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // MARK: Main Action
    @IBAction func cycleSpeed(sender: AnyObject) {
        //TODO
    }
    
    @IBAction func toggleStream(sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        rwf.isPlaying ? rwf.stop() : rwf.play()
        self.playPauseButton.drawButton(rwf.isPlaying)
//        listenPlayButton.setTitle(rwf.isPlaying ? "Stop" : "Play", forState: UIControlState.Normal)
    }
    
    @IBAction func nextTag(sender: AnyObject) {
        RWFramework.sharedInstance.next()
    }
    
    @IBAction func previousTag(sender: AnyObject) {
        
    }
    
    @IBAction func contribute(sender: AnyObject) {
        let rwf = RWFramework.sharedInstance
        if(rwf.isPlaying){
            rwf.stop()
        }
        self.performSegueWithIdentifier("ContributeSegue", sender: sender)
    }
    
    @IBAction func seeMap(sender: AnyObject) {
        //TODO might be subview?
        self.performSegueWithIdentifier("MapSegue", sender: sender)
        //TODO reset after coming back from contribute
    }
    
    // MARK: Asset Actions
    @IBAction func selectAsset(sender: UIButton) {
        let index = sender.tag
        let tagView = items[index]
        tagView.selected = !tagView.selected
        if (tagView.selected){
            //deselect others TODO check filter for selected
            let others = items.filter({$0 !== tagView})
            others.forEach({$0.selected = false })
            //set selection in viewmodel for state
            self.viewModel.selectedItemIndex(index)
            //send message to stream
            let rwf = RWFramework.sharedInstance
            rwf.submitTags(String(self.viewModel.selectedItemTag!.id))
            //TODO expand asset options for this tag 
        }
    }
    
    @IBAction func seeGalleryForAsset(sender: UIButton) {
        //TODO set item
        self.performSegueWithIdentifier("GallerySegue", sender: sender)
        //TODO launch gallery subview/modal
    }
    
    @IBAction func seeTextForAsset(sender: UIButton) {
        //TODO might be subview?
        self.performSegueWithIdentifier("ReadSegue", sender: sender)
        //TODO launch text subview/modal
    }
    
//    @IBAction func openModal(sender: AnyObject) {
//    }
//    
//    @IBAction func closeModal(sender: AnyObject) {
//        //TODO expand options, collapse others
//    }
//    
//    @IBAction func pageAsset(sender: AnyObject) {
//        //TODO expand options, collapse others
//    }
    
    // MARK: Segue Actions
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
    
    func resetRoomItems(){
        //TODO call from stream finish/start
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
        let total = self.viewModel.numberOfItems()
        scroll.delegate = self
        let itemWidth = 300
        dump(itemWidth)
        let itemHeight = 80
        scroll.contentSize.width = CGFloat(itemWidth)
        scroll.contentSize.height = CGFloat(itemHeight * total)
        items = []
        for index in 0..<total {
            let item = TagView()
            let frame = CGRect(
                x: 0,
                y: index * itemHeight,
                width: Int(itemWidth),
                height: itemHeight)
            item.frame = frame
            item.setTag(self.viewModel.itemTags[index])
            
            item.textButton.addTarget(self,
                                      action: #selector(TagsViewController.seeTextForAsset(_:)),
                                      forControlEvents: UIControlEvents.TouchUpInside)
            item.textButton.tag = index
            item.cameraButton.addTarget(self,
                                        action: #selector(TagsViewController.seeGalleryForAsset(_:)),
                                        forControlEvents: UIControlEvents.TouchUpInside)
            item.cameraButton.tag = index
            item.tagTitle.addTarget(self,
                                    action: #selector(TagsViewController.selectAsset(_:)),
                                    forControlEvents: UIControlEvents.TouchUpInside)
            item.tagTitle.tag = index
            
            //might be unnecessary
            items.append(item)
            
            item.alpha = 0
            item.center.y -= 30
                
            scroll.addSubview(item)
            UIView.animateWithDuration(duration, delay: Double(index) * delay, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [], animations: {
                item.alpha = 1
                item.center.y += 30
                }, completion: { finished in
            })
            //UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.TransitionNone,
            //animations: {self.view.addSubview(effectView)}, completion: nil)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = TagsViewModel(data: self.rwData!)
        exhibitionLabel.text = self.viewModel.title

        //set room pickerview
        self.parentTagPickerView.delegate = self
        self.parentTagPickerView.dataSource = self
        self.parentTagPickerView.pickerViewStyle = .Flat
        self.parentTagPickerView.viewDepth = 0
        self.parentTagPickerView.maskDisabled = true
        self.parentTagPickerView.font = UIFont(name: "AvenirNext-Medium", size: 30)!
        self.parentTagPickerView.highlightedFont = UIFont(name: "AvenirNext-Medium", size: 30)!
        
        //TODO if first selection, else restore...
        self.parentTagPickerView.reloadData()
        self.parentTagPickerView.selectItem(0)
        
        //TODO double check for location...
        
        //start stream
        setupAudio() { granted, error in
            if granted == false {
                debugPrint("Unable to setup audio: \(error)")
                if let error = error {
                    CLSNSLogv("Unable to setup audio: \(error)", getVaList([error]))
                }
            } else {
                debugPrint("setup audio win")
                let rwf = RWFramework.sharedInstance
                rwf.addDelegate(self)
                rwf.play()
                self.playPauseButton.drawButton(true)
            }
        }
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
    
    // MARK: Gallery Modal
    
    // MARK: Map Modal
    
    // MARK: Text Modal
    
    // MARK: - AKPickerViewDataSource
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.viewModel.numberOfRooms()
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

    //used in picker
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }

    
    // MARK: - AKPickerViewDelegate
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        self.viewModel.selectedRoomIndex(item)
        //TODO callback http://artsy.github.io/blog/2015/09/24/mvvm-in-swift/
        //or protocol https://www.natashatherobot.com/updated-protocol-oriented-mvvm-in-swift-2-0/
        resetRoomItems()
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
        print("stream error")
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }

    func rwPatchStreamsIdSuccess(data: NSData?){
        print("patch stream success")
        dump(data)

    }
    
    func rwPatchStreamsIdFailure(error: NSError?){
        print("patch stream error")
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
    func rwPostStreamsIdHeartbeatSuccess(data: NSData?) {
        debugPrint("heartbeat success")
        dump(data)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        })
    }
    
    func rwPostStreamsIdNextSuccess(data: NSData?) {
        debugPrint("next success")
        dump(data)
    }

    func rwGetAssetsSuccess(data: NSData?){
        print("get assets success")
        dump(data)
    }

    func rwGetAssetsFailure(error: NSError?){
        print("get assets error")
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
    func rwGetAssetsIdSuccess(data: NSData?){
        print("get asset id success")
        dump(data)
    }

    func rwGetAssetsIdFailure(error: NSError?){
        print("get asset id error")
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
//    func rwObserveValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//  }

}