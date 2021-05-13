//
//  ViewController.swift
//  SpeechSample
//
//  Created by Fumiya Tanaka on 2021/05/13.
//

import UIKit
import Speech

class ViewController: UIViewController {
    
    let speechRecognizer: SFSpeechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ja-JP"))!
    let audioEngine: AVAudioEngine = AVAudioEngine()
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SFSpeechRecognizer.requestAuthorization { status in
            print("isAuthorized: \(status == .authorized)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // セッションの有効化
        do {
            let session = AVAudioSession.sharedInstance()
            // 端末のマイクを使用できるようにする
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
            try startRecording()
        } catch {
            print(error)
        }
    }
    
    // 音声認識の開始
    func startRecording() throws {
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        // マイクの入力受信
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, time in
            self.recognitionRequest?.append(buffer)
        }
        
        // 開始
        audioEngine.prepare()
        try audioEngine.start()
        
        setupSpeech()
    }
    
    // 音声→文字の処理
    func setupSpeech() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("クラッシュ")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            
            var isFinal = false
            
            if let result = result {
                // ラベルに文字起こしの結果を表示
                self.label.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                // エラーがある or 音声認識が終了した
                
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
    }
}

