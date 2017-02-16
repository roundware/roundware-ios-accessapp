import RWFramework
import Foundation
class TagsViewModel: BaseViewModel  {
    let data: RWData

    let exhibitionTag: Tag
    let title: String

    var stream: Stream? {
        didSet {
            data.stream = stream
        }
    }


    var roomUIGroup: UIGroup
    let roomTags: [Tag]

    // convenience for pickerView
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
                data.updateUIGroup(self.roomUIGroup)
                self.itemTags = data.getTagsForUIItems(data.getRelevantUIItems(self.itemsUIGroup))

                self.selectedItemIndex = 0
            } else {
                self.roomUIGroup.selectedUIItem = nil
                self.itemTags = []
            }

        }
    }


    var itemsUIGroup: UIGroup
    var itemTags: [Tag] = []
    var selectedItemIndex: Int?  {
        didSet {
            if let index = selectedItemIndex {
//                debugPrint("selected item index \(index)")
                if (self.itemTags.count > 0) {
                    self.selectedItemTag = self.itemTags[index]
                }
            } else {
                self.selectedItemTag = nil
            }
        }
    }
    var selectedItemTag: Tag?  {
        willSet(newItemTag) {
            if let tag = newItemTag {
                //if new tag or nil update ui group
                if (selectedItemTag == nil || tag.id != selectedItemTag!.id){
                    self.itemsUIGroup.selectedUIItem = self.itemsUIGroup.uiItems.filter({$0.tagId == tag.id }).first
                    data.updateUIGroup(self.itemsUIGroup)
                }
            } else{
                self.itemsUIGroup.selectedUIItem = nil
            }
        }
    }

    var currentAsset : Asset?

    init(data: RWData) {
        self.data = data

        //set title
        self.exhibitionTag = data.getTagForIndexAndMode(1, mode: "listen")!
        self.title = exhibitionTag.locMsg

        //get room options
        self.roomUIGroup = data.getUIGroupForIndexAndMode(2, mode: "listen")!
        self.roomTags = data.getTagsForUIItems(data.getRelevantUIItems(self.roomUIGroup))
        DebugLog("room tags \(self.roomTags)")
//        dump(data.getRelevantUIItems(self.roomUIGroup))

        //set items ui group
        self.itemsUIGroup = data.getUIGroupForIndexAndMode(3, mode: "listen")!
//        dump(data.getUIGroupForIndexAndMode(3, mode: "listen"))

        //set stream
        self.stream = data.stream
        self.currentAsset = nil
    }
}
