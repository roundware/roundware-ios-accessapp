import UIKit
import RWFramework

class ListenViewController: BaseViewController {

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
      v.accessibilityLabel = "Filters by categories"
    }
    if let v = self.segmentedControl.subviews[1] as? UIView {
      v.accessibilityLabel = "Filters by contributors"
    }
    if let v = self.segmentedControl.subviews[2] as? UIView {
      v.accessibilityLabel = "Filters by questions"
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.becomeFirstResponder()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    RWFramework.sharedInstance.requestWhenInUseAuthorizationForLocation()

    self.playButton.becomeFirstResponder()
  }

  @IBAction func play(sender: AnyObject) {
    var rwf = RWFramework.sharedInstance
    rwf.isPlaying ? rwf.stop() : rwf.play()
  }

  @IBAction func previous(sender: AnyObject) {
    RWFramework.sharedInstance.current()
  }

  @IBAction func next(sender: AnyObject) {
    RWFramework.sharedInstance.next()
  }
}
