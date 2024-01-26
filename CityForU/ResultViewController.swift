//
//  ResultViewController.swift
//  CityForU
//
//  Created by 竹村はるうみ on 2024/01/25.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak private var capitalTextView: UITextView!
    @IBOutlet weak private var citizenDayTextView: UITextView!
    @IBOutlet weak private var hasCoastLineTextView: UITextView!
    @IBOutlet weak private var explainTextView: UITextView!
    
    public var responseData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayResult(data: responseData ?? Data())
        //logoImageViewを角丸に
        logoImageView.layer.cornerRadius = 20
    }
    
    //結果を表示
    private func displayResult(data: Data) {
        print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
        //データを変換
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            //データをPrefectureに
            let prefecture = try decoder.decode(Prefecture.self, from: data)
            //海岸線があるかチェック
            let coastLine = checkCoastLine(hasCoastLine: prefecture.hasCoastLine)
            //画像を表示
            guard let url = URL(string: prefecture.logoUrl) else { return }
            DispatchQueue.main.async { [self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    logoImageView.image = image
                }
            }
            //情報を表示
            titleLabel.text = prefecture.name
            capitalTextView.text = "県庁所在地 : \(prefecture.capital)"
            // 県民の日の表示を制御
            if let citizenDay = prefecture.citizenDay {
                citizenDayTextView.isHidden = false
                citizenDayTextView.text = "県民の日 : \(citizenDay.month)月\(citizenDay.day)日"
            } else {
                citizenDayTextView.isHidden = true
            }
            hasCoastLineTextView.text = "海岸線 : \(coastLine)"
            explainTextView.text = prefecture.brief
        } catch {
            print("Decoding error: \(error)")
        }
    }
    
    //海岸線があるかどうか
    private func checkCoastLine(hasCoastLine: Bool) -> String {
        if hasCoastLine {
            return "あり"
        } else {
            return "なし"
        }
    }
    
}
