import Foundation
class ChooseExhibitViewModel: BaseViewModel  {
    let data: RWData
    var project: Project
    let exhibitions: [Tag]
    var selectedExhibition: Tag?
    
    init(data: RWData) {
        self.data = data
        self.exhibitions = data.exhibitions
        self.project = data.selectedProject!
        self.selectedExhibition = data.selectedExhibition
    }

    func numberOfExhibits() -> Int {
         return self.exhibitions.count
    }
    
    func titleForIndex(index:Int) -> String{
        return self.exhibitions[index].tagDescription
    }
}