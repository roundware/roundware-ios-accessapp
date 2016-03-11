//
//  ProjectModel.swift
//  Digita11y
//
//  Created by Christopher Reed on 2/29/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import RWFramework

class Project {
    static var sharedInstance = Project(name: "", id: "", welcome: "")
    static let availableProjects = Project.initFromPlist()
    
// MARK: Initialization
    
    var name: String
    var id: String
    var welcome: String
    //let tags: [Tag]
    
    init?(name: String, id: String, welcome: String) {
        self.name = name
        self.id = id
        self.welcome = welcome
        if name.isEmpty || id.isEmpty || welcome.isEmpty{
            return nil
        }
    }

    func getTags(){
    }
    

    func initFromServer() {
        
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
            if let id = project["id"], name = project["name"], welcome = project["welcome"] {
                if let thisProject = Project.init(name: name, id: id, welcome:welcome){
                    projectsArray.append(thisProject)
                }
            }

        }
        return projectsArray
    }
}

