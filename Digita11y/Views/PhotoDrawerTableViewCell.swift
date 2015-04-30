import UIKit

class PhotoDrawerTableViewCell: UITableViewCell {
  static let Identifier = "PhotoDrawerCellIdentifier"

  @IBOutlet weak var cameraButton: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    cameraButton.layer.cornerRadius = 4.0
  }
}
