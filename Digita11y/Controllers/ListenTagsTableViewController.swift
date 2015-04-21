import UIKit
import RWFramework

class ListenTagsTableViewController: BaseTableViewController {

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    var rwf = RWFramework.sharedInstance
    rwf.submitListenTags()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.rwData?.listenTags.count ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.rwData?.listenTags[section].options.count ?? 0
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.rwData?.listenTags[section].headerText
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ListenTagsCellIdentifier")
    if let tag = self.rwData?.listenTags[indexPath.section].options[indexPath.row] {
      cell.textLabel?.text = tag.value

      var rwf = RWFramework.sharedInstance
      if let tags = rwf.getAllListenTagsCurrent() as! NSArray? {
        cell.accessoryType = .None
        for tagID in tags {
          if let tagID = tagID as? Int {
            if tagID == tag.tagId {
              cell.accessoryType = .Checkmark
              break
            }
          }
        }
      }
    }

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let group = self.rwData?.listenTags[indexPath.section],
            cell = tableView.cellForRowAtIndexPath(indexPath) {
      var rwf = RWFramework.sharedInstance
      if let tags = rwf.getListenTagsCurrent(group.code) as? [Int] {
        let tag = group.options[indexPath.row]
        var newTags = tags.filter { $0 == tag.tagId }
        if count(tags) != count(newTags) {
          cell.accessoryType = .None
        } else {
          cell.accessoryType = .Checkmark
        }
        rwf.setListenTagsCurrent(group.code, value: newTags)
      }
      cell.selected = false
    }
  }
}
