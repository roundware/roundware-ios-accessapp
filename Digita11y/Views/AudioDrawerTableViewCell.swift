import UIKit

class AudioDrawerTableViewCell: UITableViewCell {

  static let Identifier = "AudioDrawerCellIdentifier"


  let RecordButtonFilename = "audio-record-button"
  let PlayButtonFilename   = "audio-play-button"
  let StopButtonFilename   = "audio-stop-button"

  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var discardButton: UIButton!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!

  override func awakeFromNib() {
    super.awakeFromNib()
    recordButton.layer.cornerRadius = 4.0
    discardButton.layer.cornerRadius = 4.0
  }

  func displayPreviewAudio() {
    recordButton.accessibilityLabel = "Preview audio"
    progressView.progress = 0.0
    recordButton.setImage(UIImage(named: PlayButtonFilename), forState: .Normal)
  }

  func displayStopPlayback() {
    recordButton.accessibilityLabel = "Stop playback"
    recordButton.setImage(UIImage(named: StopButtonFilename), forState: .Normal)
    progressLabel.text = "00:00"
    progressLabel.accessibilityLabel = "0 seconds"
  }

  func displayStopRecording() {
    recordButton.accessibilityLabel = "Stop recording"
    recordButton.setImage(UIImage(named: self.StopButtonFilename), forState: .Normal)
    progressLabel.text = "00:30"
    progressLabel.accessibilityLabel = "0 seconds"
  }

  func displayRecordAudio() {
    recordButton.accessibilityLabel = "Record audio"
    progressView.progress = 0.0
    recordButton.setImage(UIImage(named: "record-button"), forState: .Normal)
    progressLabel.text = "00:30"
    progressLabel.accessibilityLabel = "0 seconds"
  }

  func updateAudioPercentage(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
    var dt = maxDuration - (percentage*maxDuration) // countdown
    var sec = Int(dt%60.0)
    var milli = Int(100*(dt - floor(dt)))
    var secStr = sec < 10 ? "0\(sec)" : "\(sec)"
    progressLabel.text = "00:\(secStr)"
    progressLabel.accessibilityLabel = "\(secStr) seconds"

    progressView.progress = Float(percentage)
  }
}
