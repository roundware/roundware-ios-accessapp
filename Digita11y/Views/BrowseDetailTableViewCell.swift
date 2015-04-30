import UIKit

class BrowseDetailTableViewCell: UITableViewCell {
  static let Identifier = "BrowseDetailCellIdentifier"
  @IBOutlet weak var assetLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var timeProgressView: UIProgressView!

  func resetView() {
    self.playButton.setImage(UIImage(named:"browse-play-button"), forState: .Normal)
    self.timeProgressView.progress = 0.0
    self.accessibilityHint = "Plays audio"
    if let name = self.assetLabel.text {
      self.accessibilityLabel = String("\(name), audio")
    }
  }
}
