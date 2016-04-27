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
    let response: String
    
    init(data: RWData) {
        self.data = data
        //set room tags
        tag = data.getTagForIndexAndMode(2, mode: "listen")!
        prompt = tag.value
        assets = data.getAssetsForTagIdOfMediaType(tag.id, mediaType: .Text)
        response = assets.first!.assetDescription
    }
}