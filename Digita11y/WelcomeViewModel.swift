import Foundation
class WelcomeViewModel: BaseViewModel  {
    let data: RWData
    var project: Project
    
    init(data: RWData) {
        self.data = data
        self.project = data.selectedProject!
    }
    
}