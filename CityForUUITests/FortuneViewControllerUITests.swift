//
//  FortuneViewControllerUITests.swift
//  CityForUUITests
//
//  Created by 竹村はるうみ on 2024/01/28.
//

import XCTest

class ResultViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        navigateToFortuneViewController()
    }
    
    private func navigateToFortuneViewController() {
        app.buttons["fortuneButton"].tap()
    }
    
    func testResultDisplay() {
        let textField = app.textFields["textField"]
        let nextButton = app.buttons["nextButton"]
        let backButton = app.buttons["backButton"]
        let bloodWarnLabel = app.staticTexts["bloodWarnLabel"]
        XCTAssertTrue(textField.exists)
        XCTAssertTrue(nextButton.exists)
        XCTAssertFalse(backButton.exists)
        XCTAssertFalse(bloodWarnLabel.exists)
    }
    
}
