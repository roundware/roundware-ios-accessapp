import UIKit

class BaseViewController: UITableViewController {
  var rwData: RWData?

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let to = segue.destinationViewController as? BaseViewController {
      to.rwData = self.rwData
    }
  }
}
