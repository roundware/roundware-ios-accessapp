import Foundation
import AVFoundation

func setupAudio(_ audioSetup: @escaping (_ granted: Bool, _ error: NSError?) -> Void) {
    let avAudioSession = AVAudioSession.sharedInstance()
    var error: NSError?

    avAudioSession.requestRecordPermission { (granted: Bool) -> Void in
        DispatchQueue.main.async {
            audioSetup(granted, nil)
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
            DispatchQueue.main.async {
                audioSetup(false, e)
            }
        }
    }

    _ = (TARGET_IPHONE_SIMULATOR == 1 || isHeadsetPluggedIn()) ? AVAudioSessionPortOverride.none : AVAudioSessionPortOverride.speaker

    // Send audio to the speaker
    do {
        try avAudioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
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
