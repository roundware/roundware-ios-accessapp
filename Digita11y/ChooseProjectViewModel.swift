import Foundation
import UIKit
import RWFramework
class ChooseProjectViewModel: BaseViewModel  {
    let data: RWData
    let projects: [Project]
    var selectedProject: Project?  {
        didSet {
            //TODO necessary
            self.data.selectedProject = selectedProject
        }
    }
    
    init(data: RWData) {
        self.data = data
        self.projects = data.projects
        self.selectedProject = data.selectedProject
    }
}