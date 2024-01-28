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
    @IBOutlet weak private var mapButton: UIButton!
    // 隠すビューの高さを保持する制約
    @IBOutlet weak private var citizenDayHeight: NSLayoutConstraint!
    
    public var responseData: Data?
    private var prefecture: Prefecture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //結果を表示
        displayResult(data: responseData ?? Data())
        //UIをセットアップ
        setupUI()
        //動作をセットアップ
        setupActions()
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
            //prefectureをコピー
            self.prefecture = prefecture
            //海岸線があるかチェック
            let coastLine = checkCoastLine(hasCoastLine: prefecture.hasCoastLine)
            //画像を表示
            displayImage(fromURL: prefecture.logoUrl)
            //情報を表示
            titleLabel.text = prefecture.name
            capitalTextView.text = "県庁所在地 : \(prefecture.capital)"
            // 県民の日の表示を制御
            if let citizenDay = prefecture.citizenDay {
                showCitizenDayTextView(month: prefecture.citizenDay?.month ?? 0, day: prefecture.citizenDay?.day ?? 0)
            } else {
                hideCitizenDayTextView()
            }
            hasCoastLineTextView.text = "海岸線 : \(coastLine)"
            explainTextView.text = prefecture.brief
        } catch {
            print("Decoding error: \(error)")
        }
    }
    
    //海岸線があるかどうか
    private func checkCoastLine(hasCoastLine: Bool) -> String {
        return hasCoastLine ? "あり" : "なし"
    }
    
    private func addRightBarButton() {
        // バーボタンアイテムの作成
        let rightBarButton = UIBarButtonItem(title: "終了", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        // ナビゲーションアイテムにバーボタンアイテムを設定
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func rightBarButtonTapped() {
        //最初の画面に戻る
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count >= 3 {
                //2つ前のビューコントローラーに戻る
                navigationController.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
    }
    
    // 画像を表示
    private func displayImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.logoImageView.image = image
                }
            }
        }
    }
    
    // 県民の日のテキストを表示
    private func showCitizenDayTextView(month: Int, day: Int) {
        citizenDayTextView.isHidden = false
        citizenDayTextView.text = "県民の日 : \(month)月\(day)日"
    }
    
    // 県民の日のテキストを非表示
    private func hideCitizenDayTextView() {
        citizenDayTextView.isHidden = true
        citizenDayHeight.constant = 0
        view.layoutIfNeeded()
    }
    
    //マップを開いて都道府県を表示
    @objc private func openMap() {
        //地名をURLエンコードする
        let locationName = prefecture?.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        //MapsアプリのURLスキームを使用して地図を開く
        if let url = URL(string: "http://maps.apple.com/?q=\(locationName)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func setupUI() {
        //logoImageViewを角丸に
        logoImageView.layer.cornerRadius = 20
        //rightBarButtonを追加
        addRightBarButton()
        //戻るボタンを消す
        navigationItem.hidesBackButton = true
    }
    
    private func setupActions() {
        //タップしてマップに飛べるようにする
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMap)))
        mapButton.addTarget(self, action: #selector(openMap), for: .touchUpInside)
    }
    
}
