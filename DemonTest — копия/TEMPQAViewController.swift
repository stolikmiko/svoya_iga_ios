//
//  TEMPQAViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 13.05.2021.
//

import UIKit
import Speech

class TEMPQAViewController: UIViewController {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "ru-RU"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var finalResult = String()
    
    
    
    struct QABot {
        let answerProbability: Double = Double(arc4random()) / Double(UINT32_MAX)
        let urlPath: URL = URL(string: "http://192.168.0.105:8080/model")!
        var name: String = "bot#"
        var attempt: Bool = false
        
//        mutating func urdon() {
//            self.attempt = true
//        }
        
        mutating func botAnswer(for question: String) -> String {
            var request: URLRequest = URLRequest(url: self.urlPath)
            let json: Dictionary<String, Array<String>> = ["question_raw": [question]]
            let jsonData = try! JSONSerialization.data(withJSONObject: json)
            var answer: String = String()
            
            self.attempt = true
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                answer = (responseJSON as? Array<Array<String>>)![0][0]
            }
            
            task.resume()
            return answer
        }
    }
    
    
    
    let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    let qLabel: UILabel = UILabel()
    let aLabel: UILabel = UILabel()
    let timerLabel: UILabel = UILabel()
    let answerButton: UIButton = UIButton()
    let aTextField: UITextField = UITextField()
    let voiceButton: UIButton = UIButton()
    var qTimer: Timer = Timer()
    var aTimer: Timer = Timer()
    var results: TEMPGWBViewController.GameRes = TEMPGWBViewController.GameRes()
    var qStruct: StartPackViewController.Question
    var qCountDown: Int = 30
    var aCountDown: Int = 20
    var qaBots: Array<QABot> = Array<QABot>()
    
    //MARK: - Init
    init(question: StartPackViewController.Question, bots: Int) {
        for i in 1 ... bots {
            self.qaBots.append(QABot())
            self.qaBots[i - 1].name += String(i)
        }
        self.qStruct = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.qStruct = StartPackViewController.Question()
        super.init(coder: coder)
    }
    
    //MARK: - setUp
    func setUp() {
        self.view.backgroundColor = self.bgColour
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(self.timerLabel)
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25.0).isActive = true
        self.timerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(self.qLabel)
        self.qLabel.lineBreakMode = .byWordWrapping
        self.qLabel.numberOfLines = 0
        self.qLabel.textColor = .white
        self.qLabel.translatesAutoresizingMaskIntoConstraints = false
        self.qLabel.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor, constant: 7.5).isActive = true
        self.qLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.qLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75).isActive = true
        
        self.view.addSubview(self.aLabel)
        self.aLabel.lineBreakMode = .byWordWrapping
        self.aLabel.numberOfLines = 0
        self.aLabel.translatesAutoresizingMaskIntoConstraints = false
        self.aLabel.topAnchor.constraint(equalTo: self.qLabel.bottomAnchor, constant: 7.5).isActive = true
        self.aLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.aLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75).isActive = true
        
        self.view.addSubview(self.answerButton)
        self.answerButton.translatesAutoresizingMaskIntoConstraints = false
        self.answerButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        self.answerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.answerButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        self.answerButton.setTitle("Answer", for: .normal)
        self.answerButton.layer.borderWidth = 1
        self.answerButton.layer.borderColor = UIColor.gray.cgColor
        self.answerButton.layer.cornerRadius = 7
        self.answerButton.backgroundColor = .systemGray2
        self.answerButton.isUserInteractionEnabled = false
        self.answerButton.addTarget(self, action: #selector(self.aBtnPressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.aTextField)
        self.aTextField.translatesAutoresizingMaskIntoConstraints = false
        self.aTextField.layer.borderColor = UIColor.white.cgColor
        self.aTextField.bottomAnchor.constraint(equalTo: self.answerButton.topAnchor, constant: -5.0).isActive = true
        self.aTextField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.aTextField.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        self.aTextField.attributedPlaceholder = NSAttributedString(string: "Tap button below", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.aTextField.isUserInteractionEnabled = false
        self.aTextField.textColor = .white
        self.aTextField.delegate = self
        
        self.view.addSubview(self.voiceButton)
        self.voiceButton.translatesAutoresizingMaskIntoConstraints = false
        self.voiceButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.voiceButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.voiceButton.setTitle("Voice Answer", for: .normal)
        self.voiceButton.layer.borderWidth = 1
        self.voiceButton.layer.borderColor = UIColor.gray.cgColor
        self.voiceButton.layer.cornerRadius = 7
        self.voiceButton.backgroundColor = .systemGray2
        self.voiceButton.isUserInteractionEnabled = false
        self.voiceButton.addTarget(self, action: #selector(self.voiceBtnTapped(_:)), for: .touchUpInside)
        
    }
    
    //MARK: - timerAwake
    func timerAwake(_ timerName: String) {
        switch timerName {
        case "qTimer":
            self.qTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.goBack), userInfo: nil, repeats: true)
        case "aTimer":
            self.aTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.aCountDown -= 1
                self.timerLabel.text = String(self.aCountDown)
                if self.aCountDown == 0 {
                    self.aTextField.isUserInteractionEnabled = false
                    self.aTextField.layer.borderWidth = 0
                    self.aTextField.text = ""
                    self.aTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                    self.answerButton.isUserInteractionEnabled = true
                    self.answerButton.backgroundColor = .systemGreen
                    self.timerAwake("qTimer")
                }
            }
        default:
            print("HOW???")
        }
    }
    
    //MARK: - printQ
    func printQ() {
        let q = self.qStruct.q
        Timer.scheduledTimer(withTimeInterval: 0.045, repeats: true) { timer in
            RunLoop.current.add(timer, forMode: .common)
            self.qLabel.text = String(q[q.startIndex ... q.index(q.startIndex, offsetBy: self.qLabel.text?.count ?? 0)])
            if self.qLabel.text?.count == q.count {
                timer.invalidate()
                self.timerLabel.text = String(self.qCountDown)
                self.timerLabel.textColor = .white
                self.answerButton.isUserInteractionEnabled = true
                self.answerButton.backgroundColor = .systemGreen
                self.voiceButton.isUserInteractionEnabled = true
                self.voiceButton.backgroundColor = .blue
                self.timerAwake("qTimer")
            }
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        TEMPGWBViewController(with: "", for: 0).readResults(into: &self.results)
        print(self.results)
    }
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.printQ()
    }
    
    //MARK: - goBack
    @objc
    func goBack() {
        self.qCountDown -= 1
        self.timerLabel.text = String(self.qCountDown)
        
        if self.qCountDown == 0 {
//            self.qTimer.invalidate()
//            self.aTimer.invalidate()
//            do { sleep(2) }
            TEMPGWBViewController(with: "", for: 0).writeResults(self.results)
            let tgwb = self.navigationController?.viewControllers.filter({$0 is TEMPGWBViewController}).first
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.popToViewController(tgwb!, animated: true)
        }
    }
    
    //MARK: - Answer Button Pressed
    @objc
    func aBtnPressed(_ sender: UIButton) {
        self.qTimer.invalidate()
        self.voiceButton.isUserInteractionEnabled = false
        self.voiceButton.backgroundColor = .systemGray2
        if sender.currentTitle != nil {
            self.aTextField.isUserInteractionEnabled = true
            self.aTextField.becomeFirstResponder()
            self.aTextField.layer.borderWidth = 1
            self.aTextField.attributedPlaceholder = NSAttributedString(string: "Input your answer", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
            self.aTextField.layer.borderColor = UIColor.gray.cgColor
        }
        self.answerButton.isUserInteractionEnabled = false
        self.answerButton.backgroundColor = .systemGray2
        
        self.timerAwake("aTimer")
    }
    
    //MARK: - Bots
    func bots() {
//        print("+++ bots")
//        let ans = [100: "в Сербии", 200: "в 2000 году", 300: "В 1799 году", 400: "за исследование функций главных пищеварительных желёз"]
        
        var botsAbleToAnswer = Array<QABot>()
        var abot = 0
        var botAnswer = String()
        
        self.qaBots.forEach{
            $0.answerProbability >= 0.5 ? botsAbleToAnswer.append($0) : nil
        }
        
        print(botsAbleToAnswer)
        if botsAbleToAnswer.count != 0 {
            while true {
                abot = Int((Double.random(in: 0..<Double(botsAbleToAnswer.count))).rounded(.toNearestOrAwayFromZero))
                abot == botsAbleToAnswer.count ? abot = abot - 1 : nil
                
                if !botsAbleToAnswer[abot].attempt {
//                    self.qaBots[self.qaBots.firstIndex(where: { $0 == botsAbleToAnswer[abot] })!].urdon()
                    break
                }
            }
            
            self.aBtnPressed(UIButton())
//            botAnswer = ans[self.qStruct.cost] ?? "i don't know"
            botAnswer = botsAbleToAnswer[abot].botAnswer(for: self.qStruct.q)
            self.checkAnswer(botAnswer, givenBy: botsAbleToAnswer[abot].name)
        }
    }
    
    //MARK: - checkAnswer
    func checkAnswer(_ answer: String?, givenBy participant: String) {
        self.aTimer.invalidate()
        self.aTextField.isUserInteractionEnabled = false
        self.aTextField.text = ""
        self.aTextField.attributedPlaceholder = NSAttributedString(string: "Wait for it...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        self.aLabel.text = participant + "'s answer: " + answer!
        self.aLabel.backgroundColor = .systemYellow
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.aTextField.layer.borderWidth = 0
            if answer!.lowercased() == self.qStruct.a.lowercased() {
                self.aTextField.attributedPlaceholder = NSAttributedString(string: "Yay!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                self.aLabel.backgroundColor = .systemGreen
                self.results.points[participant]! += self.qStruct.cost
                self.results.nextPlayer = participant
                self.qCountDown = 1
            } else {
                self.aLabel.backgroundColor = .systemRed
            }
            self.view.layoutIfNeeded()
            self.timerAwake("qTimer")
        }
    }
}

//MARK: - TextField Extensions
extension TEMPQAViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.checkAnswer(textField.text, givenBy: "player")
        return true
    }
}

