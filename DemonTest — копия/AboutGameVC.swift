//
//  AboutGameVC.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 15.11.2020.
//

import UIKit

class AboutGameVC: UIViewController {
    
    let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    let labelMainTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = bgColour
        self.view.addSubview(labelMainTitle)
        
        labelMainTitle.font = UIFont(name: "Helvetica", size: 30)
        labelMainTitle.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
        labelMainTitle.text = "Об Игре"
        labelMainTitle.translatesAutoresizingMaskIntoConstraints = false
        labelMainTitle.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        labelMainTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60.0).isActive = true
    }
}

