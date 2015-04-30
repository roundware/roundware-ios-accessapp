import UIKit
import CoreLocation
import RWFramework

class ListenViewController: BaseViewController, RWFrameworkProtocol {

  @IBOutlet weak var exhibitionLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var playButton: UIButton!

  // MARK: - View lifecycle

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Listen"
    self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Channels", style: .Plain, target: self, action: Selector("filterTapped")), animated: false)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("globalAudioStarted:"), name: "RW_STARTED_AUDIO_NOTIFICATION", object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.becomeFirstResponder()

    if let exhibitionIDs = RWFramework.sharedInstance.getListenTagsCurrent("exhibition") as? [Int],
            exhibitionID = exhibitionIDs.first {
      let tags = self.rwData?.exhibitions.filter { $0.tagId == exhibitionID }
      if let tag = tags?.first {
        self.navigationItem.title = tag.value
        self.imageView.sd_setImageWithURL(NSURL(string: tag.headerImageURL), placeholderImage: UIImage(named:"listen-heroshot"))
      }
    }

    // Set play button state in case magic tap turned audio on
    if RWFramework.sharedInstance.isPlaying {
      self.playButton.setImage(UIImage(named: "stop-button"), forState: .Normal)
      self.playButton.accessibilityLabel = "Stop button"
    } else {
      self.playButton.setImage(UIImage(named: "player-button"), forState: .Normal)
      self.playButton.accessibilityLabel = "Play button"
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    RWFramework.sharedInstance.addDelegate(self)

    self.playButton.enabled = self.rwData?.stream == nil ? false : true

    // The UITabBar likes to steal focus.  So let's delay for a bit then become first responder.
    delay(0.5) {
      self.playButton.becomeFirstResponder()
    }
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    SVProgressHUD.dismiss()
  }
  
  // MARK: - Actions

  @IBAction func play(sender: AnyObject) {
    var rwf = RWFramework.sharedInstance
    if rwf.isPlaying {
      rwf.stop()
      self.playButton.setImage(UIImage(named: "player-button"), forState: .Normal)
      self.playButton.accessibilityLabel = "Play button"
      SVProgressHUD.dismiss()
    } else {
      rwf.play()
      NSNotificationCenter.defaultCenter().postNotificationName("RW_STARTED_AUDIO_NOTIFICATION", object: self)
      self.playButton.setImage(UIImage(named: "stop-button"), forState: .Normal)
      self.playButton.accessibilityLabel = "Stop button"
      SVProgressHUD.showWithStatus("Loading Stream")
    }
  }

  func filterTapped() {
    var vc = ListenTagsTableViewController(style: .Grouped)
    vc.rwData = self.rwData
    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)
  }

  // MARK: - RWFrameworkProtocol

  func rwPostStreamsSuccess(data: NSData?) {
    self.playButton.enabled = true
  }

  func rwPostStreamsFailure(error: NSError?) {
    self.playButton.enabled = false
  }

  func rwObserveValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if keyPath == "timedMetadata" {
      SVProgressHUD.dismiss()
    }
  }

  func rwAudioPlayerDidFinishPlaying() {
    RWFramework.sharedInstance.stop()
    self.playButton.setImage(UIImage(named: "player-button"), forState: .Normal)
    self.playButton.accessibilityLabel = "Play button"
  }

  func globalAudioStarted(note: NSNotification) {
    if let sender = note.object as? ListenViewController {
      if sender == self {
        return
      }
    }

    if let sender = note.object as? UIApplicationDelegate {
      return  // Magic tap.  Don't stop audio
    }

    RWFramework.sharedInstance.stop()
    self.playButton.setImage(UIImage(named: "player-button"), forState: .Normal)
    self.playButton.accessibilityLabel = "Play button"
    SVProgressHUD.dismiss()
  }

  func rwUpdateStatus(message: String) {}
}