func ==(lhs: TEMPQAViewController.QABot, rhs: TEMPQAViewController.QABot) -> Bool {
    return lhs.name == rhs.name
}

//MARK: - SFSpeechRecognizer Extensions
extension TEMPQAViewController: SFSpeechRecognizerDelegate {
    
    
    //MARK: - Voice Button Tapped
    @objc
    func voiceBtnTapped(_ sender: UIButton) {
        self.answerButton.isUserInteractionEnabled = false
        self.answerButton.backgroundColor = .systemGray2
        self.aTextField.isUserInteractionEnabled = false
        self.aTextField.textColor = .white
        
        if isRecording == true {
            print("--- stopped Recoring")
            self.cancelRecording()
            isRecording = false
            self.voiceButton.isUserInteractionEnabled = false
            self.voiceButton.backgroundColor = .systemGray2
        } else {
            self.qTimer.invalidate()
            self.timerAwake("aTimer")
            self.aTextField.attributedPlaceholder = NSAttributedString(string: "Your answer is being recorded", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            self.recordAndRecognizeSpeech()
            isRecording = true
            self.voiceButton.backgroundColor = .magenta
        }
    }
    
    //MARK: - Cancel Recording
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    //MARK: - Recognize Speech
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                if result.isFinal {
                    self.finalResult = result.bestTranscription.formattedString
                    self.checkAnswer(bestString, givenBy: "player")
                    print("--- isFinal")
                    
                }
            } else if let error = error {
                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.voiceButton.isEnabled = true
                case .denied:
                    self.voiceButton.isEnabled = false
                    self.aLabel.text = "User denied access to speech recognition"
                case .restricted:
                    self.voiceButton.isEnabled = false
                    self.aLabel.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.voiceButton.isEnabled = false
                    self.aLabel.text = "Speech recognition not yet authorized"
                @unknown default:
                    return
                }
            }
        }
    }
        
    //MARK: - UI / Set view color.
    func checkForColorsSaid(resultString: String) {
        print(resultString)
        self.finalResult = resultString
    }
        
    //MARK: - Alert
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
