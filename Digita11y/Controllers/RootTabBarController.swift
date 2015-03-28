import UIKit
import RWFramework

class RootTabBarController: UITabBarController, RWFrameworkProtocol {
  var rwData: RWData?

  func rwUpdateStatus(message: String) {
    debugPrintln(message)
  }

  func rwPostUsersFailure(error: NSError?) {
    debugPrintln(error)
  }

  func rwPostSessionsSuccess() {
  }

  func rwGetProjectsIdTagsSuccess(data: NSData?) {
    let json = JSON(data: data!)
    self.rwData?.speakTags = json["speak"].array?.map { TagGroup(json: $0) } ?? []
    self.rwData?.listenTags = json["listen"].array?.map { TagGroup(json: $0) } ?? []
    debugPrintln(self.rwData?.speakTags)
    debugPrintln(self.rwData?.listenTags)
  }

  func rwGetProjectsIdTagsFailure(error: NSError?) {
    debugPrintln(error)
  }
}
