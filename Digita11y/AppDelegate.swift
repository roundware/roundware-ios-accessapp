import UIKit
import Crashlytics
import RWFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RWFrameworkProtocol {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Crashlytics.startWithAPIKey("69056dd4dfd70d4a7ca049983df384d1c090537f")
    UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)

    setupRWFramework()

    return true
  }

  func setupRWFramework() {
    var root = self.window!.rootViewController as! RootTabBarController
    root.delegate = root
    root.rwData = RWData()

    var rwf = RWFramework.sharedInstance
    rwf.addDelegate(root)
    rwf.start()
  }
}
