import Foundation
import UIKit

class WelcomeViewModel: BaseViewModel  {
    let data: RWData
    var project: Project
    let title: String
    let body: String
    let logoImage: UIImage?

    init(data: RWData) {
        self.data = data
        self.project = data.selectedProject!
        self.title = "Welcome to the \(self.project.name)!"
        self.body = self.project.welcome
        self.logoImage = self.project.logoImg
    }

}
