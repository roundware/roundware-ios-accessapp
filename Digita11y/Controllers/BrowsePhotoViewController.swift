import UIKit

class BrowsePhotoViewController : UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  var asset: Asset?

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    self.navigationController?.navigationBar.translucent = true

    imageView.sd_setImageWithURL(asset?.fileURL)
  }
}