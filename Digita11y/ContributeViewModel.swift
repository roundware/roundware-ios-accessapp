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

    let tags: [Tag]
    let speakTags: [Tag]
    
    struct Image {
        var path: String
        var text: String
        var image: UIImage?
    }
    var images: [Image] = []
    
    var uploadText = ""
    
    var selectedTag: Tag?  {
        didSet {
            self.uiGroup.selectedUIItem = self.uiGroup.uiItems.filter({$0.tagId == self.selectedTag!.id}).first
            data.uiGroups[self.uiGroup.index] = self.uiGroup
            if let thisTag = tag{
                tagIds = String(thisTag.id)
            }
        }
    }
    
    var tagIds: String = ""
    
    //TODO abstract as function to allow for multiple questions, passing from thanks, and return
    init(data: RWData) {
        self.data = data        
        exhibitionTag = data.getTagForIndexAndMode(0, mode: "listen")!
        roomTag = data.getTagForIndexAndMode(1, mode: "listen")!
        itemTag = data.getTagForIndexAndMode(2, mode: "listen")!

        uiGroup = data.getUIGroupForIndexAndMode(0, mode: "speak")!
        tags = data.getTagsForUIItems(self.uiGroup.uiItems)
        speakTags = []
    }

}