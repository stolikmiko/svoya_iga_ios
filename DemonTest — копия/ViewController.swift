//
//  ViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 22.10.2020.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    let niceBlue = UIColor.init(red: 92/255, green: 98/255, blue: 167/255, alpha: 1)
    let nicePink = UIColor.init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
    let titleMain = UILabel()
    let buttonOnline = UIButton()
    let buttonDesigner = UIButton()
    let buttonGameWithBots = UIButton()
    let buttonPersonalArea = UIButton()
    let buttonAboutGame = UIButton()
    let buttonSettings = UIButton()
    let tableView = UITableView()
    //???
    let buttonBackGround = UIButton()
    
    func setupConstraint() {
        
        [
            self.titleMain,
            self.buttonOnline,
            self.buttonDesigner,
            self.buttonPersonalArea,
            self.buttonGameWithBots,
            self.buttonAboutGame,
            self.buttonSettings,
            self.buttonBackGround,
            self.tableView
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        [
            self.buttonBackGround.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonBackGround.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            
            self.titleMain.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleMain.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 220),
            
            //self.buttonGameWithBots.widthAnchor.constraint(equalToConstant: 230),
            self.buttonGameWithBots.heightAnchor.constraint(equalToConstant: 50),
            self.buttonGameWithBots.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonGameWithBots.topAnchor.constraint(equalTo: self.titleMain.centerYAnchor, constant: 90.0),
            self.buttonGameWithBots.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            
            //self.buttonOnline.widthAnchor.constraint(equalToConstant: 230),
            self.buttonOnline.heightAnchor.constraint(equalToConstant: 50),
            self.buttonOnline.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonOnline.topAnchor.constraint(equalTo: self.buttonGameWithBots.centerYAnchor, constant: 70.0),
            self.buttonOnline.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            
            //self.buttonDesigner.widthAnchor.constraint(equalToConstant: 230),
            self.buttonDesigner.heightAnchor.constraint(equalToConstant: 50),
            self.buttonDesigner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonDesigner.topAnchor.constraint(equalTo: self.buttonOnline.centerYAnchor, constant: 70.0),
            self.buttonDesigner.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            
            //self.buttonAboutGame.widthAnchor.constraint(equalToConstant: 230),
            self.buttonAboutGame.heightAnchor.constraint(equalToConstant: 50),
            self.buttonAboutGame.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonAboutGame.topAnchor.constraint(equalTo: self.buttonDesigner.centerYAnchor, constant: 70.0),
            self.buttonAboutGame.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            
            self.buttonPersonalArea.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.buttonPersonalArea.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -40),
            
            self.buttonSettings.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.buttonSettings.rightAnchor.constraint(equalTo: buttonPersonalArea.leftAnchor, constant: -20)
            
        ].forEach({
            $0.isActive = true
        })
        
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = bgColour
        self.view.backgroundColor = bgColour
        
        // MARK: - Clear Navigation Bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.view.backgroundColor = .clear

//        UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
        
        // MARK: - Background
        self.view.addSubview(buttonBackGround)
        self.buttonBackGround.setImage(UIImage(named: "/Users/olik_adm/Downloads/BackGround.png"), for: .normal)
        self.buttonBackGround.isUserInteractionEnabled = false
        
        // MARK: - Title
        self.view.addSubview(self.titleMain)
        self.titleMain.text = "Своя Игра"
        self.titleMain.font = UIFont(name: "Helvetica Neue", size: 58)
        self.titleMain.textColor = bgColour
        
        //MARK: - Game With Bots
        self.view.addSubview(buttonGameWithBots)
        self.buttonGameWithBots.setTitle("Игра с ботами", for: .normal)
        self.buttonGameWithBots.layer.borderWidth = 2
        self.buttonGameWithBots.layer.cornerRadius = 25
        self.buttonGameWithBots.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25)
        self.buttonGameWithBots.layer.borderColor = niceBlue.cgColor
        self.buttonGameWithBots.setTitleColor(bgColour, for: .normal)
        self.buttonGameWithBots.setTitleColor(.white, for: .highlighted)
        self.buttonGameWithBots.addTarget(self, action: #selector(buttonGameWithBotsTap), for: .touchUpInside)
        self.buttonGameWithBots.layer.backgroundColor = niceBlue.cgColor
        
        //MARK: - Online button
        self.view.addSubview(buttonOnline)
        self.buttonOnline.setTitle("Игра Онлайн", for: .normal)
        self.buttonOnline.layer.borderWidth = 2
        self.buttonOnline.layer.cornerRadius = 25
        self.buttonOnline.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25)
