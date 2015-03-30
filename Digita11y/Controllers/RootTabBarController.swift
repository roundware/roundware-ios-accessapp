import UIKit
import RWFramework

class RootTabBarController: UITabBarController, UITabBarControllerDelegate, RWFrameworkProtocol {
  var rwData: RWData?

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let nav = self.selectedViewController as? UINavigationController {
      if let vc = nav.topViewController as? BaseViewController {
        vc.rwData = self.rwData
      } else if let vc = nav.topViewController as? BaseTableViewController {
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

  func rwGetProjectsIdSuccess(data: NSData?) {
    if let projectData = RWFrameworkConfig.getConfigDataFromGroup(group: RWFrameworkConfig.ConfigGroup.Project) as? NSDictionary {
      var rwf = RWFramework.sharedInstance
      let project_id = projectData["project_id"] as! NSNumber
      let dict: [String:String] = ["project_id": project_id.stringValue]
      rwf.apiGetAssets(dict, success: { (data) -> Void in
        if (data != nil) {
          let json = JSON(data: data!)
        }
        }) { (error) -> Void in
          debugPrintln(error)
      }
    }
  }

  func rwPostStreamsSuccess(data: NSData?) {
    let json = JSON(data: data!)
    debugPrintln(json)
  }

  func rwPostStreamsFailure(error: NSError?) {
    debugPrintln(error)
  }

  func rwGetProjectsIdTagsSuccess(data: NSData?) {
    let json = JSON(data: data!)
    self.rwData?.speakTags = json["speak"].array?.map { TagGroup(json: $0) } ?? []
    self.rwData?.listenTags = json["listen"].array?.map { TagGroup(json: $0) } ?? []
  }

  func rwGetProjectsIdTagsFailure(error: NSError?) {
    debugPrintln(error)
  }

  func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    if let vc = viewController as? BaseViewController {
      vc.rwData = self.rwData
    } else if let vc = viewController as? BaseTableViewController{
      vc.rwData = self.rwData
    } else if let nav = viewController as? UINavigationController {
      if let vc = nav.topViewController as? BaseViewController {
        vc.rwData = self.rwData
      } else if let vc = viewController as? BaseTableViewController{
        vc.rwData = self.rwData
      }
    }
  }
}
