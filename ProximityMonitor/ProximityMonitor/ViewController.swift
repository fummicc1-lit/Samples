//
//  ViewController.swift
//  ProximityMonitor
//
//  Created by Fumiya Tanaka on 2021/05/13.
//

import UIKit

class ViewController: UIViewController {

    // 近接センサーがONになった数を数える
    var count: Int = 0
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 近接センサーの有効化
        UIDevice.current.isProximityMonitoringEnabled = true
        
        // 近接センサーのON-Offが切り替わる通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(proximityMonitorStateDidChange),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil
        )
    }
    
    // 近接センサーのON-Offが切り替わると実行される
    @objc func proximityMonitorStateDidChange() {
        let proximityState = UIDevice.current.proximityState
        
        if proximityState {
            count += 1
            countLabel.text = String(count)
        }
    }
}

