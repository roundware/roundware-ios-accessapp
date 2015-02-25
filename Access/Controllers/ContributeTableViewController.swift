//
//  ContributeTableViewController.swift
//  Access
//
//  Created by Parveen Kaler on 2015-02-24.
//  Copyright (c) 2015 Roundware. All rights reserved.
//

import UIKit

class ContributeTableViewController: UITableViewController {

  let CellIdentifier = "ContributeCellIdentifier"

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.rowHeight = 44.0
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 3
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell?
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
    }

    if indexPath.row == 0 {
      cell?.textLabel?.text = "Add Audio"
    } else if indexPath.row == 1 {
      cell?.textLabel?.text = "Add Photos"
    } else {
      cell?.textLabel?.text = "Add Text"
    }

    return cell!
  }
}
