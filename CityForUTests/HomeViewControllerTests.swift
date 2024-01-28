//
//  HomeViewControllerTests.swift
//  CityForUTests
//
//  Created by 竹村はるうみ on 2024/01/28.
//

import XCTest
@testable import CityForU

class HomeViewControllerTests: XCTestCase {
    
    var sut: HomeViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        // HomeViewControllerをナビゲーションコントローラーに埋め込む
        let navigationController = UINavigationController(rootViewController: sut)
        navigationController.view.layoutIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFortuneButtonTapped() {
        //ボタンタップのシミュレーション
        sut.fortuneButtonTapped()
        //適切な画面遷移が行われたかどうかをテスト
        XCTAssertTrue(sut.navigationController?.topViewController is FortuneViewController)
    }
}
