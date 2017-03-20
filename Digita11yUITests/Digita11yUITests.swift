//
//  Digita11yUITests.swift
//  Digita11yUITests
//
//  Created by Christopher Reed on 3/9/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import XCTest

class Digita11yUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProjectSelect() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        app.navigationBars["Location"].buttons["Back"].tap()
        let peabodyEssexMuseum2Of3Button = app.buttons["Peabody Essex Museum, 2 of 3"]
        peabodyEssexMuseum2Of3Button.tap()
        let beginButton = app.buttons["Begin"]
        beginButton.tap()
        app.buttons["Next"].tap()
//        app.alerts["Allow “Digita11y” to access your location while you use the app?"].buttons["Allow"].tap()
//        app.buttons["Rodin: Transforming Sculpture, 2 of 2"].tap()
//        app.scrollViews.otherElements.buttons["Clay / Plaster Process, 1 of 1"].tap()
//        app.buttons["Pause"].tap()


    }
    
}
