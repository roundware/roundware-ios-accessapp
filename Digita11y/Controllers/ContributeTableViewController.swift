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

  var showAudioDrawer = false
  var showPhotoDrawer = false

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
      var cell = tableView.dequeueReusableCellWithIdentifier(AudioDrawerCellIdentifier, forIndexPath: indexPath) as UITableViewCell
      return cell
    case .Photo:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
      cell.textLabel?.text = "Add Photos"
      return cell
    case .PhotoDrawer:
      var cell = tableView.dequeueReusableCellWithIdentifier(PhotoDrawerCellIdentifier, forIndexPath: indexPath) as UITableViewCell
      return cell
    case .Text:
      var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
      cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
      cell.textLabel?.text = "Add Text"
      return cell
    case .TextDrawer:
      break // Need to build out this cell
    }

    return UITableViewCell()
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let type = self.cells[indexPath.row]
    switch (type) {
    case .Audio:
      // Remove audio drawer?
      for (var i = 0; i < self.cells.count; ++i) {
        if self.cells[i] == Cell.AudioDrawer {
          self.cells.removeAtIndex(i)
          self.tableView.reloadData()
          return
        }
      }
      // Must be that we have to add the audio drawer
      for (var i = 0; i < self.cells.count; ++i) {
        if self.cells[i] == Cell.Audio {
          self.cells.insert(Cell.AudioDrawer, atIndex: i+1)
          self.tableView.reloadData()
          return
        }
      }
    case .Photo:
      // Remove photo drawer?
      for (var i = 0; i < self.cells.count; ++i) {
        if self.cells[i] == Cell.PhotoDrawer {
          self.cells.removeAtIndex(i)
          self.tableView.reloadData()
          return
        }
      }
      // Must be that we have to add the audio drawer
      for (var i = 0; i < self.cells.count; ++i) {
        if self.cells[i] == Cell.Photo {
          self.cells.insert(Cell.PhotoDrawer, atIndex: i+1)
          self.tableView.reloadData()
          return
        }
      }
    case .Text:
      break // Need to insert/remove this cell
    default:
      break
    }
  }
}
