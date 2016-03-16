import Foundation
import RWFramework
import SwiftyJSON

struct Tag {
    var tagId: Int = 0
    var shortcode: String = ""
    var localDescription: String = ""
    var order: Int = 0
    var value: String = ""
    var tagDescription: String = ""
    var headerImageURL: String = ""
    
    init(json: JSON) {
        tagId = json["tag_id"].int ?? 0
        shortcode = json["shortcode"].string ?? ""
        localDescription = json["loc_description"].string ?? ""
        order = json["order"].int ?? 0
        value = json["value"].string ?? ""
        tagDescription = json["description"].string ?? ""
        
        // FIX: "data" is eventually going to change from a string to a dictionary
        headerImageURL = json["data"].string ?? ""
    }
    
    init(tagId: Int, value: String) {
        self.tagId = tagId
        self.value = value
    }
}
