//
//  QuestionsViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 15.11.2020.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    let bgColour:           UIColor                         =   UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    
    let textThemeName:      UITextField                     =   UITextField()
    
    let tableOfQuestions:   UITableView                     =   UITableView()
    
    var currentPack:        StartPackViewController.Pack    =   StartPackViewController.Pack()
    var editInfo:           StartPackViewController.Edit?    =   StartPackViewController.Edit()
    
    // MARK: - Save Function
    @objc
    func saveAndQuit(_ sender: Any?) {
        
        let origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".editingPack.json")
        let newFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentPack.packName + ".json")
        
        do {
            if FileManager.default.fileExists(atPath: newFile.path) {
                try! FileManager.default.removeItem(at: newFile)
            }
            try FileManager.default.copyItem(at: origin, to: newFile)
            
            /*
            let alert = UIAlertController(title: "Quit", message: "Package was successfully saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            */
            
            self.navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: - Get Number From Name
    func getIndex(for name: String, using pack: StartPackViewController.Pack, with editInfo: StartPackViewController.Edit) -> Int {
        let tq = pack.rounds[Int(editInfo.roundNumber)! - 1].themedQuestions
        
        for i in 0..<tq.count {
            if tq[i].theme == editInfo.themeName {
                return i
            }
        }
        return -1
    }
    
    //MARK: - Rename Theme
    func renameTheme(at index: Int, with newName: String) {
        self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[index].theme = newName
        self.editInfo!.themeName = newName
        
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
        self.title = newName
    }
    
    // MARK: - Editing Question
    func editingQuestion() {
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
        
        let designerViewController = DesignerViewController()
        
        self.navigationController?.pushViewController(designerViewController, animated: true)
    }
    
    // MARK: - Setup Function
    func setUp() {
        self.view.addSubview(self.textThemeName)
        self.view.addSubview(self.tableOfQuestions)
        
        self.textThemeName.translatesAutoresizingMaskIntoConstraints = false
        self.textThemeName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        self.textThemeName.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.textThemeName.attributedPlaceholder = NSAttributedString(string: self.editInfo!.themeName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)])
        self.textThemeName.layer.borderColor = UIColor.black.cgColor
        self.textThemeName.textAlignment = .center
        self.textThemeName.borderStyle = .roundedRect
        self.textThemeName.layer.borderWidth = 1
        self.textThemeName.delegate = self
        
        self.tableOfQuestions.translatesAutoresizingMaskIntoConstraints = false
        self.tableOfQuestions.backgroundColor = self.bgColour
        self.tableOfQuestions.topAnchor.constraint(equalTo: self.textThemeName.bottomAnchor, constant: 25.0).isActive = true
        self.tableOfQuestions.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableOfQuestions.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableOfQuestions.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.tableOfQuestions.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableOfQuestions.separatorColor = .lightGray
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Quit", style: .plain, target: self, action: #selector(saveAndQuit))
    }
    
    // MARK: - Blank Theme
    func createBlankTheme() {
        for i in 0..<5 {
            self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions.append(StartPackViewController.Question(cost: (i + 1) * 100))
        }
        
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.bgColour
        self.tableOfQuestions.dataSource = self
        self.tableOfQuestions.delegate = self
        
        RoundsViewController().readData(for: &self.currentPack, with: &self.editInfo)
        setUp()
        if self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions.isEmpty {
            createBlankTheme()
        }
        
        self.title = self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].theme
    }
    
    // MARK: - viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RoundsViewController().readData(for: &self.currentPack, with: &self.editInfo)
    }
}

// MARK: - TableView Extensions
extension QuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.editInfo!.questionNumber = String((indexPath.row + 1) * 100)
        
        self.editingQuestion()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Question cost: " + String((indexPath.row + 1) * 100)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        
        return cell
    }
}

// MARK: - TextField Extensions
extension QuestionsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return true }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { return true }
    
    func textFieldDidEndEditing(_ textField: UITextField) { }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) { }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }
    
    func textFieldDidChangeSelection(_ textField: UITextField) { }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool { return true }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        renameTheme(at: getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!), with: textField.text!)
        textField.resignFirstResponder()
        
        return true
        
    }
}

