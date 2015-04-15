import UIKit
import Crashlytics
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
    CLSNSLogv(message, getVaList([]))
  }

  func rwPostUsersFailure(error: NSError?) {
    debugPrintln(error?.localizedDescription)
    CLSNSLogv(error?.localizedDescription, getVaList([]))
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
          self.rwData?.assets = json.array?.map { Asset(json: $0) } ?? []
        }
        }) { (error) -> Void in
          debugPrintln(error.localizedDescription)
          CLSNSLogv(error.localizedDescription, getVaList([]))
      }
    }
  }

  func rwPostStreamsSuccess(data: NSData?) {
    let json = JSON(data: data!)
    self.rwData?.stream = Stream(json: json)
  }

  func rwPostStreamsFailure(error: NSError?) {
    let alert = UIAlertController(title: "Stream Error", message: error?.localizedDescription, preferredStyle: .Alert)
    let ok = UIAlertAction(title: "OK", style: .Default) { action in
    }
    alert.addAction(ok)
    self.presentViewController(alert, animated: true) { }
  }

  func rwGetProjectsIdTagsSuccess(data: NSData?) {
    let json = JSON(data: data!)
    self.rwData?.speakTags = json["speak"].array?.map { TagGroup(json: $0) } ?? []
    self.rwData?.listenTags = json["listen"].array?.map { TagGroup(json: $0) } ?? []
  }

  func rwGetProjectsIdTagsFailure(error: NSError?) {
    debugPrintln(error?.localizedDescription)
    CLSNSLogv(error?.localizedDescription, getVaList([]))
  }

  func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    if let vc = viewController as? BaseViewController {
      vc.rwData = self.rwData
    } else if let vc = viewController as? BaseTableViewController {
      vc.rwData = self.rwData
    } else if let nav = viewController as? UINavigationController {
      if let vc = nav.topViewController as? BaseViewController {
        vc.rwData = self.rwData
      } else if let vc = nav.topViewController as? BaseTableViewController{
        vc.rwData = self.rwData
      }
    }
  }
}
