import Foundation
import RWFramework

class RWData {
    // moved our declarations around
    
    // MARK: - Project

    var selectedProject: Project?
    let projects: [Project] = Project.initFromPlist()
    
    // MARK: - Listen

    var listenTags: [TagGroup] = []
    
    // MARK: - Speak

    var speakTags: [TagGroup] = [] {
        didSet {
            selectedSpeakTags = [Int](count: speakTags.count, repeatedValue: -1)
        }
    }
    
    //TODO do we want to use Ints or the whole object...
    
    var selectedSpeakTag: Tag?
    var selectedSpeakTags: [Int] = []
    func resetSelectedSpeakTags() {
        selectedSpeakTags = [Int](count: speakTags.count, repeatedValue: -1)
    }
    
    //NOTE ? object code ?
    
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
    
    //TODO track all the speak tags that have been described
    
    // MARK: - Exhibitions

    
    //NOTE other tags that are cross-exhibition (like male/female) have null parents so for exhibition tags we want null parents AND ui_group index=0
    //TODO update for ui groups
    var selectedExhibition: Tag?
    
    var exhibitions: [Tag] {
        get {
            var group = listenTags.filter { $0.code == "exhibition" }
            return group.first?.options ?? []
        }
    }
    
    func exhibitionForID(tagID: Int) -> Tag? {
        var tags = self.exhibitions.filter { $0.tagId == tagID }
        return tags.first
    }
    
    
    // MARK: - More
    
    var stream: Stream?
    var assets: [Asset] = []
//    
//    
//    func objectForID(tagID: Int) -> Tag? {
//        var group:[TagGroup] = browseTags.filter { $0.code == "object" }
//        var tags = group.first?.options.filter { $0.tagId == tagID }
//        return tags?.first
//    }
    
}