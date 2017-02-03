import Foundation
import RWFramework

class RWData {
    // MARK: - Project

    let projects: [Project] = Project.initFromPlist()
    var selectedProject: Project?

    func getProjectById(_ id: Int) -> Project? {
        if let index = projects.index(where: { $0.id == id }) {
            return projects[index]
        } else {
            return nil
        }
    }


    // MARK: - UIGroup
    var uiGroups: [UIGroup] = []

    //TODO real error handling
    func getUIGroupForIndexAndMode(_ index: Int, mode: String) -> UIGroup? {
        guard let thisProject = selectedProject else{
            DebugLog("needs project")
            return nil
        }

        let matches = uiGroups.filter() {
            let indexMatch = $0.index == index
            let modeMatch = $0.uiMode == mode
            let active = $0.active == true
            let projectMatch  =  $0.project == thisProject.id
            return indexMatch && modeMatch && active && projectMatch
        }
        if(matches.count > 0){
            return matches[0]
        } else {
            DebugLog("missing UIGroup for \(index) and \(mode)")
            if let thisProject = selectedProject{
                DebugLog("For project \(thisProject.id)")
            }
            dump(uiGroups)
            return nil
        }
    }

    func getMaxUIGroupIndexWithSelected(_ mode:String) -> Int {
        guard let thisProject = selectedProject else{
            DebugLog("needs project")
            return 0
        }
        let matches = uiGroups.filter() {
            let modeMatch = $0.uiMode == mode
            let active = $0.active == true
            let projectMatch  =  $0.project == thisProject.id
            let selectedUIItemExists = $0.selectedUIItem != nil
            return modeMatch && active && projectMatch && selectedUIItemExists
        }
        var max = 0
        matches.forEach {
            if $0.index > max {
                max = $0.index
            }
        }
        return max
    }

    func resetUIGroupAndAbove(_ index: Int, mode: String) -> Bool{
        guard let thisProject = selectedProject else{
            DebugLog("needs project")
            return false
        }
        let matches = uiGroups.filter() {
            let indexMatch = $0.index >= index
            let modeMatch = $0.uiMode == mode
            let active = $0.active == true
            let projectMatch  =  $0.project == thisProject.id
            let selectedUIItemExists = $0.selectedUIItem != nil
            return indexMatch && modeMatch && active && projectMatch && selectedUIItemExists
        }
        if(matches.count > 0){
            for(var uiGroup) in matches            {
                uiGroup.selectedUIItem = nil
                updateUIGroup(uiGroup)
            }
            return true
        } else {
            return false
        }
    }

    func updateUIGroup(_ uiGroup: UIGroup) -> Void {
        //TODO filter ofr active
        if let thisProject = selectedProject,
            let index = uiGroups.index(where: {
                $0.index == uiGroup.index &&
                    $0.uiMode == uiGroup.uiMode &&
                    $0.project == thisProject.id
            }) {
            uiGroups[index] = uiGroup
        } else {
            //TODO real error
            DebugLog("ERROR: missing uiGroup in uiGroups array for \(uiGroup)")
        }
    }

    //TODO mode should be uiMode
    func getTagForIndexAndMode(_ index: Int, mode: String) -> Tag? {
        if  let uiGroup = getUIGroupForIndexAndMode(index, mode: mode),
            let uiItem = uiGroup.selectedUIItem,
            let tag = getTagForUIItem(uiItem){
            return tag
        } else {
            DebugLog("uiitem or tag not found for uigroup \(index) and \(mode)")
            return nil
        }
    }

    // MARK: - UIItem
    func getRelevantUIItems(_ uiGroup: UIGroup) -> [UIItem] {
        if uiGroup.index > 1,
        let previousUIGroup = uiGroups.filter({
            $0.uiMode == uiGroup.uiMode &&
            $0.index == uiGroup.index - 1 &&
            $0.active == true
        }).first,
        let previousSelectedUIItem = previousUIGroup.selectedUIItem {
            DebugLog("previous uigroup \(previousUIGroup.index)")
            DebugLog("and its selected uiitem \(previousSelectedUIItem.id)")
            let uiItems = uiGroup.uiItems.filter({ $0.parent == previousSelectedUIItem.id})
//            dump(uiItems)
            return uiItems
        } else {
            DebugLog("no previous uiGroup selection.  showing all uiItems for group")
            let uiItems = uiGroup.uiItems
//            dump(uiItems)
            return uiItems
        }
    }

    func getTagsForUIItems(_ uiItems: [UIItem]) -> [Tag] {
        let tagIds = uiItems.map { $0.tagId }
        return tags.filter({ tagIds.contains($0.id) })
    }

    func getTagsWithAudioAssetsForUIItems(_ uiItems: [UIItem]) -> [Tag] {
        let tagIds = uiItems.map { $0.tagId }
        return tags.filter({ tagIds.contains($0.id) && self.getAssetsForTagIdOfMediaType($0.id, mediaType: MediaType.audio).count > 0})
    }


    func getTagForUIItem(_ uiItem: UIItem) -> Tag? {
        if let tag = tags.filter({$0.id == uiItem.tagId}).first {
            return tag
        } else {
            DebugLog("Missing tag for uiItem \(uiItem.id) with tagId \(uiItem.tagId)")
            return nil
        }
    }

    func getSelectedTagForUIGroup(_ uiGroup: UIGroup) -> Tag? {
        if let selectedUIItem = uiGroup.selectedUIItem {
          return getTagForUIItem(selectedUIItem)
        } else {
            DebugLog("missing uiItem for \(uiGroup)")
            return nil
        }
    }


    // for active state fudging
    func getUIGroupFromUIItem(_ uiItem: UIItem) -> UIGroup? {
        if let uiGroup = uiGroups.filter({$0.uiItems.map{$0.id}.contains(uiItem.id)}).first{
            return uiGroup
        } else{
            return nil
        }
    }
    
    func getChildren(_ uiItem: UIItem) -> [UIItem]{
        if let uiGroupTop = getUIGroupFromUIItem(uiItem),
            let uiGroupBottom = getUIGroupForIndexAndMode(uiGroupTop.index + 1, mode: uiGroupTop.uiMode){
            return uiGroupBottom.uiItems.filter({ $0.parent == uiItem.id})
        } else {
            return []
        }
    }

    // MARK: - Tags

    var tags: [Tag] = []

    func getTagById(_ id: Int) -> Tag? {
        if let index = tags.index(where: { $0.id == id }) {
            return tags[index]
        } else {
            return nil
        }
    }

    func getAssetsForTagIdOfMediaType(_ tagId: Int, mediaType: MediaType) -> [Asset] {
//        debugPrint("looking for assets with tagID \(tagId) and media type \(mediaType)")
//        return assets.filter({$0.tagIDs.contains(tagId) && $0.mediaType == mediaType })
        let theseAssets = assets.filter({$0.tagIDs.contains(tagId)})
//        debugPrint("assets for tag \(tagId)")
//        dump(theseAssets)
//        if(theseAssets.count > 0){
//            debugPrint("does \(theseAssets[0].mediaType) = \(mediaType)")
//        }
        return theseAssets.filter({$0.mediaType == mediaType })

    }

    // MARK: - Assets

    var assets: [Asset] = []

    var selectedTextAsset: Asset?
    var selectedImageAssets: [Asset] = []

    var mediaTypeSelected: MediaType?

    func getAssetById(_ asset_id: Int) -> Asset? {
        if let index = assets.index(where: { $0.assetID == asset_id }) {
            return assets[index]
        } else {
            return nil
        }
    }

    // MARK: - Stream

    var stream: Stream?
}
