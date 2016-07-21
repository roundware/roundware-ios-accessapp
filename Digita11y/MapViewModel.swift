import Foundation
class MapViewModel: BaseViewModel  {
    let data: RWData
    var mapURL: String

    init(data: RWData) {
        self.data = data
        self.mapURL = data.selectedProject!.mapURL
    }
}