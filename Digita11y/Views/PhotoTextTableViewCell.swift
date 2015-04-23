import UIKit

class PhotoTextTableViewCell: UITableViewCell {
  static let Identifier = "PhotoTextCellIdentifier"
  @IBOutlet weak var artifactImageView: UIImageView!
  @IBOutlet weak var artifactTextView: SZTextView!
  @IBOutlet weak var discardButton: UIButton!
}
