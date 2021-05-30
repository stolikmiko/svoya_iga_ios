//
//  SingUpVC.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 27.11.2020.
//

import UIKit

class SignUpVC: UIViewController, UIGestureRecognizerDelegate{
    
    let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    let niceBlue = UIColor.init(red: 92/255, green: 98/255, blue: 167/255, alpha: 1)
    let nicePink = UIColor.init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
    
    let labelSignUp = UILabel()
    let labelNickname = UILabel()
    let labelMail = UILabel()
    let labelPassFirst = UILabel()
    let labelPassSecond = UILabel()
    let labelAvatar = UILabel()
    
    let textFieldNickname = UITextField()
    let textFieldMail = UITextField()
    let textFieldPassFirst = UITextField()
    let textFieldPassSecond = UITextField()
    
    let buttonSingUp = UIButton()
    
    
    
    override func viewDidLoad() {
        
        // swipe back
        //self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // navigation bar off
        //self.navigationController?.setNavigationBarHidden(true,  animated: true)

        
        super.viewDidLoad()
        self.view.addSubview(labelSignUp)
        self.view.addSubview(labelNickname)
        self.view.addSubview(labelMail)
        self.view.addSubview(labelPassFirst)
        self.view.addSubview(labelPassSecond)
        self.view.addSubview(labelAvatar)
        self.view.addSubview(textFieldNickname)
        self.view.addSubview(textFieldMail)
        self.view.addSubview(textFieldPassFirst)
        self.view.addSubview(textFieldPassSecond)
        self.view.addSubview(buttonSingUp)
        
        self.view.backgroundColor = bgColour
        
        // MARK: - Label Sign Up
        
        self.labelSignUp.font = UIFont(name: "Helvetica", size: 30)
        self.labelSignUp.textColor = UIColor.white
        self.labelSignUp.text = "Регистрация"
        self.labelSignUp.translatesAutoresizingMaskIntoConstraints = false
        self.labelSignUp.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -350).isActive = true
        self.labelSignUp.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15.0).isActive = true
        
        // MARK: - Label Nickname
        self.labelNickname.font = UIFont(name: "Helvetica", size: 15)
        self.labelNickname.textColor = UIColor.white
        self.labelNickname.text = "Введите Имя Пользователя"
        self.labelNickname.translatesAutoresizingMaskIntoConstraints = false
        self.labelNickname.topAnchor.constraint(equalTo: labelSignUp.bottomAnchor, constant: 25).isActive = true
        self.labelNickname.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        // MARK: - Text Field Enter Nickname
        self.textFieldNickname.layer.backgroundColor = bgColour.cgColor
        self.textFieldNickname.layer.borderColor = UIColor.white.cgColor
        self.textFieldNickname.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldNickname.topAnchor.constraint(equalTo: labelNickname.bottomAnchor, constant: 10).isActive = true
        self.textFieldNickname.leftAnchor.constraint(equalTo: labelNickname.leftAnchor).isActive = true
        self.textFieldNickname.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.textFieldNickname.layer.borderWidth = 0.5
        self.textFieldNickname.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        self.textFieldNickname.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        
        // MARK: - Label Mail
        self.labelMail.font = UIFont(name: "Helvetica", size: 15)
        self.labelMail.textColor = UIColor.white
        self.labelMail.text = "Введите Почту"
        self.labelMail.translatesAutoresizingMaskIntoConstraints = false
        self.labelMail.topAnchor.constraint(equalTo: textFieldNickname.bottomAnchor, constant: 15).isActive = true
        self.labelMail.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        // MARK: - Text Field Enter Mail
        self.textFieldMail.layer.backgroundColor = bgColour.cgColor
        self.textFieldMail.layer.borderColor = UIColor.white.cgColor
        self.textFieldMail.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldMail.topAnchor.constraint(equalTo: labelMail.bottomAnchor, constant: 10).isActive = true
        self.textFieldMail.leftAnchor.constraint(equalTo: labelMail.leftAnchor).isActive = true
        self.textFieldMail.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.textFieldMail.layer.borderWidth = 0.5
        self.textFieldMail.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        self.textFieldMail.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        self.textFieldMail.keyboardType = .emailAddress
        
        // MARK: - Label Password 1
        self.labelPassFirst.font = UIFont(name: "Helvetica", size: 15)
        self.labelPassFirst.textColor = UIColor.white
        self.labelPassFirst.text = "Придумайте Пароль"
        self.labelPassFirst.translatesAutoresizingMaskIntoConstraints = false
        self.labelPassFirst.topAnchor.constraint(equalTo: textFieldMail.bottomAnchor, constant: 15).isActive = true
        self.labelPassFirst.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        // MARK: - Text Field Password 1
        self.textFieldPassFirst.layer.backgroundColor = bgColour.cgColor
        self.textFieldPassFirst.layer.borderColor = UIColor.white.cgColor
        self.textFieldPassFirst.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldPassFirst.topAnchor.constraint(equalTo: labelPassFirst.bottomAnchor, constant: 10).isActive = true
        self.textFieldPassFirst.leftAnchor.constraint(equalTo: labelPassFirst.leftAnchor).isActive = true
        self.textFieldPassFirst.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.textFieldPassFirst.layer.borderWidth = 0.5
        self.textFieldPassFirst.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        self.textFieldPassFirst.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        self.textFieldPassFirst.isSecureTextEntry = true
        
        // MARK: - Label Password 2
        self.labelPassSecond.font = UIFont(name: "Helvetica", size: 15)
        self.labelPassSecond.textColor = UIColor.white
        self.labelPassSecond.text = "Повторите Пароль"
        self.labelPassSecond.translatesAutoresizingMaskIntoConstraints = false
        self.labelPassSecond.topAnchor.constraint(equalTo: textFieldPassFirst.bottomAnchor, constant: 15).isActive = true
        self.labelPassSecond.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        // MARK: - Text Field Password 2
        self.textFieldPassSecond.layer.backgroundColor = bgColour.cgColor
        self.textFieldPassSecond.layer.borderColor = UIColor.white.cgColor
        self.textFieldPassSecond.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldPassSecond.topAnchor.constraint(equalTo: labelPassSecond.bottomAnchor, constant: 10).isActive = true
        self.textFieldPassSecond.leftAnchor.constraint(equalTo: labelPassSecond.leftAnchor).isActive = true
        self.textFieldPassSecond.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.textFieldPassSecond.layer.borderWidth = 0.5
        self.textFieldPassSecond.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        self.textFieldPassSecond.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        self.textFieldPassSecond.isSecureTextEntry = true

        // MARK: - Button Sign Up
        self.buttonSingUp.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        self.buttonSingUp.setTitle(" Зарегистрироваться ", for: .normal)
        self.buttonSingUp.layer.borderWidth = 2
        self.buttonSingUp.layer.borderColor = UIColor.white.cgColor
        self.buttonSingUp.translatesAutoresizingMaskIntoConstraints = false
        self.buttonSingUp.topAnchor.constraint(equalTo: textFieldPassSecond.bottomAnchor, constant: 20).isActive = true
        self.buttonSingUp.leftAnchor.constraint(equalTo: textFieldPassSecond.leftAnchor).isActive = true
       // buttonSingUp.addTarget(self, action: #selector(buttonSignUpTap), for: .touchUpInside)
        
    }
    
    
    
}
