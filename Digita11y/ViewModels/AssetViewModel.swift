import Foundation
import RWFramework

class AssetViewModel {
  let exhibitionID: Int
  let data: RWData
  let assets: [Asset]
  
  init(exhibitionID: Int, data: RWData) {
    self.exhibitionID = exhibitionID
    self.data = data
    self.assets = data.assets.filter { contains($0.tagIDs, exhibitionID) }
  }

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
}