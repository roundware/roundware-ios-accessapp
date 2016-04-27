import Foundation
import RWFramework
class ContributeViewModel: BaseViewModel  {
    let data: RWData
    let exhibitionTag: Tag
    var uiGroup: UIGroup
    var mediaType: MediaType?
    let tags: [Tag]
    var tag: Tag?
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
        exhibitionTag = data.getTagForIndexAndMode(1, mode: "listen")!
        uiGroup = data.getUIGroupForIndexAndMode(0, mode: "speak")!
        tags = data.getTagsForUIItems(self.uiGroup.uiItems)
    }

}