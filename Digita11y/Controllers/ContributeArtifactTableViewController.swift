import UIKit
import RWFramework

class ContributeArtifactTableViewController: BaseTableViewController, RWFrameworkProtocol {

  let things = ["One", "Two", "Three"]

  var selectedCells: Set<NSIndexPath> = Set<NSIndexPath>()

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return things.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ContributeArtifactCellIdentifier")
    cell.textLabel?.text = things[indexPath.row]
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
