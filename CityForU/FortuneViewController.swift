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
    
    private var progressViewLevel: Double = 0
    
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
        //textFieldのnextボタンタップでnextボタンと同じ処理をする
        textField.addTarget(self, action: #selector(nextButtonTapped), for: .editingDidEnd)
        
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
        progressView.setProgress(Float(progressViewLevel), animated: true)
    }
    
    //nextButtonがタップされた時の処理
   @objc private func nextButtonTapped() {
       //progressViewを動かす
       progressViewLevel += 0.34
       moveProgressView(level: progressViewLevel)
       //表示を変更する
       levelChanged()
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
        switch progressViewLevel {
        case 0:
            explainLabel.text = "名前を入力してください"
        case 0.34:
            explainLabel.text = "生年月日を選択してください"
        case 0.68:
            explainLabel.text = "血液型を入力してください"
        default:
            break
        }
    }
    
}
