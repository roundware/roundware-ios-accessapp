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
}