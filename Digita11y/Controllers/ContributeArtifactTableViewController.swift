import UIKit
import RWFramework

class ContributeArtifactTableViewController: BaseTableViewController, RWFrameworkProtocol {

  var selectedCells: Set<NSIndexPath> = Set<NSIndexPath>()

  func objectTags() -> TagGroup? {
    if let speakTags = self.rwData?.speakTags {
      for tag in speakTags {
        if tag.code == "object" {
          return tag
        }
      }
    }

    return nil
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if let tags = self.objectTags() {
      return tags.options.count
    }

    return 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ContributeArtifactCellIdentifier", forIndexPath: indexPath) as! UITableViewCell

    if let tags = self.objectTags() {
      var tag = tags.options[indexPath.row]
      cell.textLabel?.text = tag.value
    }

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
