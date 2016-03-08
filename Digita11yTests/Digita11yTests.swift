//
//  Digita11yTests.swift
//  Digita11yTests
//
//  Created by Christopher Reed on 3/2/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import XCTest
@testable import Digita11y

class Digita11yTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProjectInit(){
        let project = Project.init(name: "Baltimore Museum of Art", id: "asdf1234")
        assert(project != nil, "Project should init")
    }
    
    func testProjectInitFromPlist() {
        let projects: [Project] = Project.initFromPlist()
        assert(projects.count > 0, "Projects should instantiate from Info.plist")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
