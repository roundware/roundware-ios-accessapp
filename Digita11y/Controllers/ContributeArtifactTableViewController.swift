import UIKit
import RWFramework

class ContributeArtifactTableViewController: BaseTableViewController, RWFrameworkProtocol {

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.rwData?.speakTags.count ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.rwData?.speakTags[section].options.count ?? 0
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.rwData?.speakTags[section].headerText
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ContributeArtifactCellIdentifier")
    if let tag = self.rwData?.speakTags[indexPath.section].options[indexPath.row] {
      cell.textLabel?.text = tag.value
    }
    cell.accessoryType = self.rwData?.selectedSpeakTags[indexPath.section] == indexPath.row ? .Checkmark : .None
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = self.rwData?.selectedSpeakTags[indexPath.section] ?? 0
    let oldIndexPath = NSIndexPath(forRow: row, inSection: indexPath.section)
    let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
    oldCell?.accessoryType = .None

    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark
    self.rwData?.selectedSpeakTags[indexPath.section] = indexPath.row
    cell?.selected = false
  }
}
