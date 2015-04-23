import Foundation

func requestAssetText(url: String, completion: (text: String) -> ()) {
  dispatch_async(dispatch_get_main_queue()) {
    // FIX: This is kinda messed because Alamofire is included directly in the project.
    // Fix this when use_frameworks has been fixed in Cocoapods
    request(.GET, url).responseString { (_, _, string, _) in
      if let str = string {
        completion(text: str)
      }
    }
  }
}