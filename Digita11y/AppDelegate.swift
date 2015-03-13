//
//  AppDelegate.swift
//  Digita11y
//
//  Created by Parveen Kaler on 2015-02-23.
//  Copyright (c) 2015 Roundware. All rights reserved.
//

import UIKit
import AVFoundation
import RWFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RWFrameworkProtocol {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)

    setupAudio()
    setupRWFramework()

    return true
  }

  func setupAudio() {
    var avAudioSession = AVAudioSession.sharedInstance()
    var error: NSError?

    avAudioSession.requestRecordPermission { (granted: Bool) -> Void in
      debugPrintln("Audio permission: \(granted)")
    }

    if !avAudioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error) {
      debugPrintln("Audio session category not set")
      if let e = error {
        debugPrintln(e.localizedDescription)
      }
    }

    if !avAudioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error:&error) {
      debugPrintln("Audio port not overriden")
      if let e = error {
        debugPrintln(e.localizedDescription)
      }
    }

    if !avAudioSession.setActive(true, error: &error) {
      debugPrintln("Audio session not active")
      if let e = error {
        debugPrintln(e.localizedDescription)
      }
    }
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

}
