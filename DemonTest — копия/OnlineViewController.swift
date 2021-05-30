//
//  OnlineViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 22.10.2020.
//

import UIKit

class OnlineViewController: UIViewController {

    func bgColour(_ al: CGFloat) -> UIColor {
            return UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: al)
    }
    
    let textOnline: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = self.bgColour(1)
        
        self.view.addSubview(self.textOnline)
        self.textOnline.isUserInteractionEnabled = true
        self.textOnline.borderStyle = .roundedRect
        self.textOnline.layer.borderWidth = 1
        self.textOnline.attributedPlaceholder = NSAttributedString(string: "Input Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        self.textOnline.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        self.textOnline.textAlignment = .left
        self.textOnline.backgroundColor = self.bgColour(1)
        self.textOnline.layer.borderColor = UIColor.white.cgColor
        self.textOnline.frame = CGRect(x: 150, y: 115, width: 150, height: 50)
    }
}
