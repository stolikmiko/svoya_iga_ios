//
//  StartPackViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 15.11.2020.
//

import UIKit

class StartPackViewController: UIViewController, UITextFieldDelegate {
    enum QuestionDataType: Int, Codable {
        case text
        case audio
        case picture
        case video
    }
    enum QuestionType : Int, Codable {
        case regular
        case auction
        case cat
        case bagcat
        case sponsored
    }
    struct Question: Codable {
        var cost: Int = 100
        var q: String = "No Question Given"
        var a: String = "No Answer Given"
        var wrong: String = " No Wrong Answers Given"
        var qdatatype: QuestionDataType = .text
        var qtype: QuestionType = .regular
    }

    struct ThemedQuestions: Codable {
        var theme:  String  =   "No Theme Given"
        var questions:  Array<Question> =   [Question]()
    }
    
    struct Round: Codable {
        var number:             Int                     =   0
        var themedQuestions:    Array<ThemedQuestions>  =   [ThemedQuestions]()
    }
    
    struct Pack: Codable {
//        var qPerRAmount:    String          =   "No Questions Per Round Given"
        var rounds:         Array<Round>    =   [Round]()
        var packName:       String          =   "No Name Given"
    }
    
    struct Edit: Codable {
        var roundNumber:    String  =   "None"
        var themeName:      String  =   "None"
        var questionNumber: String  =   "None"
    }
    
    // ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    let tap:                    UITapGestureRecognizer  =   UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    
    let bgColour:               UIColor                 =   UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    
    let niceBlue:               UIColor                 =   UIColor.init(red: 92/255, green: 98/255, blue: 167/255, alpha: 1)
    let nicePink:               UIColor                 =   UIColor.init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
    
    let labelName:              UILabel                 =   UILabel()
//    let labelQPerR:             UILabel                 =   UILabel()
    
    let textName:               UITextField             =   UITextField()
//    let textQPerR:              UITextField             =   UITextField()
    
    let buttonContinue:         UIButton                =   UIButton()
    
    let forbiddenCharacters:    String                  =   "#%&{}\\<>*?/$!'\":@+=|`"
    
    var currentPack:            Pack                    =   Pack()
    
    let tableOfPacks:           UITableView             =   UITableView()
    
    var arrayOfPacks:           Array<String>           =   [String]()
    
    let buttonPersonalArea:     UIButton                =   UIButton()
    
    let buttonSettings:         UIButton                =   UIButton()
    
    let labelOr:                UILabel                 =   UILabel()
    
    
    
    // MARK: - Rewrite Current Pack Data
    func rewriteCurrentPack(using currentPack: Pack, with edit: Edit = Edit(), toFile filename: String = ".editingPack.json") {
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        print(file)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try! encoder.encode(currentPack)
        var jsonFull = jsonData
        
        if filename == ".editingPack.json" {
            let jsonEdit = try! encoder.encode(edit)
            jsonFull += jsonEdit
        }
        do {
            try jsonFull.write(to: file, options: .atomic)
        } catch {
            let wentWrong = UIAlertController(title: "Oops!", message: "Something went wrong. Pack Could not be created", preferredStyle: .alert)
            
            wentWrong.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(wentWrong, animated: true)
        }
    }
    
    // MARK: - Delete Pack Function
    func deletePack(at index: Int) {
        let files = try! FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
        
        for file in files {
            if String(file.lastPathComponent) == self.arrayOfPacks[index] + ".json" {
                try! FileManager.default.removeItem(at: file)
                self.arrayOfPacks.remove(at: index)
                return
            }
        }
    }
    
