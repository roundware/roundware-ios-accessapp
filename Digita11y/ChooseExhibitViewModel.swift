import Foundation
class ChooseExhibitViewModel: BaseViewModel  {
    let data: RWData
    let project: Project
    var uiGroup: UIGroup
    let title: String
    let tags: [Tag]
    
    var selectedTag: Tag? {
        didSet {
            self.uiGroup.selectedUIItem = self.uiGroup.uiItems.filter({$0.tagId == self.selectedTag!.id}).first
            data.updateUIGroup(self.uiGroup)
            debugPrint("selected ui item for exhibitions uigroup at index \(self.uiGroup.index) set to \(self.uiGroup.selectedUIItem)")
        }
    }
    
    init(data: RWData) {
        self.data = data
        self.project = data.selectedProject!

        self.uiGroup = data.getUIGroupForIndexAndMode(0, mode: "listen")!
        self.title = "Welcome to the \(self.project.name)! \n \(self.uiGroup.headerTextLoc)"
        self.tags = data.getTagsForUIItems(self.uiGroup.uiItems)
    }
    
    
    
    //TODO remove these and refactor
    func numberOfItems() -> Int {
         return self.tags.count
    }
    
    func titleForIndex(index:Int) -> String{
        return self.tags[index].value
    }
    
    func selectedIndex(index:Int) {
        self.selectedTag = self.tags[index]

    }
    
    func selectedTitle(title:String) {
        self.selectedTag = self.tags.filter{ $0.value == title}.first!
    }
}