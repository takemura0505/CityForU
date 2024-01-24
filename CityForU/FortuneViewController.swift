//
//  FortuneViewController.swift
//  CityForU
//
//  Created by 竹村はるうみ on 2024/01/22.
//

import UIKit

class FortuneViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction private func backButtonTapped() {
        view.endEditing(true)
        //データを保持
        saveData(level: progressLevel, data: textField.text ?? "")
        //progressViewを動かす
        progressLevel -= 0.34
        moveProgressView(level: progressLevel)
        //表示を変更する
        levelChanged()
        //textFieldが0文字であればボタンを押せなくする
        textFieldDidChange()
    }
    
    private var progressLevel: Double = 0
    private var name = ""
    private var bloodType = ""
    private var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nextButtonのUIをセット
        setButtonUI(button: nextButton)
        //スワイプでキーボード閉じる処理
        scrollView.keyboardDismissMode = .interactive
        //nextボタンタップ時の処理を追加
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        //textFieldの文字が変わったら呼び出すようにする
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        //textFieldのdelegateを有効にする
        textField.delegate = self
        //backButtonを最初は非表示にしておく
        backButton.isHidden = true
        //datePickerを設定
        setDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //キーボードの表示非表示を確認
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //キーボード通知を解除
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //キーボード表示時の処理
    @objc private func keyboardWillShow(notification: NSNotification) {
        //キーボードの高さを取得
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        //scrollViewをキーボードの高さだけ下に伸ばす
        scrollView.contentInset.bottom = keyboardHeight
    }
    
    //キーボード非表示時の処理
    @objc private func keyboardWillHide(notification: NSNotification) {
        //下の高さに戻す
        scrollView.contentInset = .zero
    }
    
    private func setButtonUI(button: UIButton) {
        //ボタンを角丸に
        button.layer.cornerRadius = button.bounds.height / 2
        //影を入れる
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 40
        button.layer.shadowColor = UIColor.systemTeal.cgColor
    }
    
    //progressViewを動かす
    private func moveProgressView(level: Double) {
        progressView.setProgress(Float(progressLevel), animated: true)
    }
    
    //nextButtonがタップされた時の処理
   @objc private func nextButtonTapped() {
       view.endEditing(true)
       //textFieldの前後の空白を削除
       let textFieldText = textField.text?.trimmingCharacters(in: .newlines) ?? ""
       //データを保持 
       saveData(level: progressLevel, data: textFieldText)
       //progressViewを動かす
       progressLevel += 0.34
       moveProgressView(level: progressLevel)
       //すべての入力が終了していればデータを送信する
       if progressLevel > 0.68 {
           sendData()
       }
       //表示を変更する
       levelChanged()
       //textFieldが0文字であればボタンを押せなくする
       textFieldDidChange()
    }
    
    //textFieldの文字が変わったら呼び出される
    @objc private func textFieldDidChange() {
        //textFieldが0文字であればボタンを押せなくする
        if textField.text?.count == 0 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    //段階ごとに表示を変更する
    private func levelChanged() {
        switch progressLevel {
        case 0:
            explainLabel.text = "名前を入力してください"
            textField.placeholder = "名前を入力"
            textField.text = name
            backButton.isHidden = true
            //datePickerを外す
            textField.inputView = nil
        case 0.34:
            explainLabel.text = "生年月日を選択してください"
            textField.placeholder = "生年月日を選択"
            backButton.isHidden = false
            //datePicker追加
            textField.inputView = datePicker
            // textFieldの初期値を設定
            updateTextFieldWithDate(date: datePicker.date)
        case 0.68:
            explainLabel.text = "血液型を入力してください"
            textField.placeholder = "血液型を入力"
            textField.text = bloodType
            //datePickerを外す
            textField.inputView = nil
        default:
            break
        }
    }
    
    //段階ごとにデータを保持
    private func saveData(level: Double, data: String) {
        switch level {
        case 0:
            
            name = data
        case 0.34:
            break
        case 0.68:
            bloodType = data
        default:
            break
        }
    }
    
    private func setDatePicker() {
        //datePicker設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.datePickerMode = .date
        //datePickerの値が変わったときに呼ばれるメソッドを設定
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        updateTextFieldWithDate(date: sender.date)
    }
    
    //textFieldの値を更新
    private func updateTextFieldWithDate(date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        textField.text = formatter.string(from: date)
    }
    
    //APIにデータを送信しレスポンスを取得
    private func sendData() {
        //URLの構築
        let baseUrl = "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud"
        let endpoint = "/my_fortune"
        guard let url = URL(string: baseUrl + endpoint) else {
            fatalError("Invalid URL")
        }
        
        //リクエストの設定
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("v1", forHTTPHeaderField: "API-Version")
        
        //現在の日付を取得
        let currentDate = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        //誕生日を取得
        let selectedDate = datePicker.date
        let birthYear = calendar.component(.year, from: selectedDate)
        let birthMonth = calendar.component(.month, from: selectedDate)
        let birthDay = calendar.component(.day, from: selectedDate)
        
        //HTTPボディの準備
        let body: [String: Any] = [
            "name": name,
            "birthday": ["year": birthYear, "month": birthMonth, "day": birthDay],
            "blood_type": bloodType,
            "today": ["year": year, "month": month, "day": day]
        ]
        
        //JSONにエンコード
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error: Unable to encode JSON")
            return
        }
        
        //リクエストの送信
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Error: HTTP Status Code \(httpResponse.statusCode)")
                return
            }
            
            if let data = data {
                //レスポンスデータの処理
                let responseData = String(data: data, encoding: .utf8) ?? ""
                print("Response: \(responseData)")
            }
        }
        task.resume()
    }
    
}

extension FortuneViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonTapped()
        textField.resignFirstResponder()
        return true
    }
    
}
