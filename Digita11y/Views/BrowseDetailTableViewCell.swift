import UIKit

class BrowseDetailTableViewCell: UITableViewCell {
  static let Identifier = "BrowseDetailCellIdentifier"
  @IBOutlet weak var assetLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var timeProgressView: UIProgressView!
}
