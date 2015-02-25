//
//  BrowseTableViewController.swift
//  Digita11y
//
//  Created by Parveen Kaler on 2015-02-23.
//  Copyright (c) 2015 Roundware. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController {

  let CellIdentifier = "BrowseCellIdentifier"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 125.0
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 10
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as? BrowseTableViewCell {
      return cell
    }

    return UITableViewCell()
  }


  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  }
}
