import UIKit
import RWFramework

class ContributeTableViewController: BaseTableViewController, RWFrameworkProtocol, UITextViewDelegate {

  enum Cell {
    case Artifact
    case Audio
    case AudioDrawer
    case Photo
    case PhotoDrawer
    case Text
    case TextDrawer
  }

  var cells = [Cell.Audio, Cell.Photo, Cell.Text]

  let CellIdentifier            = "ContributeCellIdentifier"
  let AudioDrawerCellIdentifier = "AudioDrawerCellIdentifier"
  let PhotoDrawerCellIdentifier = "PhotoDrawerCellIdentifier"
  let TextDrawerCellIdentifier  = "TextDrawerCellIdentifier"

  let RecordButtonFilename = "audio-record-button"
  let PlayButtonFilename   = "audio-play-button"
  let StopButtonFilename   = "audio-stop-button"

  let PhotoTextTag = 1
  let UploadTextTag = 2

  @IBOutlet weak var uploadButton: UIButton!

  var imagePath = ""
  var photoText = ""
  var uploadText = ""
  var haveImage = false

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 125.0

    self.uploadButton.layer.cornerRadius = 4.0

    var rwf = RWFramework.sharedInstance
    rwf.addDelegate(self)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.updateUploadButtonState()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let type = self.cells[indexPath.row]
    switch (type) {
    case .Artifact:
      return tableView.dequeueReusableCellWithIdentifier("ArtifactCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
    case .Audio:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.text = "Audio"
      cell.accessoryView = UIImageView(image: UIImage(named: "microphone"))
      cell.selectionStyle = .None
      cell.accessibilityHint = "Contribute an audio observation"
      return cell
    case .AudioDrawer:
      var cell =  tableView.dequeueReusableCellWithIdentifier(AudioDrawerCellIdentifier, forIndexPath: indexPath) as! AudioDrawerTableViewCell
      cell.recordButton.tag = indexPath.row
      cell.recordButton.addTarget(self, action: "recordAudio:", forControlEvents: .TouchUpInside)
      cell.discardButton.layer.cornerRadius = 2.0
      cell.discardButton.addTarget(self, action: "discardAudio", forControlEvents: .TouchUpInside)
      self.updateAudioCell(cell, toggleButton: false)
      return cell
    case .Photo:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.text = "Photos"
      cell.accessoryView = UIImageView(image: UIImage(named: "image"))
      cell.selectionStyle = .None
      cell.accessibilityHint = "Contribute a photo observation"
      return cell
    case .PhotoDrawer:
      var cell = tableView.dequeueReusableCellWithIdentifier(PhotoDrawerCellIdentifier, forIndexPath: indexPath) as! PhotoDrawerTableViewCell
      cell.textView.placeholder = "Describe this photo..."
      cell.textView.placeholderTextColor = UIColor.lightGrayColor()
      cell.textView.returnKeyType = .Done
      cell.textView.delegate = self
      cell.cameraButton.addTarget(self, action: "cameraButton", forControlEvents: .TouchUpInside)
      return cell
    case .Text:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.text = "Text"
      cell.accessoryView = UIImageView(image: UIImage(named: "text"))
      cell.selectionStyle = .None
      cell.accessibilityHint = "Contribute thoughts on observation"
      return cell
    case .TextDrawer:
      var cell = tableView.dequeueReusableCellWithIdentifier(TextDrawerCellIdentifier, forIndexPath: indexPath) as! TextDrawerTableViewCell
      cell.contributeTextView.placeholder = "Write something..."
      cell.contributeTextView.placeholderTextColor = UIColor.lightGrayColor()
      cell.contributeTextView.returnKeyType = .Done
      cell.contributeTextView.delegate = self
      return cell
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let type = self.cells[indexPath.row]

    switch (type) {
    case .Audio:
      toggleDrawer(Cell.AudioDrawer, parent: Cell.Audio)
    case .Photo:
      toggleDrawer(Cell.PhotoDrawer, parent: Cell.Photo)
    case .Text:
      toggleDrawer(Cell.TextDrawer, parent: Cell.Text)
    default:
      break
    }
  }

  func toggleDrawer(drawer: Cell, parent: Cell) {
    self.updateUploadButtonState()

    self.tableView.beginUpdates()

    var removed = false
    for (var i = 0; i < self.cells.count; ++i) {
      // Need to check before removing because the cell will dissapear
      if self.cells[i] == drawer {
        removed = true
      }

      switch self.cells[i] {
      case Cell.AudioDrawer, Cell.PhotoDrawer, Cell.TextDrawer:
        self.cells.removeAtIndex(i)
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
      default:
        break
      }
    }

    if removed {
      self.tableView.endUpdates()
      return
    }

    // Must be that we have to add the drawer
    for (var i = 0; i < self.cells.count; ++i) {
      if self.cells[i] == parent {
        self.cells.insert(drawer, atIndex: i+1)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i+1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        break
      }
    }

    self.tableView.endUpdates()
  }

  func findAudioDrawerTableViewCell() -> AudioDrawerTableViewCell? {
    for var i = 0; i < self.tableView.numberOfRowsInSection(0); ++i {
      var indexPath = NSIndexPath(forRow: i, inSection: 0)
      if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? AudioDrawerTableViewCell {
        return cell
      }
    }

    return nil
  }

  func findPhotoDrawerTableViewCell() -> PhotoDrawerTableViewCell? {
    for var i = 0; i < self.tableView.numberOfRowsInSection(0); ++i {
      var indexPath = NSIndexPath(forRow: i, inSection: 0)
      if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? PhotoDrawerTableViewCell {
        return cell
      }
    }

    return nil
  }

  func findTextDrawerTableViewCell() -> TextDrawerTableViewCell? {
    for var i = 0; i < self.tableView.numberOfRowsInSection(0); ++i {
      var indexPath = NSIndexPath(forRow: i, inSection: 0)
      if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TextDrawerTableViewCell {
        return cell
      }
    }

    return nil
  }

  // MARK: - Audio

  func updateAudioCell(cell: AudioDrawerTableViewCell, toggleButton: Bool) {

    var rwf = RWFramework.sharedInstance
    cell.discardButton.enabled = rwf.hasRecording()

    if rwf.isRecording() {
      if toggleButton {
        rwf.stopRecording()
      }
      cell.recordButton.accessibilityLabel = "Preview audio"
      cell.microphoneLevelsView.percent = 0.0
      cell.recordButton.setImage(UIImage(named: PlayButtonFilename), forState: .Normal)
    } else if rwf.isPlayingBack() {
      if toggleButton {
        rwf.stopPlayback()
      }
      cell.recordButton.accessibilityLabel = "Preview audio"
      cell.microphoneLevelsView.percent = 0.0
      cell.recordButton.setImage(UIImage(named: PlayButtonFilename), forState: .Normal)
    } else if rwf.hasRecording() {
      if toggleButton {
        rwf.startPlayback()
        cell.recordButton.accessibilityLabel = "Stop playback"
        cell.recordButton.setImage(UIImage(named: StopButtonFilename), forState: .Normal)
        cell.progressLabel.text = "00:00"
        cell.progressLabel.accessibilityLabel = "0 seconds"
      } else {
        cell.recordButton.accessibilityLabel = "Preview audio"
        cell.microphoneLevelsView.percent = 0.0
        cell.recordButton.setImage(UIImage(named: PlayButtonFilename), forState: .Normal)
      }
    } else {
      if toggleButton {
        rwf.startRecording()
        cell.recordButton.accessibilityLabel = "Stop recording"
        cell.recordButton.setImage(UIImage(named: self.StopButtonFilename), forState: .Normal)
        cell.progressLabel.text = "00:00"
        cell.progressLabel.accessibilityLabel = "0 seconds"
      }
    }

    self.updateUploadButtonState()
  }

  func recordAudio(button: UIButton) {
    if let cell = self.findAudioDrawerTableViewCell() {
      self.updateAudioCell(cell, toggleButton: true)
    }
  }

  func discardAudio() {
    var rwf = RWFramework.sharedInstance
    rwf.stopRecording()
    rwf.stopPlayback()
    rwf.deleteRecording()
    if let cell = self.findAudioDrawerTableViewCell() {
      cell.discardButton.enabled = false
      cell.recordButton.accessibilityLabel = "Record audio"
      cell.microphoneLevelsView.percent = 0.0
      cell.recordButton.setImage(UIImage(named: RecordButtonFilename), forState: .Normal)
      cell.progressLabel.text = "00:00"
      cell.progressLabel.accessibilityLabel = "0 seconds"
    }

    self.updateUploadButtonState()
  }

  func updateAudioPercentage(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
    if let cell = self.findAudioDrawerTableViewCell() {
      var dt = percentage*maxDuration
      var sec = Int(dt%60.0)
      var milli = Int(100*(dt - floor(dt)))
      var secStr = sec < 10 ? "0\(sec)" : "\(sec)"
      cell.progressLabel.text = "00:\(secStr)"
      cell.progressLabel.accessibilityLabel = "\(secStr) seconds"

      cell.microphoneLevelsView.percent = (averagePower + 120.0)/120.0
    }
  }

  // MARK: - RWFrameworkProtocol Image

  func cameraButton() {
    var rwf = RWFramework.sharedInstance
    rwf.doImage()
  }

  func rwImagePickerControllerDidFinishPickingMedia(info: [NSObject : AnyObject], path: String) {
    debugPrintln(info)
    self.imagePath = path

    for var i = 0; i < self.tableView.numberOfRowsInSection(0); ++i {
      var indexPath = NSIndexPath(forRow: i, inSection: 0)
      if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? PhotoDrawerTableViewCell {
        cell.textView.hidden = false
        cell.photoView.hidden = false
        self.haveImage = true

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
          cell.photoView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
          cell.photoView.image = image
        }
        self.updateUploadButtonState()
        return
      }
    }
  }

