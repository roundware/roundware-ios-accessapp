//
//  ContributeTableViewController.swift
//  Digita11y
//
//  Created by Parveen Kaler on 2015-02-24.
//  Copyright (c) 2015 Roundware. All rights reserved.
//

import UIKit

class ContributeTableViewController: UITableViewController {

  let CellIdentifier = "ContributeCellIdentifier"
  let AudioDrawerCellIdentifier = "AudioDrawerCellIdentifier"

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
      return 4
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    var cell: UITableViewCell?  // This can be a let in Xcode 6.3

    if indexPath.row == 1 {
      cell = tableView.dequeueReusableCellWithIdentifier(AudioDrawerCellIdentifier, forIndexPath: indexPath) as? UITableViewCell
    }
    else {
      cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell?
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
    }

    return cell!
  }
}
