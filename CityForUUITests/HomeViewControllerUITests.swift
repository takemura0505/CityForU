//
//  HomeViewControllerUITests.swift
//  CityForUUITests
//
//  Created by 竹村はるうみ on 2024/01/29.
//

import XCTest

class HomeViewControllerTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testResultDisplay() {
        let fortuneButton = app.buttons["fortuneButton"]
        XCTAssertTrue(fortuneButton.exists)
    }
    
}
