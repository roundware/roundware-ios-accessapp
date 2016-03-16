import Foundation
import Alamofire


//TODO use framework!
func requestAssetText(url: String, completion: (text: String) -> ()) {
    dispatch_async(dispatch_get_main_queue()) {
        // FIX: This is kinda messed because Alamofire is included directly in the project.
        // Fix this when use_frameworks has been fixed in Cocoapods
        Alamofire.request(.GET, url).responseString { response in
            if let str = response.result.value {
                completion(text: str)
            }
        }
    }
}