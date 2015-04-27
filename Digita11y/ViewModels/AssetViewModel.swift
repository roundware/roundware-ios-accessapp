import Foundation
import UIKit
import RWFramework

class AssetViewModel {
  let exhibitionID: Int
  let exhibition: Tag?
  let data: RWData
  let assets: [Asset]
  let browseTags: [TagGroup]
  var selectedBrowseTags = Set<Int>()
  
  init(exhibitionID: Int, data: RWData) {
    self.exhibitionID = exhibitionID
    self.data = data
    self.assets = data.assets.filter { contains($0.tagIDs, exhibitionID) }
    self.exhibition = data.exhibitions.filter { $0.tagId == exhibitionID }.first
    self.browseTags = data.browseTags.filter { $0.code != "exhibition" }
  }

  // MARK: - Exhibition

  func titleForExhibition() -> String {
    return self.exhibition?.value ?? ""
  }

  func imageURLForExhibition() -> NSURL? {
    let urlString = self.exhibition?.headerImageURL
    return NSURL(string: urlString ?? "")
  }

  // MARK: - Assets

  func numberOfAssets() -> Int {
    return self.assets.count
  }

  func assetAtIndex(index: Int) -> Asset {
    return self.assets[index]
  }

  func tagForAssetAtIndex(index: Int) -> Tag? {
    let asset = self.assets[index]
    let tag = asset.tagIDs.map { self.data.objectForID($0) }.filter { $0 != nil }.first
    if let tag = tag {
      return tag
    }
    return .None
  }

  // MARK: - Tag Group

  func numberOfTagGroups() -> Int {
    return self.browseTags.count
  }

  func tagGroupAtIndex(index: Int) -> TagGroup {
    return self.browseTags[index]
  }

  func numberOfTagsForGroup(index: Int) -> Int {
    return self.browseTags[index].options.count
  }

  func titleOfTagGroup(index: Int) -> String {
    return self.browseTags[index].headerText
  }

  // MARK: - Tag

  func tagAtIndex(index: Int, forGroup: Int) -> Tag {
    return self.browseTags[forGroup].options[index]
  }

  func titleForTagAtIndex(index: Int, forGroup: Int) -> String {
    return self.browseTags[forGroup].options[index].value
  }

  func accessibiltyLabelTextAtIndex(index: Int, forGroup: Int) -> String {
    let title = titleForTagAtIndex(index, forGroup: forGroup)
    let count = self.browseTags[forGroup].options.count
    return String("\(title), \(index) of \(count)")
  }

  func selectTagAtIndex(index: Int, forGroup: Int) {
    let tag = tagAtIndex(index, forGroup: forGroup)
    let tagIDs = tagGroupAtIndex(forGroup).options.map { $0.tagId }
    selectedBrowseTags.subtract(tagIDs)
    selectedBrowseTags.insert(tag.tagId)
  }
}
