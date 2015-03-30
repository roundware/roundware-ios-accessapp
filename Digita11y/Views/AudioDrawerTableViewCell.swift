import UIKit

class AudioDrawerTableViewCell: UITableViewCell {
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var uploadButton: UIButton!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var microphoneLevelsView: MicrophoneLevelsView!
}
