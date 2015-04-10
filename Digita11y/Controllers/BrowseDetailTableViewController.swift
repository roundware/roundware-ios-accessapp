import UIKit

class BrowseDetailTableViewController: BaseTableViewController {

  let CellIdentifier = "BrowseDetailCellIdentifier"
  var tagID = 0
  var currentTag: Tag?
  var assets: [Asset] = []

  @IBOutlet weak var segmentedControl: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.automaticallyAdjustsScrollViewInsets = false

    tableView.rowHeight = 94
    tableView.estimatedRowHeight = 94

    if let v = self.segmentedControl.subviews[0] as? UIView {
      v.accessibilityHint = "Filters by artifact"
    }
    if let v = self.segmentedControl.subviews[1] as? UIView {
      v.accessibilityHint = "Filters by contributor"
    }
    if let v = self.segmentedControl.subviews[2] as? UIView {
      v.accessibilityHint = "Filters by medium"
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true
    self.navigationController?.view.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

    currentTag = self.rwData?.exhibitions.filter { $0.tagId == self.tagID }.first
    self.navigationItem.title = currentTag?.value

    assets = self.rwData?.assets.filter { contains($0.tagIDs, self.tagID) } ?? []

    self.navigationController?.navigationBar.becomeFirstResponder()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return assets.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let asset = assets[indexPath.row]
    switch (asset.mediaType) {
    case .Text:
      let cell = tableView.dequeueReusableCellWithIdentifier("BrowseTextTableViewCellIdentifier", forIndexPath: indexPath) as! BrowseTextTableViewCell
      cell.descriptionTextView.text = asset.fileURL.absoluteString
      return cell
    case .Audio:
      let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! BrowseDetailTableViewCell
      cell.assetLabel.text = asset.assetDescription.isEmpty ? "Telescope M-53 Audio 1" : asset.assetDescription
      cell.playButton.addTarget(self, action: "playAudio:", forControlEvents: .TouchUpInside)
      cell.playButton.tag = indexPath.row
      return cell
    default:
      let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! BrowseDetailTableViewCell
      cell.assetLabel.text = asset.assetDescription.isEmpty ? "Telescope M-53 Audio 1" : asset.assetDescription
      return cell
    }
  }

  func playAudio(button: UIButton) {
    var asset = assets[button.tag]
    debugPrintln(asset.fileURL.absoluteString)
  }
}
