import Foundation
import UIKit
import RWFramework
class ChooseProjectViewModel: BaseViewModel  {
    let data: RWData
    var project: Project?
    let projects: [Project]
    
    init(data: RWData) {
        self.data = data
        self.projects = data.projects
        self.project = data.selectedProject
    }
    
    func numberOfProjects() -> Int {
        return self.projects.count
    }
    
    func selectByTitle(title: String) {
        let selectedProject = self.projects[self.projects.indexOf({$0.name == title})!]
        return self.data.selectedProject = selectedProject
    }
    
    func titleForIndex(index: Int) -> String {
        return self.projects[index].name
    }
}