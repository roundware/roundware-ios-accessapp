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

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 125.0

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
    default:
      let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! BrowseDetailTableViewCell
      cell.artifactImageView.layer.cornerRadius = 32.0
      cell.artifactImageView.layer.masksToBounds = true
      cell.assetLabel.text = assets[indexPath.row].assetDescription
      return cell
    }
  }
}