  // MARK: - RWFrameworkProtocol Audio

  func rwRecordingProgress(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
    self.updateAudioPercentage(percentage, maxDuration: maxDuration, peakPower: peakPower, averagePower: averagePower)
  }

  func rwPlayingBackProgress(percentage: Double, duration: NSTimeInterval, peakPower: Float, averagePower: Float) {
    self.updateAudioPercentage(percentage, maxDuration: duration, peakPower: peakPower, averagePower: averagePower)
  }

  func rwAudioRecorderDidFinishRecording() {
    var cell = self.findAudioDrawerTableViewCell()
    cell?.recordButton.accessibilityLabel = "Preview audio"
    cell?.microphoneLevelsView.percent = 0.0
    cell?.recordButton.setImage(UIImage(named: PlayButtonFilename), forState: .Normal)

    self.updateUploadButtonState()
  }

  func rwAudioPlayerDidFinishPlaying() {
    var cell = self.findAudioDrawerTableViewCell()
    cell?.recordButton.accessibilityLabel = "Preview audio"
    cell?.microphoneLevelsView.percent = 0.0
    cell?.recordButton.setImage(UIImage(named: PlayButtonFilename), forState: .Normal)
  }

  // MARK: - UITextViewDelegate

  func textViewDidChange(textView: UITextView) {
    debugPrintln(textView.text)
    if textView.tag == PhotoTextTag {
      self.photoText = textView.text
    } else {
      self.uploadText = textView.text
    }
  }

  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    // This is a complete hack, but some reason textViewShouldEnd isn't being called
    if contains(text, "\n") {
      textView.resignFirstResponder()
      return false
    }

