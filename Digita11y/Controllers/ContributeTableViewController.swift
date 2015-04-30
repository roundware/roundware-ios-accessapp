import UIKit
import RWFramework

class ContributeTableViewController: BaseTableViewController, RWFrameworkProtocol, UITextViewDelegate {

  enum Cell {
    case Artifact
    case Audio
    case AudioDrawer
    case Photo
    case PhotoText
    case PhotoDrawer
    case Text
    case TextDrawer
  }

  var cells = [Cell.Artifact, Cell.Audio, Cell.Photo, Cell.Text]

  let CellIdentifier            = "ContributeCellIdentifier"
  let ArtifactCellIdentifier    = "ArtifactCellIdentifier"

  let UploadTextTag = 999

  @IBOutlet weak var uploadButton: UIButton!

  struct Image {
    var path: String
    var text: String
    var image: UIImage?
  }

  var images: [Image] = []
  var uploadText = ""

  // MARK: - View lifecycle

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 125.0

    self.uploadButton.layer.cornerRadius = 4.0

    RWFramework.sharedInstance.addDelegate(self)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("globalAudioStarted:"), name: "RW_STARTED_AUDIO_NOTIFICATION", object: nil)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.tableView.reloadData()
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
      var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ArtifactCellIdentifier)
      cell.textLabel?.text = "Choose Tags:"
      cell.accessoryType = .DisclosureIndicator
      cell.accessibilityHint = "Select an object"

      var str = ""
      for var i = 0; i < self.rwData?.speakTags.count; ++i {
        if self.rwData?.selectedSpeakTags[i] != -1 {
          if let index = self.rwData?.selectedSpeakTags[i] {
            let tag = self.rwData?.speakTags[i].options[index]
            if let s1 = tag?.value {
              str += String("\(s1) ")
            }
          }
        }
      }
      cell.detailTextLabel?.text = str

      return cell
    case .Audio:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.text = "Audio"
      cell.accessoryView = UIImageView(image: UIImage(named: "microphone"))
      cell.selectionStyle = .None
      cell.accessibilityHint = "Contribute an audio observation"
      return cell
    case .AudioDrawer:
      var cell =  tableView.dequeueReusableCellWithIdentifier(AudioDrawerTableViewCell.Identifier, forIndexPath: indexPath) as! AudioDrawerTableViewCell
      cell.recordButton.tag = indexPath.row
      cell.recordButton.addTarget(self, action: "recordAudio:", forControlEvents: .TouchUpInside)
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
    case .PhotoText:
      var cell = tableView.dequeueReusableCellWithIdentifier(PhotoTextTableViewCell.Identifier, forIndexPath: indexPath) as! PhotoTextTableViewCell

      var tag = 0
      for (index, cell) in enumerate(self.cells) {
        if index == indexPath.row {
          break
        }
        if cell == .PhotoText {
          ++tag
        }
      }

      cell.artifactTextView.tag = tag
      let num = tag+1
      cell.artifactTextView.accessibilityLabel = String("Image \(num) description")
      let image = self.images[tag]
      cell.artifactTextView.text = image.text
      cell.artifactTextView.delegate = self

      cell.artifactImageView.image = image.image
      cell.artifactImageView.accessibilityLabel = String("Image \(num)")

      cell.discardButton.tag = tag
      cell.discardButton.accessibilityLabel = String("Discard image \(num)")
      cell.discardButton.addTarget(self, action: "discardPhoto:", forControlEvents: .TouchUpInside)
      return cell
    case .PhotoDrawer:
      var cell = tableView.dequeueReusableCellWithIdentifier(PhotoDrawerTableViewCell.Identifier, forIndexPath: indexPath) as! PhotoDrawerTableViewCell
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
      var cell = tableView.dequeueReusableCellWithIdentifier(TextDrawerTableViewCell.Identifier, forIndexPath: indexPath) as! TextDrawerTableViewCell
      cell.contributeTextView.delegate = self
      cell.contributeTextView.text = self.uploadText
      return cell
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let type = self.cells[indexPath.row]

    switch (type) {
    case .Artifact:
      var vc = ContributeArtifactTableViewController(style: .Grouped)
      vc.rwData = self.rwData
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
      break
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
    // Step 1: remove tableviewcell
    for (var i = 0; i < self.cells.count; ++i) {
      // Need to check before removing because the cell will dissapear
      if self.cells[i] == drawer {
        removed = true
      }

      switch self.cells[i] {
      case .AudioDrawer, .PhotoText, .PhotoDrawer, .TextDrawer:
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
      default:
        break
      }
    }

    // Step 2: update the backing data
    for (var i = 0; i < self.cells.count; ++i) {
      switch self.cells[i] {
      case .AudioDrawer, .PhotoText, .PhotoDrawer, .TextDrawer:
        self.cells.removeAtIndex(i)
        i = 0 // start again because removeAtIndex invalidates iterator
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

        if parent == .Photo {
          var index = i+1
          for image in self.images {
            self.cells.insert(Cell.PhotoText, atIndex: index)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
            ++index
          }
          self.cells.insert(drawer, atIndex: index)
          self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        } else {
          self.cells.insert(drawer, atIndex: i+1)
          self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i+1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        }

        break
      }
    }

    self.tableView.endUpdates()
  }

  func findTableViewCell<T>() -> T? {
    for var i = 0; i < self.tableView.numberOfRowsInSection(0); ++i {
      var indexPath = NSIndexPath(forRow: i, inSection: 0)
      if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? T {
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
        delay(0.5) {  // HACK: Let the buffers in the framework flush.
          rwf.stopRecording()
        }
      }
      cell.displayPreviewAudio()
    } else if rwf.isPlayingBack() {
      if toggleButton {
        rwf.stopPlayback()
      }
      cell.displayPreviewAudio()
    } else if rwf.hasRecording() {
      if toggleButton {
        rwf.startPlayback()
        NSNotificationCenter.defaultCenter().postNotificationName("RW_STARTED_AUDIO_NOTIFICATION", object: self)
        cell.displayStopPlayback()
      } else {
        cell.displayPreviewAudio()
      }
    } else {
      if toggleButton {
        rwf.startRecording()
        NSNotificationCenter.defaultCenter().postNotificationName("RW_STARTED_AUDIO_NOTIFICATION", object: self)
        cell.displayStopRecording()
      } else {
        cell.displayRecordAudio()
      }
    }

    self.updateUploadButtonState()
  }

  func recordAudio(button: UIButton) {
    if let cell = self.findTableViewCell() as AudioDrawerTableViewCell? {
      self.updateAudioCell(cell, toggleButton: true)
    }
  }

  func discardAudio() {
    var rwf = RWFramework.sharedInstance
    rwf.stopRecording()
    rwf.stopPlayback()
    rwf.deleteRecording()
    if let cell = self.findTableViewCell() as AudioDrawerTableViewCell? {
      cell.discardButton.enabled = false
      cell.displayRecordAudio()
    }

    self.updateUploadButtonState()
  }

  func updateAudioPercentage(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
    if let cell = self.findTableViewCell() as AudioDrawerTableViewCell? {
      cell.updateAudioPercentage(percentage, maxDuration: maxDuration, peakPower: peakPower, averagePower: averagePower)
    }
  }

  // MARK: - RWFrameworkProtocol Image

  func cameraButton() {
    RWFramework.sharedInstance.doImage()
  }

  func discardPhoto(button: UIButton) {
    if let index = find(self.cells, Cell.PhotoText) {
      self.cells.removeAtIndex(index+button.tag)
      self.images.removeAtIndex(button.tag)
      self.updateUploadButtonState()
      self.tableView.reloadData()
    }
  }

  func rwImagePickerControllerDidFinishPickingMedia(info: [NSObject : AnyObject], path: String) {
    var img = info[UIImagePickerControllerEditedImage] as? UIImage
    if img == nil {
      img = info[UIImagePickerControllerOriginalImage] as? UIImage
    }

    let image = Image(path: path, text: "", image: img)
    self.images.append(image)

    if let index = find(self.cells, Cell.Photo) {
      self.cells.insert(Cell.PhotoText, atIndex: index+1)
    }
    self.updateUploadButtonState()
    self.tableView.reloadData()
  }

  // MARK: - RWFrameworkProtocol Audio

  func rwRecordingProgress(percentage: Double, maxDuration: NSTimeInterval, peakPower: Float, averagePower: Float) {
    self.updateAudioPercentage(percentage, maxDuration: maxDuration, peakPower: peakPower, averagePower: averagePower)
  }

  func rwPlayingBackProgress(percentage: Double, duration: NSTimeInterval, peakPower: Float, averagePower: Float) {
    self.updateAudioPercentage(percentage, maxDuration: duration, peakPower: peakPower, averagePower: averagePower)
  }

  func rwAudioRecorderDidFinishRecording() {
    let cell: AudioDrawerTableViewCell? = self.findTableViewCell()
    cell?.displayPreviewAudio()
    self.updateUploadButtonState()
  }

  func globalAudioStarted(note: NSNotification) {
    if let sender = note.object as? ContributeTableViewController {
      if sender == self {
        return
      }
    }

    var rwf = RWFramework.sharedInstance
    rwf.stopPlayback()
    rwf.stopRecording()
    if let cell = self.findTableViewCell() as AudioDrawerTableViewCell? {
      self.updateAudioCell(cell, toggleButton: false)
    }
  }

  func rwAudioPlayerDidFinishPlaying() {
    let cell: AudioDrawerTableViewCell? = self.findTableViewCell()
    cell?.displayPreviewAudio()
  }

  // MARK: - UITextViewDelegate

  func textViewDidChange(textView: UITextView) {
    if textView.tag == UploadTextTag {
      self.uploadText = textView.text
    } else {
      var image = self.images[textView.tag]
      image.text = textView.text
      self.images[textView.tag] = image
    }

    // Toggling updates forces the tableview to recalculate cell size
    self.tableView.beginUpdates()
    self.tableView.endUpdates()
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
    var rwf = RWFramework.sharedInstance
    self.uploadButton.enabled = rwf.hasRecording() || self.images.isEmpty == false || self.uploadText.isEmpty == false

    var recordingCount = rwf.hasRecording() ? 1 : 0
    var imageCount = self.images.count
    if self.uploadText.isEmpty {
      self.uploadButton.accessibilityHint = "Upload \(recordingCount) audio and \(imageCount) images"
    } else {
      self.uploadButton.accessibilityHint = "Upload \(recordingCount) audio, and \(imageCount) images, and text"
    }
  }

  @IBAction func uploadAllMedia(sender: AnyObject) {
    if let audio = self.findTableViewCell() as AudioDrawerTableViewCell? {
      audio.displayRecordAudio()
      toggleDrawer(Cell.AudioDrawer, parent: Cell.Audio)
    }

    if let photo = self.findTableViewCell() as PhotoDrawerTableViewCell? {
      toggleDrawer(Cell.PhotoDrawer, parent: Cell.Photo)
    }

    if let txt = self.findTableViewCell() as TextDrawerTableViewCell? {
      toggleDrawer(Cell.TextDrawer, parent: Cell.Text)
    }

    var rwf = RWFramework.sharedInstance

    for image in self.images {
      rwf.setImageDescription(image.path, description: image.text)
    }
    self.images.removeAll()

    if self.uploadText.isEmpty == false {
      rwf.addText(self.uploadText)
      self.uploadText = ""
    }

    rwf.addRecording()

    for var i = 0; i < self.rwData?.speakTags.count; ++i {
      if let group = self.rwData?.speakTags[i] {
        if let index = self.rwData?.selectedSpeakTags[i] {
          if index != -1 {
            let tag = group.options[index]
            rwf.setSpeakTagsCurrent(group.code, value: [tag.tagId])
          }
        }
      }
    }

    rwf.uploadAllMedia()

    let alertController = UIAlertController(title: "Thank You", message: "Thank you for your contribution", preferredStyle: .Alert)
    let ok = UIAlertAction(title: "OK", style: .Default) { action in
      self.cells = [Cell.Artifact, Cell.Audio, Cell.Photo, Cell.Text]
      self.rwData?.resetSelectedSpeakTags()
      self.tableView.reloadData()
      self.navigationController?.tabBarController?.selectedIndex = 0
    }
    alertController.addAction(ok)
    self.presentViewController(alertController, animated: true) { }
  }

  // MARK: - Magic tap

  override func accessibilityPerformMagicTap() -> Bool {
    debugPrintln("ACCESSIBILITY PERFORM MAGIC TAP - CONTRIBUTE")
    var rwf = RWFramework.sharedInstance
    if rwf.isRecording() {
      let cell: AudioDrawerTableViewCell? = findTableViewCell()
      cell?.discardButton.enabled = rwf.hasRecording()

      delay(0.5) {  // HACK: Let the buffers in the framework flush.
        rwf.stopRecording()
      }
      cell?.displayPreviewAudio()

      return true
    }

    return false
  }

  func rwUpdateStatus(message: String) {}
}
