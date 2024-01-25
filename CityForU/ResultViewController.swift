//
//  ResultViewController.swift
//  CityForU
//
//  Created by 竹村はるうみ on 2024/01/25.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var capitalTextView: UITextView!
    @IBOutlet weak var citizenDayTextView: UITextView!
    @IBOutlet weak var hasCoastLineTextView: UITextView!
    @IBOutlet weak var explainTextView: UITextView!
    
    
    public var responseData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayResult(data: responseData ?? Data())
    }
    
    //結果を表示
    private func displayResult(data: Data) {
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
            citizenDayTextView.text = "県民の日 : \(prefecture.citizenDay?.month ?? 0)月\( prefecture.citizenDay?.day ?? 0)日"
            hasCoastLineTextView.text = "海岸線 : \(coastLine)"
            explainTextView.text = "\(prefecture.brief)"
            print("Prefecture name: \(prefecture)")
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
