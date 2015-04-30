import UIKit
import AVFoundation
import RWFramework

class BrowseDetailTableViewController: BaseTableViewController, RWFrameworkProtocol {

  var exhibitionID = 0
  var assetPlayer: AssetPlayer?
  var timer: NSTimer?
  var currentAsset: Int = 0

  var assetViewModel: AssetViewModel?
  var filteredAssetViewModel: AssetViewModel?

  var magicTapDidStop = false

  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var assetRefreshControl: UIRefreshControl!
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    self.automaticallyAdjustsScrollViewInsets = false

    tableView.estimatedRowHeight = 94
    tableView.rowHeight = UITableViewAutomaticDimension
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("globalAudioStarted:"), name: "RW_STARTED_AUDIO_NOTIFICATION", object: nil)
    self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: Selector("filterTapped")), animated: false)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true
    self.navigationController?.view.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

    self.assetViewModel = AssetViewModel(exhibitionID: self.exhibitionID, data: self.rwData!)
    self.navigationItem.title = self.assetViewModel?.titleForExhibition()
    headerImageView.sd_setImageWithURL(self.assetViewModel?.imageURLForExhibition(), placeholderImage: UIImage(named:"browse-cell"))

    if let vm = self.filteredAssetViewModel {
      self.assetViewModel = self.filteredAssetViewModel
    }

    self.navigationController?.navigationBar.becomeFirstResponder()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    RWFramework.sharedInstance.addDelegate(self)
    tableView.reloadData()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.assetViewModel?.numberOfAssets() ?? 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let asset = self.assetViewModel?.assetAtIndex(indexPath.row)
    let tag = self.assetViewModel?.tagForAssetAtIndex(indexPath.row) ?? Tag(tagId: 0, value: "Telescope M-53 Audio 1")
    if let asset = asset {
      let tagViewModel = TagViewModel(tag: tag, asset: asset)

      switch (asset.mediaType) {
      case .Text:
        let cell = tableView.dequeueReusableCellWithIdentifier(BrowseTextTableViewCell.Identifier, forIndexPath: indexPath) as! BrowseTextTableViewCell
        cell.titleLabel.text = tagViewModel.title()
        cell.assetLabel.text = tagViewModel.text()
        cell.accessibilityLabel = tagViewModel.accessibilityLabelText()
        return cell
      case .Audio:
        let cell = tableView.dequeueReusableCellWithIdentifier(BrowseDetailTableViewCell.Identifier, forIndexPath: indexPath) as! BrowseDetailTableViewCell
        cell.assetLabel.text = tagViewModel.title()
        cell.accessibilityLabel = tagViewModel.accessibilityLabelText()
        cell.playButton.addTarget(self, action: "playAudio:", forControlEvents: .TouchUpInside)
        cell.playButton.tag = indexPath.row
        return cell
      case .Photo:
        let cell = tableView.dequeueReusableCellWithIdentifier(BrowsePhotoTableViewCell.Identifier, forIndexPath: indexPath) as! BrowsePhotoTableViewCell
        cell.titleLabel.text = tagViewModel.title()
        cell.accessibilityLabel = tagViewModel.accessibilityLabelText()
        cell.accessibilityHint = "Fullscreens image"
        cell.assetImageView.sd_setImageWithURL(asset.fileURL)
        cell.tag = indexPath.row
        return cell
      default:
        let cell = tableView.dequeueReusableCellWithIdentifier(BrowseDetailTableViewCell.Identifier, forIndexPath: indexPath) as! BrowseDetailTableViewCell
        cell.assetLabel.text = tagViewModel.title()
        cell.accessibilityLabel = tagViewModel.accessibilityLabelText()
        return cell
      }
    } else {
      debugPrintln("COULDN'T UNWRAP ASSET")
    }

    return UITableViewCell()
  }

  func resetPlayButtons() {
    for var i = 0; i < self.assetViewModel?.numberOfAssets(); ++i {
      let a = self.assetViewModel?.assetAtIndex(i)
      if a?.mediaType == .Audio {
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? BrowseDetailTableViewCell {
          cell.resetView()
        }
      }
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let asset = self.assetViewModel?.assetAtIndex(indexPath.row)
    if asset?.mediaType == MediaType.Audio {
      if let cell = tableView.cellForRowAtIndexPath(indexPath) as? BrowseDetailTableViewCell {
        self.playAudio(cell.playButton)
      }
    }
  }

  // MARK: - Audio

  func audioStopped() {
    // Make sure this fires after the NSTimer fires
    delay(0.25) {
      self.timer?.invalidate()
      self.resetPlayButtons()
      self.assetPlayer?.player?.currentItem?.seekToTime(CMTimeMakeWithSeconds(0, 100000000))
    }
  }

  func playAudio(button: UIButton) {
    self.resetPlayButtons()
    button.resignFirstResponder()
    if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) {
      cell.resignFirstResponder()
    }

    let asset = self.assetViewModel?.assetAtIndex(button.tag)
    if assetPlayer?.asset.assetID == asset!.assetID {
      if let player = assetPlayer?.player {
        if assetPlayer!.isPlaying {
          player.pause()
          timer?.invalidate()
        } else {
          player.play()
          currentAsset = button.tag
          startTimerWithPlayer(player)
          button.setImage(UIImage(named:"browse-pause-button"), forState: .Normal)
          if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as? BrowseDetailTableViewCell {
            cell.accessibilityHint = "Pauses audio"
          }
        }
      } else {
        assetPlayer = AssetPlayer(asset: asset!)
        assetPlayer!.player?.play()
        currentAsset = button.tag
        startTimerWithPlayer(assetPlayer!.player!)
        button.setImage(UIImage(named:"browse-pause-button"), forState: .Normal)
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as? BrowseDetailTableViewCell {
          cell.accessibilityHint = "Pauses audio"
        }
      }
    } else {
      if let player = assetPlayer?.player {
        player.pause()
        timer?.invalidate()
      }
      assetPlayer = AssetPlayer(asset: asset!)
      assetPlayer!.player?.play()
      currentAsset = button.tag
      startTimerWithPlayer(assetPlayer!.player!)
      button.setImage(UIImage(named:"browse-pause-button"), forState: .Normal)
      if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as? BrowseDetailTableViewCell {
        cell.accessibilityHint = "Pauses audio"
      }
    }
  }

  func startTimerWithPlayer(player: AVPlayer) {
    NSNotificationCenter.defaultCenter().postNotificationName("RW_STARTED_AUDIO_NOTIFICATION", object: self)
    timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:Selector("audioTimer:"), userInfo:nil, repeats:true)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("audioStopped"), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
  }

  func audioTimer(timer: NSTimer) {
    if let time = assetPlayer?.player?.currentItem.currentTime(),
           cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentAsset, inSection: 0)) as? BrowseDetailTableViewCell {
      var dt = CMTimeGetSeconds(time)
      let asset = self.assetViewModel?.assetAtIndex(currentAsset)
      var percent = asset!.audioLength == 0.0 ? 0.0 : Float(dt)/asset!.audioLength
      cell.timeProgressView.progress = percent
      let percentInt = Int(percent*100.0)
      if let name = cell.assetLabel.text {
        cell.resignFirstResponder()
        cell.accessibilityLabel = String("\(percentInt) percent complete, \(name), audio")
      }
    }
  }

  func rwAudioPlayerDidFinishPlaying() {
    self.resetPlayButtons()
  }

  func globalAudioStarted(note: NSNotification) {
    if let sender = note.object as? BrowseDetailTableViewController {
      if sender == self {
        return
      }
    }
    self.assetPlayer?.player?.pause()
    self.resetPlayButtons()
  }

  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)

    if segue.identifier == "BrowsePhotoSegue" {
      if let to = segue.destinationViewController as? BrowsePhotoViewController,
             cell = sender as? BrowsePhotoTableViewCell {
        to.asset = self.assetViewModel?.assetAtIndex(cell.tag)
        if let name = cell.titleLabel.text {
          to.name = name
        }
      }
    }
  }

  // MARK: - Actions

  @IBAction func refreshAssets(sender: AnyObject) {
    requestAssets { assets in
      self.rwData?.assets = assets
      self.assetViewModel = AssetViewModel(exhibitionID: self.exhibitionID, data: self.rwData!)
      self.assetRefreshControl.endRefreshing()
      self.tableView.reloadData()
    }
  }

  func filterTapped() {
    var vc = BrowseTagsViewController(style: .Grouped)
    vc.rwData = self.rwData
    vc.assetViewModel = self.assetViewModel
    vc.hidesBottomBarWhenPushed = true
    self.filteredAssetViewModel = nil
    vc.filterCompleted = { assetViewModel in
      self.filteredAssetViewModel = assetViewModel
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }

  // MARK: - Magic tap

  override func accessibilityPerformMagicTap() -> Bool {
    debugPrintln("ACCESSIBILITY PERFORM MAGIC TAP - BROWSE DETAIL")
    if let player = assetPlayer?.player {
      if assetPlayer!.isPlaying {
        player.pause()
        timer?.invalidate()
        resetPlayButtons()
        magicTapDidStop = true
        return true
      } else if magicTapDidStop {
        player.play()
        startTimerWithPlayer(player)
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentAsset, inSection: 0)) as? BrowseDetailTableViewCell {
          cell.accessibilityHint = "Pauses audio"
          cell.playButton.setImage(UIImage(named:"browse-pause-button"), forState: .Normal)
        }
        magicTapDidStop = false
        return true
      }
    }

    return false
  }

  func rwUpdateStatus(message: String) {}
}
