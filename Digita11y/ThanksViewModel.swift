import Foundation
import RWFramework
class ThanksViewModel: BaseViewModel {
    let data: RWData
    var uiGroup: UIGroup
    let title: String
    let tags: [Tag]
    let itemTag: Tag

    var selectedTag: Tag? {
        didSet {
            self.uiGroup.selectedUIItem = self.uiGroup.uiItems.filter({$0.tagId == self.selectedTag!.id}).first
            data.updateUIGroup(self.uiGroup)
        }
    }

    init(data: RWData) {
        self.data = data
        self.uiGroup = data.getUIGroupForIndexAndMode(1, mode: "speak")!
        itemTag = data.getTagForIndexAndMode(2, mode: "listen")!
        self.title = "Thanks for your contribution to: \(self.itemTag.value)!"
        self.tags = data.getTagsForUIItems(self.uiGroup.uiItems)

        //TODO get available get tags that have not been contributed too for this parent tag....
    }

    func selectedTitle(title:String) {
        self.selectedTag = self.tags.filter{ $0.value == title}.first!
    }
}
