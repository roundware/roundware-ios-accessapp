//
//  SetupAudio.swift
//  Digita11y
//
//  Created by Parveen Kaler on 2015-03-16.
//  Copyright (c) 2015 Smartful Studios Inc. All rights reserved.
//

import Foundation
import AVFoundation

func setupAudio(audioSetup: (granted: Bool, error: NSError?) -> Void) {
  var avAudioSession = AVAudioSession.sharedInstance()
  var error: NSError?

  avAudioSession.requestRecordPermission { (granted: Bool) -> Void in
    dispatch_async(dispatch_get_main_queue()) {
      audioSetup(granted: granted, error: nil)
    }
  }

  if !avAudioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error) {
    if let e = error {
      dispatch_async(dispatch_get_main_queue()) {
        audioSetup(granted: false, error: e)
      }
    }
  }

  if !avAudioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error:&error) {
    if let e = error {
      dispatch_async(dispatch_get_main_queue()) {
        audioSetup(granted: false, error: e)
      }
    }
  }

  if !avAudioSession.setActive(true, error: &error) {
    if let e = error {
      dispatch_async(dispatch_get_main_queue()) {
        audioSetup(granted: false, error: e)
      }
    }
  }
}