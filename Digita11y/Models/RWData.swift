import Foundation
import RWFramework

class RWData {
  var stream: Stream?
  var speakTags: [TagGroup] = []
  var listenTags: [TagGroup] = []
  var browseTags: [TagGroup] = []
  var assets: [Asset] = []
  var exhibitions: [Tag] {
    get {
      var group = browseTags.filter { $0.code == "exhibition" }
      return group.first?.options ?? []
    }
  }

  func objectForID(tagID: Int) -> Tag? {
    var group:[TagGroup] = browseTags.filter { $0.code == "object" }
    var tags = group.first?.options.filter { $0.tagId == tagID }
    return tags?.first
  }
}