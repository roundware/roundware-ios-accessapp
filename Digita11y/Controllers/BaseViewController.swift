import UIKit

class BaseViewController: UIViewController {
  var rwData: RWData?

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let to = segue.destinationViewController as? BaseViewController {
      to.rwData = self.rwData
    } else if let to = segue.destinationViewController as? BaseTableViewController {
      to.rwData = self.rwData
    }
  }
}

class BaseTableViewController: UITableViewController {
  var rwData: RWData?

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let to = segue.destinationViewController as? BaseViewController {
      to.rwData = self.rwData
    } else if let to = segue.destinationViewController as? BaseTableViewController {
      to.rwData = self.rwData
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