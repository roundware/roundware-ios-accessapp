import Foundation

class TagViewModel {
  let tag: Tag
  let asset: Asset

  init(tag: Tag, asset: Asset) {
    self.tag = tag
    self.asset = asset
  }

  func title() -> String {
    return tag.value
  }

  func text() -> String {
    return asset.text ?? ""
  }

  func accessibilityLabelText() -> String {
    switch (asset.mediaType) {
    case .Text:
      if let s1 = asset.text {
        return String("\(self.title()), text, \(s1)")
      }
      return ""
    case .Audio:
      return String("\(self.title()), audio")
    case .Photo:
      return String("\(self.title()), image, \(asset.assetDescription)")
    default:
      return self.title()
    }
  }
}
