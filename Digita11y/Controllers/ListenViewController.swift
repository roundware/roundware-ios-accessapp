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

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Mission Moon"

    if let v = self.segmentedControl.subviews[0] as? UIView {
      v.accessibilityHint = "Filters by categories"
    }
    if let v = self.segmentedControl.subviews[1] as? UIView {
      v.accessibilityHint = "Filters by contributors"
    }
    if let v = self.segmentedControl.subviews[2] as? UIView {
      v.accessibilityHint = "Filters by questions"
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.becomeFirstResponder()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    var rwf = RWFramework.sharedInstance
    rwf.addDelegate(self)

    self.playButton.enabled = self.rwData?.stream == nil ? false : true

    // The UITabBar likes to steal focus.  So let's delay for a bit then become first responder.
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.playButton.becomeFirstResponder()
    }
  }

  @IBAction func play(sender: AnyObject) {
    var rwf = RWFramework.sharedInstance
    rwf.isPlaying ? rwf.stop() : rwf.play()
    // put up spinner
  }

  func rwLocationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    debugPrintln("ListenViewController: didUpdateLocations")
  }

  func rwLocationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    debugPrintln("ListenViewController: didChangeAuthorizationStatus")
  }

  func rwPostStreamsSuccess(data: NSData?) {
    self.playButton.enabled = true
    let json = JSON(data: data!)
    debugPrintln("ListenViewController: rwPostStreamsSuccess\n\(json)")
  }

  func rwObserveValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if keyPath == "timedMetadata" {
      debugPrintln("keypath")
    }
  }
}
