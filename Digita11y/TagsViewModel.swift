import Foundation
class TagsViewModel: BaseViewModel  {
    let data: RWData

    let exhibitionTag: Tag
    let title: String

    var roomUIGroup: UIGroup
    let roomTags: [Tag]
    
    var selectedRoomTag: Tag {
        didSet {
            self.roomUIGroup.selectedUIItem = self.roomUIGroup.uiItems.filter({$0.tagId == self.selectedRoomTag.id }).first
            data.uiGroups[self.roomUIGroup.index] = self.roomUIGroup
            self.itemTags = data.getTagsForUIItems(data.getRelevantUIItems(self.itemsUIGroup))
        }
    }
    
    var itemsUIGroup: UIGroup
    var itemTags: [Tag] = []
    var selectedItemTag: Tag?  {
        didSet {
            if let tag = self.selectedItemTag {
                self.itemsUIGroup.selectedUIItem = self.itemsUIGroup.uiItems.filter({$0.tagId == tag.id }).first
            } else {
                self.itemsUIGroup.selectedUIItem = nil
            }
            data.uiGroups[self.itemsUIGroup.index] = self.itemsUIGroup
        }
    }
    
    
    var stream: Stream?
    
//    let mapURL: NSURL
//    var currentAsset = Asset?
//    var imageAssets = [Asset]
//    var textAssets = [Asset]
//    var currentParentTag = Tag?
//    var currentDescendantTag = Tag?
//    var images = [Media]
//    
    init(data: RWData) {
        self.data = data
        
        //set room tags
        let uiGroupIndex = 1
        let uiGroupMode = "listen"
        
        //TODO error handle
        self.roomUIGroup = (data.uiGroups.filter{ $0.index == uiGroupIndex &&
            $0.uiMode == uiGroupMode }.first)!
        self.itemsUIGroup = (data.uiGroups.filter{ $0.index == uiGroupIndex + 1 &&
            $0.uiMode == uiGroupMode }.first)!

        self.roomTags = data.getTagsForUIItems(data.getRelevantUIItems(self.roomUIGroup))
        
        //set title
        let previousUIGroup = (data.uiGroups.filter{ $0.index == uiGroupIndex - 1 &&
            $0.uiMode == uiGroupMode }.first)!
        self.exhibitionTag = data.getTagForUIItem(previousUIGroup.selectedUIItem!)!
        self.title = exhibitionTag.value
        
        //set selected room to first room
        self.selectedRoomTag = roomTags[0]
        
        //set stream
        self.stream = data.stream
    }

    func numberOfRooms() -> Int {
        return self.roomTags.count
    }
    
    func selectedRoomIndex(index:Int) {
        self.selectedRoomTag = self.roomTags[index]
    }
    
    func numberOfItems() -> Int {
        return self.itemTags.count
    }
    
    func selectedItemIndex(index:Int) {
        self.selectedItemTag = self.itemTags[index]
    }
    
    func selectedItemTitle(title:String) {
        self.selectedItemTag = self.itemTags.filter{ $0.value == title}.first!
    }
    
    func deselectItem(){
        self.selectedItemTag = nil
    }
}