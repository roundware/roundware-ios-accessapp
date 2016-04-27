import RWFramework
import Foundation
class TagsViewModel: BaseViewModel  {
    let data: RWData

    let exhibitionTag: Tag
    let title: String

    var roomUIGroup: UIGroup
    let roomTags: [Tag]
    // convenience for picker
    // could bug if selectedRoomTag set directly
    var selectedRoomIndex: Int?  {
        didSet {
            if let index = self.selectedRoomIndex {
                self.selectedRoomTag = self.roomTags[index]
            } else {
                self.selectedRoomTag = nil
            }
        }
    }
    var selectedRoomTag: Tag? {
        didSet {
            if let tag = self.selectedRoomTag {
                self.roomUIGroup.selectedUIItem = self.roomUIGroup.uiItems.filter({$0.tagId == tag.id }).first
                data.uiGroups[self.roomUIGroup.index] = self.roomUIGroup
                self.itemTags = data.getTagsForUIItems(data.getRelevantUIItems(self.itemsUIGroup))
                let rwf = RWFramework.sharedInstance
                if(rwf.isPlaying){
                    rwf.submitTags(String(tag.id))
                }
            } else {
                self.roomUIGroup.selectedUIItem = nil
                data.uiGroups[self.roomUIGroup.index] = self.roomUIGroup
                self.itemTags = []
            }
        }
    }
    
    
    var itemsUIGroup: UIGroup
    var itemTags: [Tag] = []
    
    //convenience for next/previous
    //could bug
    var selectedItemIndex: Int?  {
        didSet {
            //TODO lock/reset in case selectedItemTag set directly
            if let index = selectedItemIndex {
                self.selectedItemTag = self.itemTags[index]
            } else {
                self.selectedItemTag = nil
            }
        }
    }
    var selectedItemTag: Tag?  {
        didSet {
            if let tag = self.selectedItemTag {
                self.itemsUIGroup.selectedUIItem = self.itemsUIGroup.uiItems.filter({$0.tagId == tag.id }).first
                let rwf = RWFramework.sharedInstance
                rwf.submitTags(String(tag.id))
            } else {
                self.itemsUIGroup.selectedUIItem = nil
            }
            data.uiGroups[self.itemsUIGroup.index] = self.itemsUIGroup
        }
    }
    
    var stream: Stream? {
        didSet {
            data.stream = stream
        }
    }
    
    //TODO mapURL
    init(data: RWData) {
        self.data = data

        //set title
        self.exhibitionTag = data.getTagForIndexAndMode(0, mode: "listen")!
        self.title = exhibitionTag.value

        //get room options
        self.roomUIGroup = data.getUIGroupForIndexAndMode(1, mode: "listen")!
        self.roomTags = data.getTagsForUIItems(data.getRelevantUIItems(self.roomUIGroup))
        
        //set asset/tag/item whatever we call it ui group
        self.itemsUIGroup = data.getUIGroupForIndexAndMode(2, mode: "listen")!
        
        //set stream
        self.stream = data.stream
    }
}