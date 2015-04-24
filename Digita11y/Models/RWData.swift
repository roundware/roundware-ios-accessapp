import Foundation
import RWFramework

class RWData {
  var stream: Stream?
  var speakTags: [TagGroup] = [] {
    didSet {
      selectedSpeakTags = [Int](count: speakTags.count, repeatedValue: -1)
    }
  }
  var listenTags: [TagGroup] = []
  var browseTags: [TagGroup] = []
  var assets: [Asset] = []

  var exhibitions: [Tag] {
    get {
      var group = browseTags.filter { $0.code == "exhibition" }
      return group.first?.options ?? []
    }
  }

  var selectedSpeakTags: [Int] = []

  func resetSelectedSpeakTags() {
    selectedSpeakTags = [Int](count: speakTags.count, repeatedValue: -1)
  }
  
  var speakObjects: [Tag] {
    get {
      var group:[TagGroup] = speakTags.filter { $0.code == "object" }
      return group.first?.options ?? []
    }
  }

  func selectedSpeakObject() -> Tag? {
    for var i = 0; i < speakTags.count; ++i {
      if speakTags[i].code == "object" {
        if selectedSpeakTags[i] != -1 {
          return speakTags[i].options[selectedSpeakTags[i]]
        }
      }
    }
    return nil
  }

  func objectForID(tagID: Int) -> Tag? {
    var group:[TagGroup] = browseTags.filter { $0.code == "object" }
    var tags = group.first?.options.filter { $0.tagId == tagID }
    return tags?.first
  }

  func exhibitionForID(tagID: Int) -> Tag? {
    var tags = self.exhibitions.filter { $0.tagId == tagID }
    return tags.first
  }
}