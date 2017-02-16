import Foundation
import RWFramework
import SwiftyJSON


//not used
struct TagGroup {
    var select: String = ""
    var order: Int = 0
    var code: String = ""
    var headerText: String = ""
    var name: String = ""
    var options: [Tag] = []
    var defaultTags: [Int] = []

    init(json: JSON) {
        select = json["select"].string ?? ""
        order = json["order"].int ?? 0
        code = json["code"].string ?? ""
        headerText = json["header_text"].string ?? ""
        name = json["name"].string ?? ""
        defaultTags = json["defaults"].array?.map { $0.int ?? 0 } ?? []
        options = json["options"].array?.map { Tag(json: $0) } ?? []
    }

    init(headerText: String, options: [Tag]) {
        self.headerText = headerText
        self.options = options
    }
}
