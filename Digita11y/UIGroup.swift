//
//  UIGroup.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/23/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UIGroup {
    var index: Int = 0
    var name: String = ""
    var project: Int = 0
    var uiMode: String = "listen"
    var active: Bool = false
    var tagCategory: Int = 0
    var select: String = "single"
    var headerTextLoc: String = ""
    var uiItems: [UIItem]
    var selectedUIItem: UIItem?

    init(json: JSON) {
        index = json["index"].int ?? 0
        name = json["name"].string ?? ""
        project = json["project"].int ?? 0
        uiMode = json["ui_mode"].string ?? "listen"
        active = json["active"].bool ?? false
        tagCategory = json["tag_category"].int ?? 0
        select = json["select"].string ?? "single"
        headerTextLoc = json["header_text_loc"].string ?? ""
        uiItems = json["ui_items"].array?.map { UIItem(json: $0) } ?? []
    }
}
