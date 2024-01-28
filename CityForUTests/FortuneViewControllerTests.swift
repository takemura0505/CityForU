//
//  FortuneViewControllerTests.swift
//  CityForUTests
//
//  Created by 竹村はるうみ on 2024/01/28.
//

import XCTest
@testable import CityForU

class FortuneViewControllerTests: XCTestCase {
    
    var sut: FortuneViewController!
    
    override func setUp() {
        super.setUp()
        //StoryboardからFortuneViewControllerのインスタンスを生成
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "FortuneViewController") as? FortuneViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testNextButtonTapped() {
        //初期状態の確認
        XCTAssertEqual(sut.progressLevel, 0)
        //nextButtonのアクションをシミュレート
        sut.nextButton.sendActions(for: .touchUpInside)
        //progressLevelが更新されたか確認
        XCTAssertEqual(sut.progressLevel, 0.34)
    }
    
    func testBackButtonTapped() {
        //nextButtonをタップしてprogressLevelを0.34に更新
        sut.nextButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(sut.progressLevel, 0.34)
        //backButtonのアクションをシミュレート
        sut.backButton.sendActions(for: .touchUpInside)
        //progressLevelが更新されたか確認
        XCTAssertEqual(sut.progressLevel, 0)
    }
    
    // 有効な血液型のテスト
    func testCheckBloodType_Valid() {
        XCTAssertTrue(sut.checkBloodType(bloodType: "a"))
        XCTAssertTrue(sut.checkBloodType(bloodType: "b"))
        XCTAssertTrue(sut.checkBloodType(bloodType: "o"))
        XCTAssertTrue(sut.checkBloodType(bloodType: "ab"))
    }
    
    //無効な血液型のテスト
    func testCheckBloodType_Invalid() {
        XCTAssertFalse(sut.checkBloodType(bloodType: "C"))
        XCTAssertFalse(sut.checkBloodType(bloodType: "z"))
        XCTAssertFalse(sut.checkBloodType(bloodType: "1"))
        XCTAssertFalse(sut.checkBloodType(bloodType: ""))
    }
}
