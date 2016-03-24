import Foundation
class ChooseExhibitViewModel: BaseViewModel  {
    let data: RWData
    let project: Project
    let uiGroup: UIGroup
    let title: String
    let tags: [Tag]
    var selectedTag: Tag?
    
    init(data: RWData) {
        self.data = data
        self.project = data.selectedProject!
        let uiGroupIndex = 0
        let uiGroupMode = "listen"
        dump(data.uiGroups)
        self.uiGroup = (data.uiGroups.filter{ $0.index == uiGroupIndex && $0.uiMode == uiGroupMode }.first)!
        self.title = "Welcome to the \(self.project.name)! \n \(self.uiGroup.headerTextLoc)"
        self.tags = data.getTagsForUIItems(self.uiGroup.uiItems)!
        self.selectedTag = data.getSelectedTagForUIGroup(uiGroup)
        
    }

    func numberOfItems() -> Int {
         return self.tags.count
    }
    
    func titleForIndex(index:Int) -> String{
        return self.tags[index].value
    }
    
    func selectedIndex(index:Int) {
        self.selectedTag = self.tags[index]
        self.data.setSelectedTagForUIGroup(self.uiGroup, tagId: self.selectedTag?.id)
    }
    
    //kludge
    func selectedTitle(title:String) {
        self.selectedTag = self.tags.filter{ $0.value == title}.first!
        self.data.setSelectedTagForUIGroup(self.uiGroup, tagId: self.selectedTag?.id)
    }
}