import UIKit
import RWFramework

class ContributeArtifactTableViewController: BaseTableViewController, RWFrameworkProtocol {

  var speakTags = [TagGroup]()

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.speakTags = self.rwData?.speakTags.filter { $0.code != "exhibition" } ?? []
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.speakTags.count ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.speakTags[section].options.count ?? 0
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.speakTags[section].headerText
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ContributeArtifactCellIdentifier")
    let tag = self.speakTags[indexPath.section].options[indexPath.row]
    cell.textLabel?.text = tag.value
    let i = indexPath.row + 1
    let count = self.speakTags[indexPath.section].options.count ?? 0
    cell.accessibilityLabel = String("\(tag.value), \(i) of \(count)")
    cell.accessibilityTraits = UIAccessibilityTraitButton
    cell.accessoryType = self.rwData?.selectedSpeakTags[indexPath.section] == indexPath.row ? .Checkmark : .None
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = self.rwData?.selectedSpeakTags[indexPath.section] ?? 0
    if row != -1 {
      let oldIndexPath = NSIndexPath(forRow: row, inSection: indexPath.section)
      let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
      oldCell?.accessoryType = .None
    }

    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark
    self.rwData?.selectedSpeakTags[indexPath.section] = indexPath.row
    cell?.selected = false
  }
}
