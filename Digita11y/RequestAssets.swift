import Foundation
import Crashlytics
import RWFramework
import SwiftyJSON

func requestAssets(completion: (assets: [Asset]) -> ()) {
    if let projectData = RWFrameworkConfig.getConfigDataFromGroup(RWFrameworkConfig.ConfigGroup.Project) as? NSDictionary {
        let rwf = RWFramework.sharedInstance
        let project_id = projectData["project_id"] as! NSNumber
        let dict: [String:String] = ["project_id": project_id.stringValue]
        rwf.apiGetAssets(dict, success: { (data) -> Void in
            if (data != nil) {
                let json = JSON(data: data!)
                let assets = json.array?.map { Asset(json: $0) } ?? []
                completion(assets: assets)
            }
            }) { (error) -> Void in
                debugPrint(error.localizedDescription)
                CLSNSLogv(error.localizedDescription, getVaList([]))
                completion(assets: [])
        }
    }
}
