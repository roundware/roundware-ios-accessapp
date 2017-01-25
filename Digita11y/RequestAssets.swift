import Foundation
import Crashlytics
import RWFramework
import SwiftyJSON

func requestAssets(_ completion: @escaping (_ assets: [Asset]) -> ()) {
    if let projectData = RWFrameworkConfig.getConfigDataFromGroup(group: RWFrameworkConfig.ConfigGroup.Project) as? NSDictionary {
        let rwf = RWFramework.sharedInstance
        let project_id = projectData["project_id"] as! NSNumber
        let dict: [String:String] = ["project_id": project_id.stringValue]
        rwf.apiGetAssets(dict: dict, success: { (data) -> Void in
            if (data != nil) {
                let json = JSON(data: data! as Data)
                let assets = json.array?.map { Asset(json: $0) } ?? []
                completion(assets)
            }
            }) { (error) -> Void in
                DebugLog(error.localizedDescription)
                completion([])
        }
    }
}
