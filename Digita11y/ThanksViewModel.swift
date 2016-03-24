import Foundation
import RWFramework
class ThanksViewModel: BaseViewModel {
    let data: RWData
    let tags: [Tag]
//    var selectedSpeakTag: Tag
//    
    init(data: RWData) {
        self.data = data
        self.tags = data.tags
//        self.selectedSpeakTag = data.selectedSpeakTag!
    }
//
    func numberOfTags() -> Int {
        return self.tags.count
    }
//
//    func IDForIndex(index: Int) -> Int {
//        return self.tags[index].tagId
//    }
//    
    func titleForIndex(index: Int) -> String {
        return self.tags[index].value
    }
//
//    func selectTagAtIndex(index: Int) {
//        self.selectedSpeakTag = self.tags[index]
//    }

}