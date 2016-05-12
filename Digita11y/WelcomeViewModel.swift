import Foundation
class WelcomeViewModel: BaseViewModel  {
    let data: RWData
    var project: Project
    let title: String
    let body: String

    init(data: RWData) {
        self.data = data
        self.project = data.selectedProject!
        self.title = "Welcome to the \(self.project.name)!"
        self.body = self.project.welcome
    }

}
