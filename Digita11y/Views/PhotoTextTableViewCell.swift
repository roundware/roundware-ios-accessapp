import UIKit

class PhotoTextTableViewCell: UITableViewCell {

  static let Identifier = "PhotoTextCellIdentifier"

  @IBOutlet weak var artifactImageView: UIImageView!
  @IBOutlet weak var artifactTextView: SZTextView!
  @IBOutlet weak var discardButton: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()

    discardButton.layer.cornerRadius = 4.0
    
    artifactTextView.placeholder = "Describe this photo..."
    artifactTextView.placeholderTextColor = UIColor.lightGrayColor()
    artifactTextView.accessibilityHint = "Describe this photo"
  }
}
