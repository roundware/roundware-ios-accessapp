//
//  ProjectModel.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation

//model
class Project {
    var name: String
    var id: String
    
    // MARK: Initialization
    
    init?(name: String, id: String) {
        self.name = name
        self.id = id
        if name.isEmpty || id.isEmpty {
            return nil
        }
    }
    
    // MARK: Class methods
    
    class func initFromPlist() -> [Project] {
        print("running init")

        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let info  = NSDictionary(contentsOfFile: path!) as! [String:AnyObject!]
        var projectsArray: [Project] = []

        guard let projectsDictArray = info["Projects"] else {
            return []
        }
        
        for project in projectsDictArray as! [[String:String]] {
            if let id = project["id"], name = project["name"] {
                if let thisProject = Project.init(name: name, id: id){
                    projectsArray.append(thisProject)
                }
            }

        }

        return projectsArray
    }
}

let sharedProjects = Project.initFromPlist()
var currentProject: Project? = nil