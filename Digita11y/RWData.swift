import Foundation
import RWFramework

class RWData {
    // MARK: - Project
    
    let projects: [Project] = Project.initFromPlist()
    var selectedProject: Project?

    
    // MARK: - UIGroup
    
    var uiGroups: [UIGroup] = []
        
    // MARK: - UIItem
    
    func getRelevantUIItems(uiGroup: UIGroup) -> [UIItem] {
        if uiGroup.index > 0,
        let previousUIGroup = uiGroups.filter({$0.uiMode == uiGroup.uiMode && $0.index == uiGroup.index - 1}).first,
        let previousSelectedUIItem = previousUIGroup.selectedUIItem {
            return uiGroup.uiItems.filter({ $0.parent == previousSelectedUIItem.id})
        } else {
            return uiGroup.uiItems
        }
    }
    
    func getTagsForUIItems(uiItems: [UIItem]) -> [Tag] {
        let tagIds = uiItems.map { $0.tagId }
        return tags.filter({ tagIds.contains($0.id) })
    }
    
    func getTagForUIItem(uiItem: UIItem) -> Tag? {
        if let tag = tags.filter({$0.id == uiItem.tagId}).first {
            return tag
        } else {
            debugPrint("Missing tag for uiItem \(uiItem.id) with tagId \(uiItem.tagId)")
            return nil
        }
    }
    
    // MARK: - Tags
    var tags: [Tag] = []
    
    

    // MARK: - Assets
    var assets: [Asset] = []

//    func getSelectedTagForUIGroup(uiGroup: UIGroup) -> Tag? {
//        if let indexes = uiGroupsToTagIds[uiGroup.uiMode],
//            let tagId = indexes[uiGroup.index],
//            let tag = tags.filter({$0.id == tagId}).first{
//            return tag
//        } else {
//            return nil
//        }
//    }
//
//    func setSelectedTagForUIGroup(uiGroup: UIGroup, tagId: Int?) {
//        uiGroupsToTagIds[uiGroup.uiMode]![uiGroup.index] = tagId
//    }

//    var uiGroupsToTagIds = [String:[Int:Int?]]() //= [ : [ : ]]
//    func initUIGroupsToTagIds(){
//        for uiGroup in uiGroups {
//            uiGroupsToTagIds[uiGroup.uiMode] = [uiGroup.index : nil]
//        }
//        dump(uiGroupsToTagIds)
//    }
    
//    var listenTags: [Tag] = []
    
//    var speakTags: [Tag] = [] {
//        didSet {
//            selectedSpeakTags = [Int](count: speakTags.count, repeatedValue: -1)
//        }
//    }
//    var selectedSpeakTag: Tag?
//    var selectedSpeakTags: [Int] = []
//    func resetSelectedSpeakTags() {
//        selectedSpeakTags = [Int](count: speakTags.count, repeatedValue: -1)
//    }
//    var speakObjects: [Tag] {
//        get {
//            var group:[TagGroup] = speakTags.filter { $0.code == "object" }
//            return group.first?.options ?? []
//        }
//    }
//    func selectedSpeakObject() -> Tag? {
//        for var i = 0; i < speakTags.count; ++i {
//            if speakTags[i].code == "object" {
//                if selectedSpeakTags[i] != -1 {
//                    return speakTags[i].options[selectedSpeakTags[i]]
//                }
//            }
//        }
//        return nil
//    }
    
    
    // MARK: - Exhibitions

    
    //NOTE other tags that are cross-exhibition (like male/female) have null parents so for exhibition tags we want null parents AND ui_group index=0
    //TODO update for ui groups
//    var selectedExhibition: Tag?
//    
//    var exhibitions: [Tag] {
//        get {
//            var group = listenTags.filter { $0.code == "exhibition" }
//            return group.first?.options ?? []
//        }
//    }
//    
//    func exhibitionForID(tagID: Int) -> Tag? {
//        var tags = self.exhibitions.filter { $0.tagId == tagID }
//        return tags.first
//    }


    var stream: Stream?
//
//    
//    func objectForID(tagID: Int) -> Tag? {
//        var group:[TagGroup] = browseTags.filter { $0.code == "object" }
//        var tags = group.first?.options.filter { $0.tagId == tagID }
//        return tags?.first
//    }
    
}