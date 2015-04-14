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

  let override = isHeadsetPluggedIn() ? AVAudioSessionPortOverride.None : AVAudioSessionPortOverride.Speaker
  if !avAudioSession.overrideOutputAudioPort(override, error:&error) {
    if let e = error {
      debugPrintln(e.localizedDescription)
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

func isHeadsetPluggedIn() -> Bool {
  var route = AVAudioSession.sharedInstance().currentRoute
  for description in route.outputs {
    if description.portType == AVAudioSessionPortHeadphones {
      return true
    }
  }
  return false
}