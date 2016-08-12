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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])

        //TODO reset endpoint function
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)

        let root = self.window!.rootViewController as! RootNavigationViewController
        root.delegate = root
        root.rwData = RWData()

        let rwf = RWFramework.sharedInstance
        rwf.addDelegate(root)
        rwf.start(false)

        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        DebugLog("APPLICATION DID BECOME ACTIVE")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        DebugLog("APPLICATION DID ENTER BACKGROUND")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        DebugLog("APPLICATION WILL ENTER FOREGROUND")
    }

    func applicationWillResignActive(application: UIApplication) {
        DebugLog("APPLICATION WILL RESIGN ACTIVE")
    }

    func applicationWillTerminate(application: UIApplication) {
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
