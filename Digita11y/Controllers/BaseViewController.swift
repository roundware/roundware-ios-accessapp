import UIKit

class BaseViewController: UIViewController {
  var rwData: RWData?

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let to = segue.destinationViewController as? BaseViewController {
      to.rwData = self.rwData
    }
  }
}

class BaseTableViewController: UITableViewController {
  var rwData: RWData?

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let to = segue.destinationViewController as? BaseViewController {
      to.rwData = self.rwData
    }
  }
}