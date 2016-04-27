import Foundation
import RWFramework
class ThanksViewModel: BaseViewModel {
    let data: RWData
    var uiGroup: UIGroup
    let title: String
    let tags: [Tag]
    let exhibitionTag: Tag
    
    var selectedTag: Tag? {
        didSet {
            self.uiGroup.selectedUIItem = self.uiGroup.uiItems.filter({$0.tagId == self.selectedTag!.id}).first
            data.uiGroups[self.uiGroup.index] = self.uiGroup
        }
    }
    
    init(data: RWData) {
        self.data = data
        exhibitionTag = data.getTagForIndexAndMode(1, mode: "listen")!
        self.uiGroup = data.getUIGroupForIndexAndMode(0, mode: "speak")!
        self.title = "Thanks for your contribution to: \(self.exhibitionTag.value)!"
        self.tags = data.getTagsForUIItems(self.uiGroup.uiItems)
    }
    
    func selectedTitle(title:String) {
        self.selectedTag = self.tags.filter{ $0.value == title}.first!
    }
}