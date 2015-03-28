import UIKit
import Crashlytics
import RWFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RWFrameworkProtocol {

  var window: UIWindow?
  var rwData: RWData?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Crashlytics.startWithAPIKey("69056dd4dfd70d4a7ca049983df384d1c090537f")
    UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)

    setupRWFramework()

    return true
  }

  func setupRWFramework() {
    rwData = RWData()
    var rwf = RWFramework.sharedInstance
    rwf.addDelegate(self)
    rwf.start()
  }

  func rwUpdateStatus(message: String) {
    //debugPrintln(message)
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
