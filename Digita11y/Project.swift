//
//  ProjectModel.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import RWFramework

struct Project {

// MARK: Initialization
    //TODO add more attributes for project, e.g.
        // startupMessage
        // reverseDomain
        // geoListenEnabled
        // listenEnabled
        // speakEnabled

    var name: String
    var id: Int
    var welcome: String
    var mapURL: String
    var active: Bool
    var reverseDomain: String
    //let tags: [Tag]

    init?(name: String, id: Int, welcome: String, active: Bool, reverseDomain: String, mapURL: String) {
        self.id = id
        self.name = name
        self.welcome = welcome
        self.mapURL = mapURL
        self.active = active
        self.reverseDomain = reverseDomain
        if name.isEmpty || welcome.isEmpty{
            return nil
        }
    }

// MARK: Static methods

    static func initFromPlist() -> [Project] {
        print("running init")

        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let info  = NSDictionary(contentsOfFile: path!) as! [String:AnyObject!]
        var projectsArray: [Project] = []

        guard let projectsDictArray = info["Projects"] else {
            return []
        }

        for project in projectsDictArray as! [[String:AnyObject]] {
            if let id = project["id"], name = project["name"], active = project["active"], reverseDomain = project["reverse_domain"], welcome = project["welcome"], mapURL = project["map_url"] {
                let idInt : Int? = Int(id as! String)
                if let thisProject = Project.init(name: name as! String, id: idInt!, welcome:welcome as! String, active: active as! Bool, reverseDomain: reverseDomain as! String, mapURL: mapURL as! String){
                    //TODO try map
                    projectsArray.append(thisProject)
                }
            }

        }
        return projectsArray
    }
}
