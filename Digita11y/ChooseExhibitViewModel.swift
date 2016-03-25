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
            data.uiGroups[self.uiGroup.index] = self.uiGroup

        }
    }

    
    init(data: RWData) {
        self.data = data
        self.project = data.selectedProject!

        let uiGroupIndex = 0
        let uiGroupMode = "listen"
        self.uiGroup = (data.uiGroups.filter{ $0.index == uiGroupIndex && $0.uiMode == uiGroupMode }.first)!
        
        self.title = "Welcome to the \(self.project.name)! \n \(self.uiGroup.headerTextLoc)"
        self.tags = data.getTagsForUIItems(self.uiGroup.uiItems)
    }

    func numberOfItems() -> Int {
         return self.tags.count
    }
    
    func titleForIndex(index:Int) -> String{
        return self.tags[index].value
    }
    
    func selectedIndex(index:Int) {
        self.selectedTag = self.tags[index]

    }
    
    //kludge
    func selectedTitle(title:String) {
        self.selectedTag = self.tags.filter{ $0.value == title}.first!
    }
}