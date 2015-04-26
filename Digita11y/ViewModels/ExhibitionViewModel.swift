import Foundation
import RWFramework


class ExhibitionViewModel {
  let data: RWData

  init(data: RWData) {
    self.data = data
  }

  func numberOfExhibitions() -> Int {
    return self.data.exhibitions.count
  }

  func IDForIndex(index: Int) -> Int {
    return self.data.exhibitions[index].tagId
  }

  func titleForIndex(index: Int) -> String {
    return self.data.exhibitions[index].value
  }

  func accessibilityLabelForIndex(index: Int) -> String {
    return self.data.exhibitions[index].value
  }

  func imageURLForIndex(index: Int) -> NSURL? {
    let urlString = self.data.exhibitions[index].headerImageURL
    return NSURL(string: urlString ?? "")
  }
}