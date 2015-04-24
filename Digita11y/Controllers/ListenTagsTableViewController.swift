import UIKit
import RWFramework

class ListenTagsTableViewController: BaseTableViewController {

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    RWFramework.sharedInstance.submitListenTags()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.rwData?.listenTags.count ?? 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = self.rwData?.listenTags[section].options.count ?? 0
    if self.rwData?.listenTags[section].code == "channel" {
      return count + 1
    }

    return count
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.rwData?.listenTags[section].headerText
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("ListenTagsCellIdentifier") as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ListenTagsCellIdentifier")
    }

    var rwf = RWFramework.sharedInstance
    let i = indexPath.row + 1
    var count = self.rwData?.listenTags[indexPath.section].options.count ?? 0
    if self.rwData?.listenTags[indexPath.section].code == "channel" {
      if self.rwData?.listenTags[indexPath.section].options.count == indexPath.row {
        cell?.textLabel?.text = "All Channels"

        if let tags = rwf.getListenTagsCurrent("channel") as! NSArray? {
          cell?.accessoryType = (tags.count == count) ? .Checkmark : .None
        }
      } else if let tag = self.rwData?.listenTags[indexPath.section].options[indexPath.row] {
        cell?.textLabel?.text = tag.value

        if let tags = rwf.getListenTagsCurrent("channel") as! NSArray? {
          if tags.count == count {
            cell?.accessoryType = .None
          } else {
            cell?.accessoryType = .None
            for tagID in tags {
              if let tagID = tagID as? Int {
                if tagID == tag.tagId {
                  cell?.accessoryType = .Checkmark
                  break
                }
              }
            }
          }
        }
      }

      ++count

    } else if let tag = self.rwData?.listenTags[indexPath.section].options[indexPath.row] {
      cell?.textLabel?.text = tag.value

      if let tags = rwf.getAllListenTagsCurrent() as! NSArray? {
        cell?.accessoryType = .None
        for tagID in tags {
          if let tagID = tagID as? Int {
            if tagID == tag.tagId {
              cell?.accessoryType = .Checkmark
              break
            }
          }
        }
      }
    }

    if let s1 = cell?.textLabel?.text {
      cell?.accessibilityLabel = String("\(s1), \(i) of \(count)")
    }
    cell?.accessibilityTraits = UIAccessibilityTraitButton

    return cell!
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    let rows = tableView.numberOfRowsInSection(indexPath.section)
    for var i = 0; i < rows; ++i {
      if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: indexPath.section)) {
        cell.accessoryType = .None
      }
    }

    var rwf = RWFramework.sharedInstance

    if self.rwData?.listenTags[indexPath.section].code == "channel" {
      if self.rwData?.listenTags[indexPath.section].options.count == indexPath.row {
        if let cell = tableView.cellForRowAtIndexPath(indexPath), group = self.rwData?.listenTags[indexPath.section] {
          cell.accessoryType = .Checkmark
          let tags = rwf.getListenTagsCurrent(group.code) as? [Int] ?? []
          rwf.setListenTagsCurrent("channel", value: tags)
          cell.selected = false
        }
      } else {
        if let cell = tableView.cellForRowAtIndexPath(indexPath), group = self.rwData?.listenTags[indexPath.section] {
          cell.accessoryType = .Checkmark
          let tag = group.options[indexPath.row]
          rwf.setListenTagsCurrent("channel", value: [tag.tagId])
          cell.selected = false
        }
      }
    } else if let group = self.rwData?.listenTags[indexPath.section],
                   cell = tableView.cellForRowAtIndexPath(indexPath) {
      if let tags = rwf.getListenTagsCurrent(group.code) as? [Int] {
        let tag = group.options[indexPath.row]
        cell.accessoryType = .Checkmark
        rwf.setListenTagsCurrent(group.code, value: [tag.tagId])
      }
      cell.selected = false
    }
  }
}
