import UIKit
import RWFramework

class ContributeArtifactTableViewController: BaseTableViewController, RWFrameworkProtocol {

  var selectedCells: Set<NSIndexPath> = Set<NSIndexPath>()

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.rwData?.speakTags.count ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.rwData?.speakTags[section].options.count ?? 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ContributeArtifactCellIdentifier")
    if let tag = self.rwData?.speakTags[indexPath.section].options[indexPath.row] {
      cell.textLabel?.text = tag.value
    }
    cell.accessoryType = selectedCells.contains(indexPath) ? .Checkmark : .None
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    if selectedCells.contains(indexPath) == true {
      selectedCells.remove(indexPath)
      cell?.accessoryType = .None
    } else {
      selectedCells.insert(indexPath)
      cell?.accessoryType = .Checkmark
    }
  }
}
