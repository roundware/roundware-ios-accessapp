import UIKit
import RWFramework

class BrowseTableViewController: BaseTableViewController, RWFrameworkProtocol {

  let CellIdentifier = "BrowseCellIdentifier"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 125.0
    tableView.tableFooterView = UIView(frame: CGRectZero)

    var rwf = RWFramework.sharedInstance
    rwf.addDelegate(self)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.rwData?.exhibitions.count ?? 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as? BrowseTableViewCell {
      cell.titleLabel.text = self.rwData?.exhibitions[indexPath.row].value
      return cell
    }

    return UITableViewCell()
  }


  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  }

  func rwGetProjectsIdTagsSuccess(data: NSData?) {
    self.tableView.reloadData()
  }
}
