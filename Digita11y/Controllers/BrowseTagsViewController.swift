import UIKit

class BrowseTagsViewController: BaseTableViewController {

  let CellIdentifier = "BrowseTagsCellIdentifier"
  var assetViewModel: AssetViewModel?
  var filterCompleted: ((AssetViewModel?)->())?

  // MARK: - View lifecycle
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)

    self.assetViewModel?.filterAssetsWithTags()

    if let f = filterCompleted {
      f(self.assetViewModel)
    }
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.assetViewModel?.numberOfTagGroups() ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.assetViewModel?.numberOfTagsForGroup(section) ?? 0
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.assetViewModel?.titleOfTagGroup(section)
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
    }

    cell?.textLabel?.text = assetViewModel?.titleForTagAtIndex(indexPath.row, forGroup: indexPath.section)
    cell?.accessibilityLabel = assetViewModel?.accessibiltyLabelTextAtIndex(indexPath.row, forGroup: indexPath.section)
    cell?.accessoryType = assetViewModel?.accessoryTypeAtIndex(indexPath.row, forGroup: indexPath.section) ?? .None
    cell?.accessibilityTraits = UIAccessibilityTraitButton
    return cell!
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    deselectAllCellInSection(indexPath.section)

    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      assetViewModel?.selectTagAtIndex(indexPath.row, forGroup: indexPath.section)
      cell.accessoryType = .Checkmark
      cell.selected = false
    }
  }
}
