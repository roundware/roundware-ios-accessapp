import UIKit
import MessageUI
import Crashlytics
import RWFramework

class RootTabBarController: UITabBarController, UITabBarControllerDelegate, MFMailComposeViewControllerDelegate, RWFrameworkProtocol {
  var rwData: RWData?

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("shake"), name: "SHAKESHAKESHAKE", object: nil)
  }

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

  // MARK: - RWFrameworkProtocol

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
    requestAssets { assets in
      self.rwData?.assets = assets
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
    self.rwData?.browseTags = json["browse"].array?.map { TagGroup(json: $0) } ?? []
  }

  func rwGetProjectsIdTagsFailure(error: NSError?) {
    debugPrintln(error?.localizedDescription)
    CLSNSLogv(error?.localizedDescription, getVaList([]))
  }

  // MARK: - UITabBarControllerDelegate

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

  // MARK: - MFMailComposeViewControllerDelegate

  func shake() {
    var mc = MFMailComposeViewController()
    mc.mailComposeDelegate = self
    mc.setMessageBody(RWFramework.sharedInstance.debugInfo(), isHTML: false)
    self.presentViewController(mc, animated: true, completion: nil)
  }

  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    self.dismissViewControllerAnimated(false, completion: nil)
  }
}
