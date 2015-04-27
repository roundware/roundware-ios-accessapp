import Foundation
import RWFramework

class AssetViewModel {
  let exhibitionID: Int
  let exhibition: Tag?
  let data: RWData
  let assets: [Asset]
  let browseTags: [TagGroup]
  
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
}