//
//  ViewController.swift
//  LocalAuthenticationSample
//
//  Created by Fumiya Tanaka on 2021/05/13.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 生体認証が使用できるかをチェックする
        let context = LAContext()
        var error: NSError? = nil
        
        let result = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if (error != nil) || !result {
            // 生体認証が使えない
            resultLabel.text = "生体認証が使えません"
        } else {
            startBiometricsAuthentication()
        }
    }
    
    // 生体認証の実行
    func startBiometricsAuthentication() {
        let context = LAContext()
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "authenticate") { (success, evaluateError) in
            DispatchQueue.main.async {
                if success {
                    self.resultLabel.text = "生体認証: 成功"
                } else {
                    self.resultLabel.text = "生体認証: 失敗"
                }
            }
        }
    }
    
}

