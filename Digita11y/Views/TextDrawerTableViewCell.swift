import UIKit

class TextDrawerTableViewCell: UITableViewCell {

  static let Identifier  = "TextDrawerCellIdentifier"

  @IBOutlet weak var contributeTextView: SZTextView!

  override func awakeFromNib() {
    super.awakeFromNib()

    contributeTextView.placeholder = "Write something..."
    contributeTextView.placeholderTextColor = UIColor.lightGrayColor()
    contributeTextView.returnKeyType = .Done
  }
}
