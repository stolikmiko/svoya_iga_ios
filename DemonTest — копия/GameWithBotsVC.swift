//
//  GameWithBotsVC.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 15.11.2020.
//

import UIKit

class GameWithBotsVC: UIViewController {
    
    let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    let niceBlue = UIColor.init(red: 92/255, green: 98/255, blue: 167/255, alpha: 1)
    let buttonStartGame = UIButton()
    let labelMainTitle = UILabel()
    let labelForSlider = UILabel()
    let labelAmount = UILabel()
    var showMenu = false
    var buttonChoosePack = DropDownBtn()
    var buttonChooseRole = DropDownBtn()
    let mySlider = UISlider()
    let portraitOrientation = UIInterfaceOrientation.portrait.rawValue
    
    let buttonPack: UIButton    =   UIButton()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(labelAmount)
        self.view.addSubview(mySlider)
        self.view.addSubview(labelForSlider)
        self.view.addSubview(buttonStartGame)
        self.view.addSubview(self.buttonPack)

		// MARK: - Setting Portrait Orientation
        UIDevice.current.setValue(portraitOrientation, forKey: "orientation")

        // MARK: - Main Label
        self.view.addSubview(labelMainTitle)
        labelMainTitle.font = UIFont(name: "Helvetica", size: 30)
        labelMainTitle.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelMainTitle.text = "Новая Игра"
        labelMainTitle.translatesAutoresizingMaskIntoConstraints = false
        labelMainTitle.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        labelMainTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60.0).isActive = true
        
        // MARK: - DROP DOWN MENUes begin
        buttonChooseRole = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(buttonChooseRole)
        buttonChooseRole.setTitle("Выберите Роль", for: .normal)
        buttonChooseRole.translatesAutoresizingMaskIntoConstraints = false
        buttonChooseRole.layer.backgroundColor = niceBlue.cgColor
        
        buttonChoosePack = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(buttonChoosePack)
        buttonChoosePack.setTitle("Выберите Пак", for: .normal)
        buttonChoosePack.translatesAutoresizingMaskIntoConstraints = false
        buttonChoosePack.layer.backgroundColor = niceBlue.cgColor
        buttonChoosePack.isUserInteractionEnabled = false
        
        //button Constraints
        buttonChoosePack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonChoosePack.topAnchor.constraint(equalTo: labelMainTitle.bottomAnchor, constant: 50).isActive = true
        buttonChoosePack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonChoosePack.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 4/5).isActive = true
        
        buttonChooseRole.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonChooseRole.topAnchor.constraint(equalTo: self.buttonPack.bottomAnchor, constant: 50).isActive = true
        buttonChooseRole.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonChooseRole.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 4/5).isActive = true

        buttonChoosePack.dropView.dropDownOptions = ["Рандомный набор", "Классический пак...", "Пользовательский пак..."]
        buttonChooseRole.dropView.dropDownOptions = ["Участник", "Ведущий", "Зритель"]
        //end
        
        // MARK: - Label Amount
        labelAmount.font = UIFont(name: "Helvetica", size: 20)
        labelAmount.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelAmount.text = "Количество Игроков"
        labelAmount.translatesAutoresizingMaskIntoConstraints = false
        labelAmount.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        labelAmount.topAnchor.constraint(equalTo: buttonChooseRole.bottomAnchor, constant: 50.0).isActive = true
        
        // MARK: - Slider
        mySlider.minimumValue = 2
        mySlider.maximumValue = 10
        mySlider.isContinuous = true
        mySlider.tintColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        mySlider.translatesAutoresizingMaskIntoConstraints = false
        mySlider.addTarget(self, action: #selector(paybackSliderValueDidChange), for: .valueChanged)
        mySlider.topAnchor.constraint(equalTo: labelAmount.bottomAnchor, constant: 20).isActive = true
        mySlider.leftAnchor.constraint(equalTo: buttonChoosePack.leftAnchor).isActive = true
        mySlider.rightAnchor.constraint(equalTo: buttonChoosePack.rightAnchor, constant: -30).isActive = true
        self.view.backgroundColor = bgColour
        labelForSlider.text = "\(Int(mySlider.value))"
        
        // MARK: - Label for slider
        labelForSlider.font = UIFont(name: "Helvetica", size: 20)
        labelForSlider.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelForSlider.text = "2"
        labelForSlider.translatesAutoresizingMaskIntoConstraints = false
        labelForSlider.topAnchor.constraint(equalTo: labelAmount.bottomAnchor, constant: 23.5).isActive = true
        labelForSlider.rightAnchor.constraint(equalTo: buttonChoosePack.rightAnchor).isActive = true
        
        // MARK: - Start Game Button
        buttonStartGame.titleLabel?.font = UIFont(name: "Helvetica", size: 25)
        buttonStartGame.setTitle(" Начать Игру ", for: .normal)
        buttonStartGame.layer.borderWidth = 2
        buttonStartGame.layer.borderColor = UIColor.white.cgColor
        buttonStartGame.translatesAutoresizingMaskIntoConstraints = false
        buttonStartGame.topAnchor.constraint(equalTo: mySlider.bottomAnchor, constant: 20.0).isActive = true
        buttonStartGame.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        buttonStartGame.addTarget(self, action: #selector(buttonStartGameWhithBotsTap), for: .touchUpInside)
        
        // MARK: -
        self.buttonPack.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        self.buttonPack.setTitle(" Выбор Пака ", for: .normal)
        self.buttonPack.layer.borderWidth = 2
        self.buttonPack.layer.borderColor = UIColor.white.cgColor
        self.buttonPack.translatesAutoresizingMaskIntoConstraints = false
        self.buttonPack.topAnchor.constraint(equalTo: self.buttonChoosePack.bottomAnchor, constant: 20.0).isActive = true
        self.buttonPack.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.buttonPack.addTarget(self, action: #selector(trueChoice), for: .touchUpInside)
        
//        self.checkForPack()
        if FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".play.json").path) {
            try! FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".play.json").path)
        }
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.checkForPack()
    }
    
    // MARK: - Check For Existing Play Pack
    func checkForPack() -> Void {
        let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".play.json")
        if FileManager.default.fileExists(atPath: urlPath.path) {
            self.buttonChoosePack.backgroundColor = .systemGreen
            var dict: Dictionary<String, String> = [String:String]()
            do {
                let text = try String(contentsOf: urlPath)
                let lines = text.split(separator: "\n")
                let bigStr = lines[lines.index(lines.endIndex, offsetBy: -2)].trimmingCharacters(in: .whitespacesAndNewlines)
                let line = "{\n\t" + bigStr + "\n}"
                let data = line.data(using: .utf8)!
                dict = try JSONDecoder().decode(Dictionary<String, String>.self, from: data)
            } catch {
                print("ERROR: ", error)
            }

            self.buttonChoosePack.setTitle(dict["packName"]!, for: .normal)
            self.buttonChoosePack.setTitleColor(.black, for: .normal)
        }
    }
    
    //MARK: - Push Choose Pack
    @objc
    func trueChoice(_ sender: UIButton) -> Void {
        let cp = ChoosePackViewController()
        self.navigationController?.pushViewController(cp, animated: true)
    }
    
    // MARK: - Slider func
    @objc func paybackSliderValueDidChange(sender: UISlider!)
    {
        let rv = round(sender.value)
        sender.value = rv
        labelForSlider.text = "\(Int(sender.value))"
    }
    
    // MARK: - Start Game Function
    @objc
    func buttonStartGameWhithBotsTap(_ sender: UIButton) {
        // print(self.buttonChoosePack.currentTitle!, self.buttonChooseRole.currentTitle!, self.mySlider.value)
        
        if self.buttonChooseRole.currentTitle!.hasPrefix("Выберите ") || self.buttonChoosePack.currentTitle!.hasPrefix("Выберите ") {
            let alert = UIAlertController(title: "Oops!", message: "Something is not right", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            let name = self.buttonChoosePack.titleLabel?.text!
            
            let tsgwb = TEMPGWBViewController(with: name!, for: Int(self.mySlider.value))
            self.navigationController?.pushViewController(tsgwb, animated: true)
            
//            let startGameWithBotsVC = StartGameWithBotsVC(with: name!, for: Int(self.mySlider.value))
//            self.navigationController?.pushViewController(startGameWithBotsVC, animated: true)
        }
    }

    // MARK: - Drop down menu
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

// MARK: - DropDownBtn
class DropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.layer.backgroundColor = UIColor.systemGreen.cgColor
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        if self.superview != nil{
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            height = dropView.heightAnchor.constraint(equalToConstant: 0)
            
        }
    }
    
    var isOpen = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - dropDownView
class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

