import Foundation
import RWFramework

class RWData {
  var stream: Stream?
  var speakTags: [TagGroup] = []
  var listenTags: [TagGroup] = []
  var assets: [Asset] = []
  var exhibitions: [Tag] {
    get {
      var group = listenTags.filter { $0.code == "exhibition" }
      return group.first?.options ?? []
    }
  }

  func objectForID(tagID: Int) -> Tag? {
    var group:[TagGroup] = listenTags.filter { $0.code == "object" }
    var tags = group.first?.options.filter { $0.tagId == tagID }
    return tags?.first
  }
}