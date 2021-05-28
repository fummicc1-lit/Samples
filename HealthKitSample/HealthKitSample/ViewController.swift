//
//  ViewController.swift
//  HealthKitSample
//
//  Created by Fumiya Tanaka on 2021/05/13.
//

import UIKit
import HealthKit
import HealthKitUI

class ViewController: UIViewController {
    
    // データストア
    let store = HKHealthStore()
    
    // クエリ
    var query: HKQuery?
    
    let ringView: HKActivityRingView = HKActivityRingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ringView)
        requestAccess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ringView.center = view.center
        ringView.bounds.size = CGSize(width: 320, height: 320)
    }
    
    @IBAction func show() {
        // 3日間のワークアウト
        let calendar = Calendar.current
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let day = components.day ?? 0
        components.day = day - 3
        components.calendar = calendar
        
        // 取得するデータの設定
        // データの記録時間: 開始と終わりの指定
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        
        if let query = query {
            store.stop(query)
        }
        
        // クエリ
        let query = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
            // クエリが実行された時に呼ばれる。
            if let error = error {
                print("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                guard let summaries = summaries, let summary = summaries.first else {
                    return
                }
                self.ringView.setActivitySummary(summary, animated: true)
            }
        }
        // クエリの開始
        store.execute(query)
        self.query = query
    }
    
    func requestAccess() {
        // 取得したいデータの種類
        let read: Set<HKObjectType> = Set([
            HKObjectType.activitySummaryType()
        ])
        // アクセス許可を取る
        store.requestAuthorization(toShare: [], read: read) { success, error in
            if success {
                print("Success")
            }
            if error != nil {
                print("Error")
            }
        }
    }
}

