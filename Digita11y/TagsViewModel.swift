import Foundation
class TagsViewModel: BaseViewModel  {
    let data: RWData
    let exhibition: Tag
//    let stream = Stream
    //    let parentTags = [Tag]
    //    let currentDescendantTags = [Tag]
    //    let speed = Double
    
//    var currentAsset = Asset?
//    var imageAssets = [Asset]
//    var textAssets = [Asset]
//    var currentParentTag = Tag?
//    var currentDescendantTag = Tag?
//    var images = [Media]
    
    init(data: RWData) {
        self.data = data
        self.exhibition = data.selectedExhibition!
//        self.parentTags = data.parentTags
//        self.currentParentTag = data.currentParentTag
//        self.currentDescendantTags = data.currentDescendantTags
//        self.currentDescendantTag = data.currentDescendantTag
//        self.stream = data.stream
    }
}