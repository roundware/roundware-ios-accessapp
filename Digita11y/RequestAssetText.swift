import Foundation
import Alamofire


//TODO use framework!
func requestAssetText(_ url: String, completion: @escaping (_ text: String) -> ()) {
    DispatchQueue.main.async {
        Alamofire.request(url).responseString { response in
            if let str = response.result.value {
                completion(str)
            }
        }
    }
}
