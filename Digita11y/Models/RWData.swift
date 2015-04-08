import Foundation
import RWFramework

class RWData {
  var stream: Stream?
  var speakTags: [TagGroup] = []
  var listenTags: [TagGroup] = []
  var projects: [Project] = []
  var exhibitions: [TagGroup] {
    get {
      return listenTags.filter { $0.code == "exhibition" }
    }
  }
}