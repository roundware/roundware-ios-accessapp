import Foundation
import RWFramework
class ContributeViewModel: BaseViewModel  {
    let data: RWData
    var uiGroup: UIGroup
    var mediaType: MediaType?
    var mediaSelected: Bool = false
    var tagsSelected: Bool = false
    var mediaCreated: Bool = false
    var uploaded: Bool = false
    
    var tag: Tag?
    let exhibitionTag: Tag
    let roomTag: Tag
    let itemTag: Tag

    var speakIndex: Int = 0
    var tags: [Tag]
    
    struct Image {
        var path: String
        var text: String
        var image: UIImage?
    }
    var images: [Image] = []
    
    var uploadText = ""
    
    var selectedTag: Tag?  {
        didSet {
            //set tag on data and onto string
            debugPrint("selected tag is \(selectedTag)")
            debugPrint("available ui items are is \(self.uiGroup.uiItems)")
            self.uiGroup.selectedUIItem = self.uiGroup.uiItems.filter({$0.tagId == self.selectedTag!.id}).first
            debugPrint("selected \(self.uiGroup.selectedUIItem) for \(self.uiGroup)")
            data.updateUIGroup(self.uiGroup)
            if let thisTag = tag{
                tagIds = String(thisTag.id, ",")
            }
            //get next set of tags
            speakIndex += 1
            guard let uiGroup = data.getUIGroupForIndexAndMode(speakIndex, mode: "speak") else {
                tagsSelected = true
                return
            }
            self.uiGroup = uiGroup
            
            //TODO check if uiitems contributed
            self.tags = data.getTagsForUIItems(self.uiGroup.uiItems)
            debugPrint("new group is \(self.uiGroup)")
            debugPrint("with these tags \(self.tags)")

        }
    }
    
    var tagIds: String = ""
    
    init(data: RWData) {
        self.data = data        
        exhibitionTag = data.getTagForIndexAndMode(0, mode: "listen")!
        roomTag = data.getTagForIndexAndMode(1, mode: "listen")!
        itemTag = data.getTagForIndexAndMode(2, mode: "listen")!

        uiGroup = data.getUIGroupForIndexAndMode(speakIndex, mode: "speak")!
        tags = data.getTagsForUIItems(self.uiGroup.uiItems)
    }
}