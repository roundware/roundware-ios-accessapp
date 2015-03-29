import UIKit
import RWFramework

class RootTabBarController: UITabBarController, UITabBarControllerDelegate, RWFrameworkProtocol {
  var rwData: RWData?

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let nav = self.selectedViewController as? UINavigationController {
      if let vc = nav.topViewController as? BaseViewController {
        vc.rwData = self.rwData
      }
    }
  }

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

  func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    if let vc = viewController as? BaseViewController {
      vc.rwData = self.rwData
    } else if let nav = viewController as? UINavigationController {
      if let vc = nav.topViewController as? BaseViewController {
        vc.rwData = self.rwData
      }
    }
  }
}
