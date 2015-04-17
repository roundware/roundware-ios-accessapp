import UIKit
import RWFramework

class BrowseTableViewController: BaseTableViewController, RWFrameworkProtocol {

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 125.0
    tableView.tableFooterView = UIView(frame: CGRectZero)

    RWFramework.sharedInstance.addDelegate(self)
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
    if let cell = tableView.dequeueReusableCellWithIdentifier(BrowseTableViewCell.Identifier, forIndexPath: indexPath) as? BrowseTableViewCell {
      cell.tag = self.rwData?.exhibitions[indexPath.row].tagId ?? 0
      var name = self.rwData?.exhibitions[indexPath.row].value
      cell.titleLabel.text = name
      cell.accessibilityLabel = name
      if let urlString = self.rwData?.exhibitions[indexPath.row].headerImageURL {
        cell.bannerImageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named:"browse-cell"))
      }
      return cell
    }

    return UITableViewCell()
  }


  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)

    if segue.identifier == "BrowseDetailSegue" {
      if let to = segue.destinationViewController as? BrowseDetailTableViewController {
        if let cell = sender as? UITableViewCell {
          to.tagID = cell.tag
        }
      }
    }
  }

  // MARK: - RWFrameworkProtocol

  func rwGetProjectsIdTagsSuccess(data: NSData?) {
    // Order or operations thing.  RootTabBarController parses exhibitions
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.tableView.reloadData()
    }
  }
}
