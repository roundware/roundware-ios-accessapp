import Foundation
import RWFramework
class ContributeViewModel: BaseViewModel  {
    var data: RWData
    var uiGroup: UIGroup
    var mediaType: MediaType?
    var mediaSelected: Bool = false
    var tagsSelected: Bool = false
    var mediaCreated: Bool = false
    var uploaded: Bool = false

    let exhibitionTag: Tag
    let roomTag: Tag
    let itemTag: Tag

    var speakIndex: Int = 1
    var tags: [Tag]
    var uiItems: [UIItem]

    struct Image {
        var path: String
        var text: String
        var image: UIImage?
    }
    var images: [Image] = []

    var uploadText = ""

    var selectedTag: Tag?  {
        didSet {
            //set tag on data
            if let thisTag = selectedTag{
//                debugPrint("selected tag is \(thisTag)")
//                debugPrint("available ui items are is \(self.uiGroup.uiItems)")
                self.uiGroup.selectedUIItem = self.uiGroup.uiItems.filter({$0.tagId == thisTag.id}).first
//                debugPrint("selected \(self.uiGroup.selectedUIItem) for \(self.uiGroup)")
                data.updateUIGroup(self.uiGroup)
                //get next set of tags
                speakIndex += 1

                guard let uiGroup = data.getUIGroupForIndexAndMode(speakIndex, mode: "speak") else {
                    tagsSelected = true
                    return
                }
                let uiItems = data.getRelevantUIItems(uiGroup)
                if (uiItems.count == 0){
                    tagsSelected = true
                    return
                }

                self.uiGroup = uiGroup
                self.uiItems = uiItems
                self.tags = data.getTagsForUIItems(self.uiItems)
            } else {
                self.uiGroup.selectedUIItem = nil
            }
        }
    }

    init(data: RWData) {
        self.data = data
        exhibitionTag = data.getTagForIndexAndMode(1, mode: "listen")!
        roomTag = data.getTagForIndexAndMode(2, mode: "listen")!
        dump(roomTag)
        itemTag = data.getTagForIndexAndMode(3, mode: "listen")!
        dump(itemTag)
        uiGroup = data.getUIGroupForIndexAndMode(speakIndex, mode: "speak")!
        uiItems = data.getRelevantUIItems(self.uiGroup)
        tags = data.getTagsForUIItems(self.uiItems)
    }

    func resetForRecontribute(){
        uiGroup = data.getUIGroupForIndexAndMode(data.getMaxUIGroupIndexWithSelected("speak"), mode: "speak")!
        uiItems = data.getRelevantUIItems(self.uiGroup)
        tags = data.getTagsForUIItems(self.uiItems)
    }

    func tagIds() -> String{
        var ids = String(itemTag.id) + ","
        for index in 1 ..< speakIndex {
            if let tag = data.getTagForIndexAndMode(index, mode: "speak"){
//                debugPrint("adding tagId for speak index \(index)")
                ids += String(tag.id) + ","
            }
        }
        return ids
    }
}