    // MARK: - Hide Keyboard
    @objc
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Check If Exists
    func checkExistance(of pack: String) {
        if self.arrayOfPacks.contains(pack) {
            let title = "Pack already exists"
            let message = ""
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New", style: .destructive, handler: { _ in
                self.deletePack(at: self.arrayOfPacks.firstIndex(of: pack)!)
                
                self.rewriteCurrentPack(using: self.currentPack)
                let  roundsViewController = RoundsViewController()
                self.textName.text = ""
                self.navigationController?.pushViewController(roundsViewController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                let origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".editingPack.json")
                let newFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(pack + ".json")
                
                do {
                    if FileManager.default.fileExists(atPath: origin.path) {
                        try! FileManager.default.removeItem(at: origin)
                    }
                    try FileManager.default.copyItem(at: newFile, to: origin)
                } catch let error as NSError {
                    print(error)
                }
                
                let  roundsViewController = RoundsViewController()
                self.textName.text = ""
                self.navigationController?.pushViewController(roundsViewController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            self.rewriteCurrentPack(using: self.currentPack)
            let  roundsViewController = RoundsViewController()
            self.textName.text = ""
            self.navigationController?.pushViewController(roundsViewController, animated: true)
        }
    }
    // MARK: - Target Settings
    @objc func buttonSettingsTap(_ sender: UIButton){
        let settingsVC = SettingsVC()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    // MARK: - Target Personal Area
    @objc
    func buttonPersonalAreaTap(_ sender: UIButton) {
        let personalAreaViewController = PersonalAreaViewController()
        self.navigationController?.pushViewController(personalAreaViewController, animated: true)
    
    }
    
    // MARK: - Continue Button Function
    @objc
    func continueOnTap(_ sender: Any?) {
        var enableAlert: Bool  = false
        print(type(of: sender!))
        
        if sender! is UIButton {
            [
                self.currentPack.packName,
    //            self.currentPack.qPerRAmount,
            ].forEach({
                if $0.hasSuffix(" Given") || $0.hasPrefix(".") {
                    enableAlert = true
                }
            })
            
            if let _ = self.currentPack.packName.rangeOfCharacter(from: CharacterSet(charactersIn: self.forbiddenCharacters)) {
                enableAlert = true
            }
            
    //        if Int(self.currentPack.qPerRAmount) == nil {
    //            enableAlert = true
    //        }
            
            if enableAlert {
                let title = "Check fields"
                let message = "Oops!\nSomething is not right"  // Some fields are not fullfilled or have unacceptable data\n\nNote: pack's name must not contain following characters:\n\(self.forbiddenCharacters)"
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            } else {
                //createPack()
                self.checkExistance(of: self.currentPack.packName)
            }
        } else {
            let  roundsViewController = RoundsViewController()
            self.textName.text = ""
            self.navigationController?.pushViewController(roundsViewController, animated: true)
        }
    }
    
    // MARK: - Setup Layout Function
    func setUp() {
        self.view.backgroundColor = self.bgColour
        
        [
            self.labelName,
//            self.labelQPerR,
            self.textName,
//            self.textQPerR,
            self.buttonContinue,
            self.tableOfPacks,
            self.buttonPersonalArea,
            self.buttonSettings,
            self.labelOr
        ].forEach({
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        //MARK: - Settings button
        self.buttonSettings.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        self.buttonSettings.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.buttonSettings.setImage(UIImage(named: "/Users/olik_adm/Downloads/SettingsIcon1x.png"), for: .normal)
        self.buttonSettings.addTarget(self, action: #selector(buttonSettingsTap), for: .touchUpInside)
        
        //MARK: - PersonalArea button
        self.buttonPersonalArea.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        self.buttonPersonalArea.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.buttonPersonalArea.setImage(UIImage(named: "/Users/olik_adm/Downloads/PersonalAreaIcon1x.png"), for: .normal)
        self.buttonPersonalArea.addTarget(self, action: #selector(buttonPersonalAreaTap), for: .touchUpInside)
        
        // MARK: - Label Name
        self.labelName.attributedText = NSAttributedString(string: "Введите название нового пака", attributes: [NSAttributedString.Key.foregroundColor: nicePink])
        self.labelName.topAnchor.constraint(equalTo: self.buttonSettings.bottomAnchor, constant: 30).isActive = true
        self.labelName.leftAnchor.constraint(equalTo: self.buttonSettings.leftAnchor).isActive = true
        self.labelName.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        self.labelName.font = UIFont(name: "Helvetica", size: 20)
        
        // MARK: - textfield Name
        self.textName.topAnchor.constraint(equalTo: self.labelName.bottomAnchor, constant: 10.0).isActive = true
        self.textName.leftAnchor.constraint(equalTo: self.buttonSettings.leftAnchor).isActive = true
        self.textName.rightAnchor.constraint(equalTo: self.buttonPersonalArea.rightAnchor).isActive = true
        self.textName.attributedPlaceholder = NSAttributedString(string: "Input pack's name here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)])
        self.textName.layer.backgroundColor = niceBlue.cgColor
        self.textName.layer.borderColor = UIColor.black.cgColor
        self.textName.textAlignment = .center
        self.textName.borderStyle = .roundedRect
        self.textName.layer.borderWidth = 1
        self.textName.delegate = self
        
        
//        self.labelQPerR.attributedText = NSAttributedString(string: "Количество вопросов в раунде", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//
//        self.labelQPerR.topAnchor.constraint(equalTo: self.textName.bottomAnchor, constant: 15.0).isActive = true
//        self.labelQPerR.centerXAnchor.constraint(equalTo: self.textName.centerXAnchor).isActive = true
//        labelQPerR.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
//        labelQPerR.font = UIFont(name: "Helvetica", size: 20)
//
//
//        self.textQPerR.topAnchor.constraint(equalTo: self.labelQPerR.bottomAnchor, constant: 10.0).isActive = true
//        self.textQPerR.centerXAnchor.constraint(equalTo: self.labelQPerR.centerXAnchor).isActive = true
//        self.textQPerR.attributedPlaceholder = NSAttributedString(string: "Input amount of questions per round here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)])
//        self.textQPerR.layer.borderColor = UIColor.black.cgColor
//        self.textQPerR.textAlignment = .center
//        self.textQPerR.borderStyle = .roundedRect
//        self.textQPerR.layer.borderWidth = 1
//        self.textQPerR.delegate = self
        
        
        self.buttonContinue.isUserInteractionEnabled = true
        self.buttonContinue.topAnchor.constraint(equalTo: self.textName.bottomAnchor, constant: 20.0).isActive = true
        self.buttonContinue.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.buttonContinue.leftAnchor.constraint(equalTo: self.buttonSettings.leftAnchor).isActive = true
        self.buttonContinue.rightAnchor.constraint(equalTo: self.buttonPersonalArea.rightAnchor).isActive = true
        self.buttonContinue.setTitle(" Создать пак ", for: .normal)
        self.buttonContinue.layer.borderWidth = 2
        self.buttonContinue.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        self.buttonContinue.layer.borderColor = UIColor.white.cgColor
        self.buttonContinue.backgroundColor = self.bgColour
        
        self.buttonContinue.addTarget(self, action: #selector(continueOnTap), for: .touchUpInside)
        
        // MARK: - label Or
        self.labelOr.topAnchor.constraint(equalTo: self.buttonContinue.bottomAnchor, constant: 50).isActive = true
        self.labelOr.leftAnchor.constraint(equalTo: self.buttonSettings.leftAnchor).isActive = true
        self.labelOr.attributedText = NSAttributedString(string: "Или выберите существующий", attributes: [NSAttributedString.Key.foregroundColor: nicePink])
        self.labelOr.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        self.labelOr.font = UIFont(name: "Helvetica", size: 20)
        
        self.tableOfPacks.backgroundColor = self.view.backgroundColor
        self.tableOfPacks.topAnchor.constraint(equalTo: self.labelOr.bottomAnchor, constant: 15).isActive = true
        self.tableOfPacks.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableOfPacks.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableOfPacks.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableOfPacks.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableOfPacks.separatorColor = .lightGray
        
        

    }
    
    
    // MARK: - TextField Delegate Functions
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        switch textField {
        case self.textName:
            if textField.text! != "" {
                self.currentPack.packName = textField.text!
                let _ = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(textField.text! + ".json")
            }
//        case self.textQPerR:
//            self.currentPack.qPerRAmount = textField.text!
        default:
            print("How")
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        return true
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
		self.currentPack.packName = textField.text!
    }

    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case self.textName:
//            self.textName.resignFirstResponder()
//            self.textQPerR.becomeFirstResponder()
//        case self.textQPerR:
//            self.textQPerR.resignFirstResponder()
//        default:
//            textField.resignFirstResponder()
//        }
        
        
        
        return true
    }
    
    // MARK: - viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableOfPacks.reloadData()
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.bgColour
        self.title = "Pack"
        self.tableOfPacks.dataSource = self
        self.tableOfPacks.delegate = self
        
        // self.view.addGestureRecognizer(self.tap)
        setUp()
        
        let files = try! FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
        
        for file in files {
            let filename = String(file.lastPathComponent)
            print(filename)
            let packName = String(filename[filename.startIndex ..< filename.firstIndex(of: ".")!])
            if packName != "" {
                arrayOfPacks.append(packName)
            }
        }
        
        self.tableOfPacks.reloadData()
    }
}

// MARK: - TableView Extensions
extension StartPackViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfPacks.isEmpty ? 1 : self.arrayOfPacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if self.arrayOfPacks.isEmpty {
            cell.textLabel?.text = "No existing packs found"
            cell.textLabel?.textColor = .gray
        } else {
            cell.textLabel?.text = self.arrayOfPacks[indexPath.row]
            cell.textLabel?.textColor = .white
        }
        
        //print("\n------------------------\n\(self.arrayOfPacks.count)")
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            print("Copy chosen file to .editingPack.json")
            
            self.tableView(tableView, didSelectRowAt: indexPath)
        })
        
        editAction.backgroundColor = .blue
        
        return self.arrayOfPacks.isEmpty ? nil : UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            self.deletePack(at: indexPath.row)
            self.tableOfPacks.reloadData()
        })
        
        deleteAction.backgroundColor = .red
        
        return self.arrayOfPacks.isEmpty ? nil : UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Copy chosen file to .editingPack.json")
        tableView.deselectRow(at: indexPath, animated: true)
        let origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".editingPack.json")
        let newFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.arrayOfPacks[indexPath.row] + ".json")
        
        do {
            if FileManager.default.fileExists(atPath: origin.path) {
                try! FileManager.default.removeItem(at: origin)
            }
            try FileManager.default.copyItem(at: newFile, to: origin)
            self.continueOnTap(tableView.cellForRow(at: indexPath))
        } catch let error as NSError {
            print(error)
        }
    }
}