    return true
  }

  func textViewDidEndEditing(textView: UITextView) {
    self.updateUploadButtonState()
  }

  // MARK: - Upload

  func updateUploadButtonState() {
    debugPrintln(" UPLOAD BUTTON STATE")
    var rwf = RWFramework.sharedInstance
    self.uploadButton.enabled = rwf.hasRecording() || self.haveImage || self.uploadText.isEmpty == false

    var recordingCount = rwf.hasRecording() ? 1 : 0
    var imageCount = self.haveImage ? 1 : 0
    if self.uploadText.isEmpty {
      self.uploadButton.accessibilityHint = "Upload \(recordingCount) audio and \(imageCount) images"
    } else {
      self.uploadButton.accessibilityHint = "Upload \(recordingCount) audio, and \(imageCount) images, and text"
    }
    debugPrintln(self.uploadButton.accessibilityHint)
  }

  @IBAction func uploadAllMedia(sender: AnyObject) {
    if let audio = self.findAudioDrawerTableViewCell() {
      audio.recordButton.accessibilityLabel = "Record audio"
      audio.microphoneLevelsView.percent = 0.0
      audio.recordButton.setImage(UIImage(named: "record-button"), forState: .Normal)
      audio.progressLabel.text = "00:00"
      audio.progressLabel.accessibilityLabel = "0 seconds"

      toggleDrawer(Cell.AudioDrawer, parent: Cell.Audio)
    }

    if let photo = self.findPhotoDrawerTableViewCell() {
      photo.textView.text = ""
      photo.textView.hidden = true
      photo.photoView.image = nil
      photo.photoView.hidden = true

      toggleDrawer(Cell.PhotoDrawer, parent: Cell.Photo)
    }

    if let txt = self.findTextDrawerTableViewCell() {
      toggleDrawer(Cell.TextDrawer, parent: Cell.Text)
    }

    var rwf = RWFramework.sharedInstance

    if self.imagePath.isEmpty == false && self.photoText.isEmpty == false {
      rwf.setImageDescription(self.imagePath, description: self.photoText)
      self.imagePath = ""
      self.photoText = ""
    }

    if self.uploadText.isEmpty == false {
      rwf.addText(self.uploadText)
      self.uploadText = ""
    }

    rwf.addRecording()
    rwf.uploadAllMedia()
    self.haveImage = false

    let alertController = UIAlertController(title: "Thank You", message: "Thank you for your contribution", preferredStyle: .Alert)
    let ok = UIAlertAction(title: "OK", style: .Default) { action in
      self.navigationController?.tabBarController?.selectedIndex = 0
    }
    alertController.addAction(ok)
    self.presentViewController(alertController, animated: true) { }
  }
}
