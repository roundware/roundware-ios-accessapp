//
//  ContributeTableViewController.swift
//  Digita11y
//
//  Created by Parveen Kaler on 2015-02-24.
//  Copyright (c) 2015 Roundware. All rights reserved.
//

import UIKit

class ContributeTableViewController: UITableViewController {

  enum Cell {
    case Audio
    case AudioDrawer
    case Photo
    case PhotoDrawer
    case Text
    case TextDrawer
  }

  var cells = [Cell.Audio, Cell.Photo, Cell.Text]

  let CellIdentifier = "ContributeCellIdentifier"
  let AudioDrawerCellIdentifier = "AudioDrawerCellIdentifier"
  let PhotoDrawerCellIdentifier = "PhotoDrawerCellIdentifier"
  let TextDrawerCellIdentifier = "TextDrawerCellIdentifier"

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
    return cells.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let type = self.cells[indexPath.row]
    switch (type) {
    case .Audio:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
      cell.textLabel?.text = "Add Audio"
      return cell
    case .AudioDrawer:
      return tableView.dequeueReusableCellWithIdentifier(AudioDrawerCellIdentifier, forIndexPath: indexPath) as UITableViewCell
    case .Photo:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
      cell.textLabel?.text = "Add Photos"
      return cell
    case .PhotoDrawer:
      return tableView.dequeueReusableCellWithIdentifier(PhotoDrawerCellIdentifier, forIndexPath: indexPath) as UITableViewCell
    case .Text:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
      cell.textLabel?.text = "Add Text"
      return cell
    case .TextDrawer:
      var cell = tableView.dequeueReusableCellWithIdentifier(TextDrawerCellIdentifier, forIndexPath: indexPath) as TextDrawerTableViewCell
      cell.textView.placeholder = "Write something..."
      cell.textView.placeholderTextColor = UIColor.lightGrayColor()
      return cell
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let type = self.cells[indexPath.row]
    switch (type) {
    case .Audio:
      toggleDrawer(Cell.AudioDrawer, parent: Cell.Audio)
    case .Photo:
      toggleDrawer(Cell.PhotoDrawer, parent: Cell.Photo)
    case .Text:
      toggleDrawer(Cell.TextDrawer, parent: Cell.Text)
    default:
      break
    }
  }

  func toggleDrawer(drawer: Cell, parent: Cell) {
    // Remove drawer?
    for (var i = 0; i < self.cells.count; ++i) {
      if self.cells[i] == drawer {
        self.cells.removeAtIndex(i)
        self.tableView.reloadData()
        return
      }
    }
    // Must be that we have to add the drawer
    for (var i = 0; i < self.cells.count; ++i) {
      if self.cells[i] == parent {
        self.cells.insert(drawer, atIndex: i+1)
        self.tableView.reloadData()
        return
      }
    }
  }
}
