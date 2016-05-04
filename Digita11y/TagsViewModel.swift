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
                debugPrint("selected room index \(index) out of \(self.roomTags)")
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
                data.updateUIGroup(self.roomUIGroup)
                debugPrint("selected ui item for room is \(self.roomUIGroup.selectedUIItem)")
                debugPrint("and their tags \(data.getTagsWithAudioAssetsForUIItems(data.getRelevantUIItems(self.itemsUIGroup)))")
                self.itemTags = data.getTagsWithAudioAssetsForUIItems(data.getRelevantUIItems(self.itemsUIGroup))
//                self.itemTags = data.getTagsForUIItems(data.getRelevantUIItems(self.itemsUIGroup))
                debugPrint("item tags set as \(itemTags)")
                self.selectedItemIndex = 0
                let rwf = RWFramework.sharedInstance
                if(rwf.isPlaying){
                    rwf.submitTags(String(tag.id))
                }
            } else {
                self.roomUIGroup.selectedUIItem = nil
                self.itemTags = []
                //can't be set nil on rwData
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
                debugPrint("selected item index \(index)")
                if (self.itemTags.count > 0) {
                    self.selectedItemTag = self.itemTags[index]
                }
            } else {
                self.selectedItemTag = nil
            }
        }
    }
    var selectedItemTag: Tag?  {
        didSet {
            if let tag = self.selectedItemTag {
                self.itemsUIGroup.selectedUIItem = self.itemsUIGroup.uiItems.filter({$0.tagId == tag.id }).first
                data.updateUIGroup(self.itemsUIGroup)
                let rwf = RWFramework.sharedInstance
                debugPrint("submitting tag id \(tag.id)")
                rwf.submitTags(String(tag.id))
            } else {
                self.itemsUIGroup.selectedUIItem = nil
                //can't be set nil on rwdata
            }
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
        debugPrint("room tags \(self.roomTags)")
        
        //set items ui group
        self.itemsUIGroup = data.getUIGroupForIndexAndMode(2, mode: "listen")!
        
        //set stream
        self.stream = data.stream
    }
}