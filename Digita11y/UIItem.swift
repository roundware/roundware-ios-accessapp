//
//  UIItem.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/23/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UIItem {
    var index: Int = 0
    var parent: Int = 0
    var defaultSelection: Bool = false
    var tagId: Int = 0
    var active: Bool = true
    var id: Int = 0
    //TODO same as active?
    var contributed: Bool = false


    init(json: JSON) {
        index = json["index"].int ?? 0
        parent = json["parent"].int ?? 0
        defaultSelection = json["default"].bool ?? false
        tagId = json["tag"].int ?? 0
        active = json["active"].bool ?? false
        id = json["id"].int ?? 0
    }

}
