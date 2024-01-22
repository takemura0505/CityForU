//
//  HomeViewController.swift
//  CityForU
//
//  Created by 竹村はるうみ on 2024/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var fortuneButton: UIButton!
    
    @IBAction private func fortuneButtonTapped() {
        //占う画面へ遷移
        let fortuneVC = storyboard?.instantiateViewController(withIdentifier: "FortuneViewController") as! FortuneViewController
        navigationController?.pushViewController(fortuneVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fortuneButtonのUIをセット
        setButtonUI(button: fortuneButton)
        //navigationBarのbackボタンの文字を非表示
        navigationItem.backButtonTitle = ""
        //navigationBarのbackボタンの色をlabelColorに変更
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setButtonUI(button: UIButton) {
        //ボタンを角丸に
        button.layer.cornerRadius = button.bounds.height / 2
        //影を入れる
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 40
        button.layer.shadowColor = UIColor.systemTeal.cgColor
    }
    
}
