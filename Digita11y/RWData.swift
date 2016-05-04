import Foundation
import RWFramework

class RWData {
    // MARK: - Project
    
    let projects: [Project] = Project.initFromPlist()
    var selectedProject: Project?
    
    func getProjectById(id: Int) -> Project? {
        if let index = projects.indexOf({ $0.id == id }) {
            return projects[index]
        } else {
            return nil
        }
    }

    
    // MARK: - UIGroup
    var uiGroups: [UIGroup] = []
    
    //TODO real error handling
    func getUIGroupForIndexAndMode(index: Int, mode: String) -> UIGroup? {
        if let thisProject = selectedProject,
        let index = uiGroups.indexOf({
            $0.index == index &&
            $0.uiMode == mode &&
            $0.project == thisProject.id
        }) {
            return uiGroups[index]
        } else {
            debugPrint("missing UIGroup for \(index) and \(mode)")
            return nil
        }
    }
    
    func getTagForIndexAndMode(index: Int, mode: String) -> Tag? {
        if  let uiGroup = getUIGroupForIndexAndMode(index, mode: mode),
            let uiItem = uiGroup.selectedUIItem,
            let tag = getTagForUIItem(uiItem){
            return tag
        } else {
            debugPrint("uiitem or tag not found for uigroup \(index) and \(mode)")
            return nil
        }
    }

    
    // MARK: - UIItem
    func getRelevantUIItems(uiGroup: UIGroup) -> [UIItem] {
        if uiGroup.index > 0,
        let previousUIGroup = uiGroups.filter({$0.uiMode == uiGroup.uiMode && $0.index == uiGroup.index - 1}).first,
        let previousSelectedUIItem = previousUIGroup.selectedUIItem {
            debugPrint("previous uigroup \(previousUIGroup.index)")
            debugPrint("and its selected uiitem \(previousSelectedUIItem.id)")
            let uiItems = uiGroup.uiItems.filter({ $0.parent == previousSelectedUIItem.id})
            dump(uiItems)
            return uiItems
        } else {
            debugPrint("no previous uiGroup selection.  showing all uiItems for group")
            let uiItems = uiGroup.uiItems
            dump(uiItems)
            return uiItems
        }
    }
    
    func getTagsForUIItems(uiItems: [UIItem]) -> [Tag] {
        let tagIds = uiItems.map { $0.tagId }
        return tags.filter({ tagIds.contains($0.id) })
    }
    
    func getTagsWithAudioAssetsForUIItems(uiItems: [UIItem]) -> [Tag] {
        let tagIds = uiItems.map { $0.tagId }
        return tags.filter({ tagIds.contains($0.id) && self.getAssetsForTagIdOfMediaType($0.id, mediaType: MediaType.Audio).count > 0})
    }

    
    func getTagForUIItem(uiItem: UIItem) -> Tag? {
        if let tag = tags.filter({$0.id == uiItem.tagId}).first {
            return tag
        } else {
            debugPrint("Missing tag for uiItem \(uiItem.id) with tagId \(uiItem.tagId)")
            return nil
        }
    }
    
    func getSelectedTagForUIGroup(uiGroup: UIGroup) -> Tag? {
        if let selectedUIItem = uiGroup.selectedUIItem {
          return getTagForUIItem(selectedUIItem)
        } else {
            debugPrint("missing uiItem for \(uiGroup)")
            return nil
        }
    }
    
    // MARK: - Tags
    
    var tags: [Tag] = []
    var listenTags: [Tag] = []
    var contributeTags: [Tag] = []
    
    func getTagById(id: Int) -> Tag? {
        if let index = tags.indexOf({ $0.id == id }) {
            return tags[index]
        } else {
            return nil
        }
    }

    func getAssetsForTagIdOfMediaType(tagId: Int, mediaType: MediaType) -> [Asset] {
//        debugPrint("looking for assets with tagID \(tagId) and media type \(mediaType)")
//        return assets.filter({$0.tagIDs.contains(tagId) && $0.mediaType == mediaType })
        var theseAssets = assets.filter({$0.tagIDs.contains(tagId)})
//        if(theseAssets.count > 0){
//            debugPrint("does \(theseAssets[0].mediaType) = \(mediaType)")
//        }
        return theseAssets.filter({$0.mediaType == mediaType })

    }

    // MARK: - Assets
    
    var assets: [Asset] = []
    
    var selectedTextAsset: Asset?
    var selectedImageAssets: [Asset] = []

    // MARK: - Stream

    var stream: Stream?
}