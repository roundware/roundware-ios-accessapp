//
//  ReadViewModel.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
class ReadViewModel: BaseViewModel  {
    let data: RWData
    let tag: Tag
    let assets: [Asset]
    let prompt: String
    var response: String

    init(data: RWData) {
        self.data = data
        //set room tags
        tag = data.getTagForIndexAndMode(3, mode: "listen")!
        prompt = tag.locMsg
//        debugPrint("prompt is \(tag.locMsg)")
        assets = data.getAssetsForTagIdOfMediaType(tag.id, mediaType: .Text)
        response = ""
        //TODO render as separate ui items
        for (i, asset) in assets.enumerate() {
            if let resp = asset.text{
                response += resp + "\n\n"
            }
        }
    }
}
