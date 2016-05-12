import Foundation
import SwiftyJSON

struct Tag {
    var id: Int = 0
    var relationships: [String:AnyObject?]
    var value: String = ""
    var description: String = ""
    var data: String = ""
    var tagCategory: Int = 0

    init(json: JSON) {
        id = json["id"].int ?? 0
        relationships = json["relationships"].dictionaryObject ?? [:]
        value = json["value"].string ?? ""
        description = json["description"].string ?? ""
        data = json["data"].string ?? ""
        tagCategory = json["tagCategory"].int ?? 0
    }
}
