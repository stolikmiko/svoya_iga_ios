//
//  PersonalAreaViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 05.11.2020.
//


import UIKit

class PersonalAreaViewController: UIViewController {

    let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    let labelPA = UILabel()
    let labelName = UILabel()
    let labelPassword = UILabel()
    let textFieldName = UITextField()
    let textFieldPassword = UITextField()
    let buttonSignIn = UIButton()
    let buttonForgetPassword = UIButton()
    let buttonSignUp = UIButton()
    let labelOr = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = bgColour
        self.view.addSubview(labelPA)
        self.view.addSubview(labelName)
        self.view.addSubview(textFieldName)
        self.view.addSubview(labelPassword)
        self.view.addSubview(textFieldPassword)
        self.view.addSubview(buttonSignIn)
        self.view.addSubview(buttonForgetPassword)
        self.view.addSubview(buttonSignUp)
        self.view.addSubview(labelOr)
        
        
        // MARK: Label Personal Area
        labelPA.font = UIFont(name: "Helvetica", size: 30)
        labelPA.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelPA.text = "Личный кабинет"
        labelPA.translatesAutoresizingMaskIntoConstraints = false
        labelPA.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -300).isActive = true
        labelPA.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15.0).isActive = true
        
        // MARK: - Label Nickname
        labelName.font = UIFont(name: "Helvetica", size: 15)
        labelName.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelName.text = "Имя пользователя или адрес эл. почты"
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.topAnchor.constraint(equalTo: labelPA.bottomAnchor, constant: 15.0).isActive = true
        labelName.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15.0).isActive = true
        
        
        // MARK: - Enter Name
        textFieldName.layer.backgroundColor = bgColour.cgColor
        textFieldName.layer.borderColor = UIColor.white.cgColor
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10.0).isActive = true
        textFieldName.leftAnchor.constraint(equalTo: labelName.leftAnchor).isActive = true
        textFieldName.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
    
        textFieldName.font = UIFont(name: "Helvetica", size: 17)
        textFieldName.layer.borderWidth = 0.5
        textFieldName.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        textFieldName.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        textFieldName.keyboardType = .emailAddress
        
        // MARK: - Label Password
        labelPassword.font = UIFont(name: "Helvetica", size: 15)
        labelPassword.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelPassword.text = "Пароль"
        labelPassword.translatesAutoresizingMaskIntoConstraints = false
        labelPassword.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 15.0).isActive = true
        labelPassword.leftAnchor.constraint(equalTo: labelName.leftAnchor).isActive = true
        
        // MARK: - Enter Password
        textFieldPassword.layer.backgroundColor = bgColour.cgColor
        textFieldPassword.layer.borderColor = UIColor.white.cgColor
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        textFieldPassword.topAnchor.constraint(equalTo: labelPassword.bottomAnchor, constant: 10.0).isActive = true
        textFieldPassword.leftAnchor.constraint(equalTo: labelName.leftAnchor).isActive = true
        textFieldPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        textFieldPassword.layer.borderWidth = 0.5
        textFieldPassword.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        textFieldPassword.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.font = UIFont(name: "Helvetica", size: 17)
        
        //MARK: - Forgot Password
        buttonForgetPassword.titleLabel?.font = UIFont(name: "Helvetica", size: 10)
        buttonForgetPassword.setTitle("Забыли пароль?", for: .normal)
        buttonForgetPassword.translatesAutoresizingMaskIntoConstraints = false
        buttonForgetPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 8.0).isActive = true
        buttonForgetPassword.leftAnchor.constraint(equalTo: labelName.leftAnchor).isActive = true
        
        // MARK: - Sign In
        buttonSignIn.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        buttonSignIn.setTitle(" Войти ", for: .normal)
        buttonSignIn.layer.borderWidth = 2
        buttonSignIn.layer.borderColor = UIColor.white.cgColor
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        buttonSignIn.topAnchor.constraint(equalTo: buttonForgetPassword.bottomAnchor, constant: 10.0).isActive = true
        buttonSignIn.leftAnchor.constraint(equalTo: labelName.leftAnchor).isActive = true
        
        // MARK: - Label Or
        labelOr.font = UIFont(name: "Helvetica", size: 15)
        labelOr.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelOr.text = "или"
        labelOr.translatesAutoresizingMaskIntoConstraints = false
        labelOr.topAnchor.constraint(equalTo: buttonSignIn.bottomAnchor, constant: 8.0).isActive = true
        labelOr.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15.0).isActive = true
        
        // MARK: - Sign Up
        buttonSignUp.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        buttonSignUp.setTitle(" Зарегистрироваться ", for: .normal)
        buttonSignUp.layer.borderWidth = 2
        buttonSignUp.layer.borderColor = UIColor.white.cgColor
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        buttonSignUp.topAnchor.constraint(equalTo: labelOr.bottomAnchor, constant: 8.0).isActive = true
        buttonSignUp.leftAnchor.constraint(equalTo: labelName.leftAnchor).isActive = true
        buttonSignUp.addTarget(self, action: #selector(buttonSignUpTap), for: .touchUpInside)
    }
    
    //MARK: - Target Sing Up
    @objc func buttonSignUpTap(_ sender: UIButton){
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
