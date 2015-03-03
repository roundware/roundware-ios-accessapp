//
//  ContributeTableViewController.swift
//  Digita11y
//
//  Created by Parveen Kaler on 2015-02-24.
//  Copyright (c) 2015 Smartful Studios Inc. All rights reserved.
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
      cell.textLabel?.text = "Audio"
      cell.accessoryView = UIImageView(image: UIImage(named: "microphone"))
      cell.selectionStyle = .None
      return cell
    case .AudioDrawer:
      return tableView.dequeueReusableCellWithIdentifier(AudioDrawerCellIdentifier, forIndexPath: indexPath) as UITableViewCell
    case .Photo:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.text = "Photos"
      cell.accessoryView = UIImageView(image: UIImage(named: "image"))
      cell.selectionStyle = .None
      return cell
    case .PhotoDrawer:
      var cell = tableView.dequeueReusableCellWithIdentifier(PhotoDrawerCellIdentifier, forIndexPath: indexPath) as PhotoDrawerTableViewCell
      cell.textView.placeholder = "Describe this photo..."
      cell.textView.placeholderTextColor = UIColor.lightGrayColor()
      return cell
    case .Text:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.text = "Text"
      cell.accessoryView = UIImageView(image: UIImage(named: "text"))
      cell.selectionStyle = .None
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
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        self.tableView.endUpdates()
        return
      }
    }
    // Must be that we have to add the drawer
    for (var i = 0; i < self.cells.count; ++i) {
      if self.cells[i] == parent {
        self.cells.insert(drawer, atIndex: i+1)
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i+1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        self.tableView.endUpdates()
        return
      }
    }
  }
}
