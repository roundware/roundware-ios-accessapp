import Foundation
import AVFoundation

func setupAudio(audioSetup: (granted: Bool, error: NSError?) -> Void) {
    let avAudioSession = AVAudioSession.sharedInstance()
    var error: NSError?
    
    avAudioSession.requestRecordPermission { (granted: Bool) -> Void in
        dispatch_async(dispatch_get_main_queue()) {
            audioSetup(granted: granted, error: nil)
        }
    }
    
    // Play and record for VOIP
    do {
        try avAudioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
    } catch let error1 as NSError {
        error = error1
        print("AppDelegate: could not set session category")
        if let e = error {
            print(e.localizedDescription)
            dispatch_async(dispatch_get_main_queue()) {
                audioSetup(granted: false, error: e)
            }
        }
    }
    
    let override = (TARGET_IPHONE_SIMULATOR == 1 || isHeadsetPluggedIn()) ? AVAudioSessionPortOverride.None : AVAudioSessionPortOverride.Speaker
    
    // Send audio to the speaker
    do {
        try avAudioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
    } catch let error1 as NSError {
        error = error1
        print("AppDelegate: could not overide output audio port")
        if let e = error {
            print(e.localizedDescription)
        }
    }
    
    
    // Activiate the AVAudioSession
    do {
        try avAudioSession.setActive(true)
    } catch let error1 as NSError {
        error = error1
        print("AppDelegate: could not make session active")
        if let e = error {
            print(e.localizedDescription)
        }
    }

}

func isHeadsetPluggedIn() -> Bool {
    let route = AVAudioSession.sharedInstance().currentRoute
    for description in route.outputs {
        if description.portType == AVAudioSessionPortHeadphones {
            return true
        }
    }
    return false
}