//
//  ResultViewControllerUITests.swift
//  CityForUUITests
//
//  Created by 竹村はるうみ on 2024/01/29.
//

import XCTest

class ResultViewControllerTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
        navigateToResultViewController()
    }

    private func navigateToResultViewController() {
        let app = XCUIApplication()
        //HomeViewControllerからFortuneViewControllerへの遷移
        let fortuneButton = app.buttons["fortuneButton"]
        fortuneButton.tap()
        //名前を入力
        let nameTextField = app.textFields["textField"]
        nameTextField.tap()
        nameTextField.typeText("はるうみ")
        //次へボタンをタップ
        let nextButton = app.buttons["nextButton"]
        nextButton.tap()
        //日付を入力
        let dateTextField = app.textFields["textField"]
        dateTextField.tap()
        dateTextField.typeText("2007/05/05")
        //次へボタンをタップ
        nextButton.tap()
        //血液型を入力
        let bloodTypeTextField = app.textFields["textField"]
        bloodTypeTextField.tap()
        bloodTypeTextField.typeText("A")
        //次へボタンをタップしてResultViewControllerに遷移
        nextButton.tap()
    }
    
    func testResultDisplay() {
        let titleLabel = app.staticTexts["titleLabel"]
        let logoImageView = app.images["logoImageView"]
        let capitalTextView = app.textViews["capitalTextView"]
        let hasCoastLineTextView = app.textViews["hasCoastLineTextView"]
        let explainTextView = app.textViews["explainTextView"]
        XCTAssertTrue(titleLabel.exists)
        XCTAssertTrue(logoImageView.exists)
        XCTAssertTrue(capitalTextView.exists)
        XCTAssertTrue(hasCoastLineTextView.exists)
        XCTAssertTrue(explainTextView.exists)
    }
    
}
