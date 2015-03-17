//
//  AppDelegate.swift
//  Digita11y
//
//  Created by Parveen Kaler on 2015-02-23.
//  Copyright (c) 2015 Smartful Studios Inc. All rights reserved.
//

import UIKit
import RWFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RWFrameworkProtocol {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)

    setupRWFramework()

    return true
  }

  func setupRWFramework() {
    var rwf = RWFramework.sharedInstance
    rwf.delegate = self
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

  func rwRecordingProgress(percentage: Double) {
    debugPrintln("Progress: \(percentage)")
  }

  func rwImagePickerControllerDidFinishPickingMedia(info: [NSObject : AnyObject]) {
    debugPrintln("Image: \(info)")
  }
}
