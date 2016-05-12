//
//  NSURL+Query.swift
//  Digita11y
//
//  Created by Christopher Reed on 4/27/16.
//  Copyright © 2016 Roundware. All rights reserved.
//
// from https://gist.github.com/jackreichert/81a7ce9d0cefd5d1780f

import Foundation
extension NSURL {
    var queryItems: [String: String]? {
        var params = [String: String]()
        dump(self)
        dump(params)
        return NSURLComponents(URL: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], combine: { (_, item) -> [String: String] in
                params[item.name] = item.value
                dump(item.name)
                dump(item.value)
                return params
            })
    }
}
