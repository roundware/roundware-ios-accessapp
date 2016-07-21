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
        //TODO should be max uigroup for speak
        self.uiGroup = data.getUIGroupForIndexAndMode(2, mode: "speak")!
        itemTag = data.getTagForIndexAndMode(3, mode: "listen")!
        self.title = "Thanks for your contribution to: \(self.itemTag.locMsg)!"
        self.tags = data.getTagsForUIItems(self.uiGroup.uiItems)

        //TODO get available get tags that have not been contributed too for this parent tag....
    }

    func selectedTitle(title:String) {
        self.selectedTag = self.tags.filter{ $0.locMsg == title}.first!
    }
}
