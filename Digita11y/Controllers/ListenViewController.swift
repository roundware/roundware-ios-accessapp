import UIKit
import RWFramework

class ListenViewController: BaseViewController {

  @IBOutlet weak var exhibitionLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
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
