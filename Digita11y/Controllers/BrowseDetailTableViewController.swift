import UIKit
import AVFoundation
import RWFramework

class BrowseDetailTableViewController: BaseTableViewController, RWFrameworkProtocol {

  var tagID = 0
  var assets: [Asset] = []
  var assetPlayer: AssetPlayer?
  var timer: NSTimer?
  var currentAsset: Int = 0

  @IBOutlet weak var headerImageView: UIImageView!
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    self.automaticallyAdjustsScrollViewInsets = false

    tableView.estimatedRowHeight = 94
    tableView.rowHeight = UITableViewAutomaticDimension
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("globalAudioStarted:"), name: "RW_STARTED_AUDIO_NOTIFICATION", object: nil)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true
    self.navigationController?.view.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

    var exhibition = self.rwData?.exhibitions.filter { $0.tagId == self.tagID }.first
    self.navigationItem.title = exhibition?.value
    if let urlString = exhibition?.headerImageURL {
      headerImageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named:"browse-cell"))
    }

    assets = self.rwData?.assets.filter { contains($0.tagIDs, self.tagID) } ?? []

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
      return assets.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let asset = assets[indexPath.row]
    let tag = asset.tagIDs.map { self.rwData?.objectForID($0) }.filter { $0 != nil }.first

    switch (asset.mediaType) {
    case .Text:
      let cell = tableView.dequeueReusableCellWithIdentifier(BrowseTextTableViewCell.Identifier, forIndexPath: indexPath) as! BrowseTextTableViewCell
      cell.titleLabel.text = tag??.value ?? "Telescope M-53 Audio 1"
      cell.accessibilityLabel = cell.titleLabel.text
      if let url = asset.fileURL.absoluteString {

        dispatch_async(dispatch_get_main_queue()) {
          // FIX: This is kinda messed because Alamofire is included directly in the project.
          // Fix this when use_frameworks has been fixed in Cocoapods
          request(.GET, url).responseString { (_, _, string, _) in
            if let str = string {
              debugPrintln("UPDATE TEXT")
              cell.assetLabel.text = str

              // Toggling updates forces the tableview to recalculate cell size
              self.tableView.beginUpdates()
              self.tableView.endUpdates()
            }
          }
        }
      }
      return cell
    case .Audio:
      let cell = tableView.dequeueReusableCellWithIdentifier(BrowseDetailTableViewCell.Identifier, forIndexPath: indexPath) as! BrowseDetailTableViewCell
      cell.assetLabel.text = tag??.value ?? "Telescope M-53 Audio 1"
      if let name = cell.assetLabel.text {
        cell.accessibilityLabel = String("\(name), audio")
      }
      cell.playButton.addTarget(self, action: "playAudio:", forControlEvents: .TouchUpInside)
      cell.playButton.tag = indexPath.row
      return cell
    case .Photo:
      let cell = tableView.dequeueReusableCellWithIdentifier(BrowsePhotoTableViewCell.Identifier, forIndexPath: indexPath) as! BrowsePhotoTableViewCell
      var name = tag??.value ?? "Telescope M-53 Audio 1"
      cell.titleLabel.text = name
      cell.accessibilityLabel = String("\(name), image, \(asset.assetDescription)")
      cell.accessibilityHint = "Fullscreens image"
      cell.assetImageView.sd_setImageWithURL(asset.fileURL)
      cell.tag = indexPath.row
      return cell
    default:
      let cell = tableView.dequeueReusableCellWithIdentifier(BrowseDetailTableViewCell.Identifier, forIndexPath: indexPath) as! BrowseDetailTableViewCell
      cell.assetLabel.text = tag??.value ?? "Telescope M-53 Audio 1"
      cell.accessibilityLabel = cell.assetLabel.text
      return cell
    }
  }

  func resetPlayButtons() {
    for var i = 0; i < assets.count; ++i {
      var a = assets[i]
      if a.mediaType == .Audio {
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? BrowseDetailTableViewCell {
          cell.playButton.setImage(UIImage(named:"browse-play-button"), forState: .Normal)
          cell.timeProgressView.progress = 0.0
          cell.accessibilityHint = "Plays audio"
          if let name = cell.assetLabel.text {
            cell.accessibilityLabel = String("\(name), audio")
          }
        }
      }
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let asset = assets[indexPath.row]
    if asset.mediaType == MediaType.Audio {
      if let cell = tableView.cellForRowAtIndexPath(indexPath) as? BrowseDetailTableViewCell {
        self.playAudio(cell.playButton)
      }
    }
  }

  // MARK: - Audio

  func audioStopped() {
    // Make sure this fires after the NSTimer fires
    delay(0.25) {
      self.resetPlayButtons()
      self.assetPlayer?.player?.currentItem?.seekToTime(CMTimeMakeWithSeconds(0, 100000000))
    }
  }

  func playAudio(button: UIButton) {
    self.resetPlayButtons()

    let asset = assets[button.tag]
    if assetPlayer?.asset.assetID == asset.assetID {
      if let player = assetPlayer?.player {
        if assetPlayer!.isPlaying {
          player.pause()
          timer?.invalidate()
        } else {
          player.play()
          NSNotificationCenter.defaultCenter().postNotificationName("RW_STARTED_AUDIO_NOTIFICATION", object: self)
          currentAsset = button.tag
          timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:Selector("audioTimer:"), userInfo:nil, repeats:true)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("audioStopped"), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
          button.setImage(UIImage(named:"browse-pause-button"), forState: .Normal)
          if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as? BrowseDetailTableViewCell {
            cell.accessibilityHint = "Pauses audio"
          }
        }
      } else {
        assetPlayer = AssetPlayer(asset: asset)
        assetPlayer!.player?.play()
        NSNotificationCenter.defaultCenter().postNotificationName("RW_STARTED_AUDIO_NOTIFICATION", object: self)
        currentAsset = button.tag
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:Selector("audioTimer:"), userInfo:nil, repeats:true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("audioStopped"), name: AVPlayerItemDidPlayToEndTimeNotification, object: assetPlayer!.player?.currentItem)
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
      assetPlayer = AssetPlayer(asset: asset)
      assetPlayer!.player?.play()
      NSNotificationCenter.defaultCenter().postNotificationName("RW_STARTED_AUDIO_NOTIFICATION", object: self)
      currentAsset = button.tag
      timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:Selector("audioTimer:"), userInfo:nil, repeats:true)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("audioStopped"), name: AVPlayerItemDidPlayToEndTimeNotification, object: assetPlayer!.player?.currentItem)
      button.setImage(UIImage(named:"browse-pause-button"), forState: .Normal)
      if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as? BrowseDetailTableViewCell {
        cell.accessibilityHint = "Pauses audio"
      }
    }
  }

  func audioTimer(timer: NSTimer) {
    if let time = assetPlayer?.player?.currentItem.currentTime(),
           cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentAsset, inSection: 0)) as? BrowseDetailTableViewCell {
      var dt = CMTimeGetSeconds(time)
      let asset = assets[currentAsset]
      var percent = asset.audioLength == 0.0 ? 0.0 : Float(dt)/asset.audioLength
      cell.timeProgressView.progress = percent
      var percentInt = Int(percent*100.0)
      if let name = cell.assetLabel.text {
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
        to.asset = assets[cell.tag]
        if let name = cell.titleLabel.text {
          to.name = name
        }
      }
    }
  }
}
