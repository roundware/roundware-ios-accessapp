//
//  AppDelegate.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/23/16.
//  Copyright © 2016 Roundware. All rights reserved.
//
import UIKit
import Fabric
import RWFramework
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RWFrameworkProtocol {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        //TODO reset endpoint function
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)

        let root = self.window!.rootViewController as! RootNavigationViewController
        root.delegate = root
        root.rwData = RWData()

        let rwf = RWFramework.sharedInstance
        rwf.addDelegate(object: root)
        rwf.start(letFrameworkRequestWhenInUseAuthorizationForLocation: false)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DebugLog("APPLICATION DID BECOME ACTIVE")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DebugLog("APPLICATION DID ENTER BACKGROUND")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DebugLog("APPLICATION WILL ENTER FOREGROUND")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        DebugLog("APPLICATION WILL RESIGN ACTIVE")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DebugLog("APPLICATION WILL TERMINATE")
    }

    //TODO move to correct view controllers and integrate with UI
    override func accessibilityPerformMagicTap() -> Bool {
        DebugLog("ACCESSIBILITY PERFORM MAGIC TAP - APP DELEGATE")
        let rwf = RWFramework.sharedInstance
        if(rwf.isPlaying){
            rwf.pause()
        } else if (rwf.isPlayingBack()){
            rwf.stopPlayback()
        } else if (rwf.isRecording()){
            rwf.stopRecording()
        }
        return true
    }
}