//        self.buttonOnline.layer.borderColor = UIColor.white.cgColor
        self.buttonOnline.setTitleColor(bgColour, for: .normal)
        self.buttonOnline.setTitleColor(.white, for: .highlighted)
        self.buttonOnline.addTarget(self, action: #selector(buttonOnlineTap), for: .touchUpInside)
        self.buttonOnline.layer.backgroundColor = niceBlue.cgColor
        
        //MARK: -  Designer pack button
        self.view.addSubview(self.buttonDesigner)
        self.buttonDesigner.setTitle("Конструктор паков", for: .normal)
        self.buttonDesigner.layer.borderWidth = 2
        self.buttonDesigner.layer.cornerRadius = 25
        self.buttonDesigner.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25)
        self.buttonDesigner.layer.borderColor = niceBlue.cgColor
        self.buttonDesigner.setTitleColor(bgColour, for: .normal)
        self.buttonDesigner.setTitleColor(.white, for: .highlighted)
        self.buttonDesigner.addTarget(self, action: #selector(buttonDesignerTap), for: .touchUpInside)
        self.buttonDesigner.layer.backgroundColor = niceBlue.cgColor
        
        //MARK: - About Game
        self.view.addSubview(self.buttonAboutGame)
        self.buttonAboutGame.setTitle("Об игре", for: .normal)
        self.buttonAboutGame.layer.borderWidth = 2
        self.buttonAboutGame.layer.cornerRadius = 25
        self.buttonAboutGame.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25)
        self.buttonAboutGame.layer.borderColor = niceBlue.cgColor
        self.buttonAboutGame.setTitleColor(bgColour, for: .normal)
        self.buttonAboutGame.setTitleColor(.white, for: .highlighted)
        self.buttonAboutGame.addTarget(self, action: #selector(buttonAboutGameTap), for: .touchUpInside)
        self.buttonAboutGame.layer.backgroundColor = niceBlue.cgColor
        
        //MARK: - PersonalArea button
        self.view.addSubview(self.buttonPersonalArea)
        self.buttonPersonalArea.setImage(UIImage(named: "/Users/olik_adm/Downloads/PersonalAreaIcon1x.png"), for: .normal)
        self.buttonPersonalArea.addTarget(self, action: #selector(buttonPersonalAreaTap), for: .touchUpInside)
        
        //MARK: - Settings button
        self.view.addSubview(buttonSettings)
        self.buttonSettings.setImage(UIImage(named: "/Users/olik_adm/Downloads/SettingsIcon1x.png"), for: .normal)
        self.buttonSettings.addTarget(self, action: #selector(buttonSettingsTap), for: .touchUpInside)
        
        
        
        setupConstraint()
    }

    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

    //MARK: - button*Tap
    @objc func buttonOnlineTap(_ sender: UIButton) {
        let onlineController = OnlineViewController()
        self.navigationController?.pushViewController(onlineController, animated: true)
    }
    
    @objc func buttonDesignerTap(_ sender: UIButton) {
        let start = StartPackViewController()
        self.navigationController?.pushViewController(start, animated: true)
    }
    
    @objc
    func buttonPersonalAreaTap(_ sender: UIButton) {
        let personalAreaViewController = PersonalAreaViewController()
        self.navigationController?.pushViewController(personalAreaViewController, animated: true)
    
    }
    
    @objc func buttonGameWithBotsTap(_ sender: UIButton){
        let gameWithBotsVC = GameWithBotsVC()
        self.navigationController?.pushViewController(gameWithBotsVC, animated: true)
    }
    
    @objc func buttonAboutGameTap(_ sender: UIButton){
        let aboutGameVC = AboutGameVC()
        self.navigationController?.pushViewController(aboutGameVC, animated: true)
    }
    
    @objc func buttonSettingsTap(_ sender: UIButton){
        let settingsVC = SettingsVC()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
}
