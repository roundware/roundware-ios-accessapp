import Foundation
import UIKit
import RWFramework

class AssetViewModel {
  let exhibitionID: Int
  let exhibition: Tag?
  let data: RWData
  let assets: [Asset]
  var filteredAssets: [Asset]
  let browseTags: [TagGroup]
  var selectedBrowseTags = Set<Int>()

  let TextTagID = -1001
  let PhotoTagID = -1002
  let AudioTagID = -1003
  
  init(exhibitionID: Int, data: RWData) {
    self.exhibitionID = exhibitionID
    self.data = data
    self.assets = data.assets.filter { contains($0.tagIDs, exhibitionID) }
    self.filteredAssets = self.assets
    self.exhibition = data.exhibitions.filter { $0.tagId == exhibitionID }.first

    let options = [Tag(tagId: TextTagID, value: "Text"),
                   Tag(tagId: PhotoTagID, value: "Photo"),
                   Tag(tagId: AudioTagID, value: "Audio")]
    let mediaTagGroup = TagGroup(headerText: "Media Type", options: options)
    var mutate: [TagGroup] = data.browseTags.filter { $0.code != "exhibition" }
    mutate.append(mediaTagGroup)
    self.browseTags = mutate
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
    return self.filteredAssets.count
  }

  func assetAtIndex(index: Int) -> Asset {
    return self.filteredAssets[index]
  }

  func tagForAssetAtIndex(index: Int) -> Tag? {
    let asset = self.filteredAssets[index]
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
    return self.browseTags[index].options.count + 1
  }

  func titleOfTagGroup(index: Int) -> String {
    return self.browseTags[index].headerText
  }

  // MARK: - Tag

  func tagAtIndex(index: Int, forGroup: Int) -> Tag {
    if index == 0 {
      return Tag(tagId: (-1*forGroup)-2000, value: "ALL")
    } else {
      return self.browseTags[forGroup].options[index-1]
    }
  }

  func titleForTagAtIndex(index: Int, forGroup: Int) -> String {
    let tag = tagAtIndex(index, forGroup: forGroup)
    return tag.value
  }

  func accessibiltyLabelTextAtIndex(index: Int, forGroup: Int) -> String {
    let count = numberOfTagsForGroup(forGroup)
    let title = titleForTagAtIndex(index, forGroup: forGroup)
    return String("\(title), \(index+1) of \(count)")
  }

  func accessoryTypeAtIndex(index: Int, forGroup: Int) -> UITableViewCellAccessoryType {
    let tag = tagAtIndex(index, forGroup: forGroup)
    return selectedBrowseTags.contains(tag.tagId) ? .Checkmark : .None
  }
  
  func selectTagAtIndex(index: Int, forGroup: Int) {
    let tag = tagAtIndex(index, forGroup: forGroup)
    let tagIDs = tagGroupAtIndex(forGroup).options.map { $0.tagId }
    selectedBrowseTags.subtractInPlace(tagIDs)
    selectedBrowseTags.insert(tag.tagId)
  }

  func filterAssetsWithTags() {

    // Filter out "ALL"
    self.selectedBrowseTags = Set(filter(selectedBrowseTags) { $0 > -2000 })
    
    if self.selectedBrowseTags.isEmpty {
      filteredAssets = assets
      return
    }

    if self.selectedBrowseTags.contains(TextTagID) {
      filteredAssets = assets.filter { (asset: Asset) -> Bool in
        return asset.mediaType == .Text
      }
      var tags = selectedBrowseTags
      tags.remove(TextTagID)
      filteredAssets = filteredAssets.filter { tags.isSubsetOf($0.tagIDs) }
    } else if self.selectedBrowseTags.contains(PhotoTagID) {
      filteredAssets = assets.filter { (asset: Asset) -> Bool in
        return asset.mediaType == .Photo
      }
      var tags = selectedBrowseTags
      tags.remove(PhotoTagID)
      filteredAssets = filteredAssets.filter { tags.isSubsetOf($0.tagIDs) }
    } else if self.selectedBrowseTags.contains(AudioTagID) {
      filteredAssets = assets.filter { (asset: Asset) -> Bool in
        return asset.mediaType == .Audio
      }
      var tags = selectedBrowseTags
      tags.remove(AudioTagID)
      filteredAssets = filteredAssets.filter { tags.isSubsetOf($0.tagIDs) }
    } else {
      filteredAssets = assets.filter { self.selectedBrowseTags.isSubsetOf($0.tagIDs) }
    }
  }
}
