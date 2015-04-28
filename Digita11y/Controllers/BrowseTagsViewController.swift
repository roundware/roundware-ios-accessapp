import UIKit

class BrowseTagsViewController: BaseTableViewController {

  let CellIdentifier = "BrowseTagsCellIdentifier"
  var assetViewModel: AssetViewModel?
  var filterCompleted: ((AssetViewModel?)->())?

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)

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

  // MARK: - Utility

  func deselectAllCellInSection(section: Int) {
    let rows = tableView.numberOfRowsInSection(section)
    for var i = 0; i < rows; ++i {
      if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: section)) {
        cell.accessoryType = .None
      }
    }
  }
}
