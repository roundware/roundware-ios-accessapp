import RWFramework
import Foundation
class RoomsViewModel: BaseViewModel  {
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
                self.objectTags = data.getTagsForUIItems(data.getRelevantUIItems(self.objectsUIGroup))
            } else {
                self.roomUIGroup.selectedUIItem = nil
                self.objectTags = []
            }

        }
    }


    var objectsUIGroup: UIGroup
    var objectTags: [Tag] = []
    var selectedObjectIndex: Int?  {
        didSet {
            if let index = selectedObjectIndex {
//                debugPrint("selected item index \(index)")
                if (self.objectTags.count > 0) {
                    self.selectedObjectTag = self.objectTags[index]
                }
            } else {
                self.selectedObjectTag = nil
            }
        }
    }

    var selectedObjectTag: Tag?  {
        willSet(newObjectTag) {
            if let tag = newObjectTag {
                //if new tag or nil update ui group
                if (selectedObjectTag == nil || tag.id != selectedObjectTag!.id){
                    self.objectsUIGroup.selectedUIItem = self.objectsUIGroup.uiItems.filter({$0.tagId == tag.id }).first
                    data.updateUIGroup(self.objectsUIGroup)
                }
            } else{
                self.objectsUIGroup.selectedUIItem = nil
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
//        DebugLog("room tags \(self.roomTags)")
//        dump(data.getRelevantUIItems(self.roomUIGroup))

        //set items ui group
        self.objectsUIGroup = data.getUIGroupForIndexAndMode(3, mode: "listen")!
//        dump(data.getUIGroupForIndexAndMode(3, mode: "listen"))

        //set stream
        self.stream = data.stream
        self.currentAsset = nil
    }
}
