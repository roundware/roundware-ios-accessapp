import UIKit
import CoreLocation
import RWFramework

class ListenViewController: BaseViewController, RWFrameworkProtocol {

  @IBOutlet weak var exhibitionLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var segmentedControl: UISegmentedControl!

  // MARK: - View lifecycle

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Listen"

    if let v = self.segmentedControl.subviews[0] as? UIView {
      v.accessibilityHint = "Filters by categories"
    }
    if let v = self.segmentedControl.subviews[1] as? UIView {
      v.accessibilityHint = "Filters by contributors"
    }
    if let v = self.segmentedControl.subviews[2] as? UIView {
      v.accessibilityHint = "Filters by questions"
    }

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("globalAudioStarted:"), name: "RW_STARTED_AUDIO_NOTIFICATION", object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.becomeFirstResponder()
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

    RWFramework.sharedInstance.stop()
    self.playButton.setImage(UIImage(named: "player-button"), forState: .Normal)
    self.playButton.accessibilityLabel = "Play button"
    SVProgressHUD.dismiss()
  }
}
