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
    
    var name: String
    var id: Int
    var welcome: String
    //let tags: [Tag]
    
    init?(name: String, id: Int, welcome: String) {
        self.name = name
        self.id = id
        self.welcome = welcome
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
            if let id = project["id"], name = project["name"], welcome = project["welcome"] {
                let idInt : Int? = Int(id as! String)
                if let thisProject = Project.init(name: name as! String, id: idInt!, welcome:welcome as! String){
                    projectsArray.append(thisProject)
                }
            }

        }
        return projectsArray
    }
}