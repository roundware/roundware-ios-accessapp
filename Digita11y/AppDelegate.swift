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
        CLSNSLogv("APPLICATION DID BECOME ACTIVE", getVaList([]))
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        CLSNSLogv("APPLICATION DID ENTER BACKGROUND", getVaList([]))
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        CLSNSLogv("APPLICATION WILL ENTER FOREGROUND", getVaList([]))
    }
    
    func applicationWillResignActive(application: UIApplication) {
        CLSNSLogv("APPLICATION WILL RESIGN ACTIVE", getVaList([]))
    }
    
    func applicationWillTerminate(application: UIApplication) {
        CLSNSLogv("APPLICATION WILL TERMINATE", getVaList([]))
    }
}