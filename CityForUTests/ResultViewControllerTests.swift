//
//  ResultViewControllerTests.swift
//  CityForUTests
//
//  Created by 竹村はるうみ on 2024/01/28.
//

import XCTest
@testable import CityForU

class ResultViewControllerTests: XCTestCase {

    var sut: ResultViewController!

    override func setUp() {
        super.setUp()
        //StoryboardからResultViewControllerのインスタンスを生成
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    //displayResult(data:)メソッドのテスト
    func testDisplayResult() {
        //JSONデータの文字列
        let jsonObject: [String: Any] = [
            "name": "富山県",
            "brief": "富山県（とやまけん）は、日本の中部地方に位置する県。県庁所在地は富山市。\n中部地方の日本海側、新潟県を含めた場合の北陸地方のほぼ中央にある。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』",
            "capital": "富山市",
            "citizen_day": [
                "month": 5,
                "day": 9
            ],
            "has_coast_line": true,
            "logo_url": "https://japan-map.com/wp-content/uploads/toyama.png"
        ]
        //jsonデータ作成
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        //メソッドを実行
        sut.displayResult(data: jsonData)
        //結果がUIコンポーネントに反映されているか確認
        XCTAssertEqual(sut.titleLabel.text, "富山県")
        XCTAssertEqual(sut.capitalTextView.text, "県庁所在地 : 富山市")
        XCTAssertEqual(sut.citizenDayTextView.text, "県民の日 : 5月9日")
        XCTAssertEqual(sut.hasCoastLineTextView.text, "海岸線 : あり")
        XCTAssertEqual(sut.explainTextView.text, "富山県（とやまけん）は、日本の中部地方に位置する県。県庁所在地は富山市。\n中部地方の日本海側、新潟県を含めた場合の北陸地方のほぼ中央にある。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』")
    }
    
    //checkCoastLine(hasCoastLine:)メソッドのテスト
    func testCheckCoastLine() {
        XCTAssertEqual(sut.checkCoastLine(hasCoastLine: true), "あり")
        XCTAssertEqual(sut.checkCoastLine(hasCoastLine: false), "なし")
    }

    //displayImage(fromURL:)メソッドのテスト
    func testDisplayImage() {
        let expectation = self.expectation(description: "Image Download")
        //有効な画像URLを設定
        let validImageUrl = "https://japan-map.com/wp-content/uploads/toyama.png"
        //メソッドを実行
        sut.displayImage(fromURL: validImageUrl)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.sut.logoImageView.image)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
