//
//  TEMPResViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 14.05.2021.
//

import UIKit

class TEMPResViewController: UIViewController {
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newBackButton = UIBarButtonItem(title: "Quit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.quit(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc
    func quit(_ sender: UIBarButtonItem) {
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".results.json")
        if FileManager.default.fileExists(atPath: file.path) { try! FileManager.default.removeItem(at: file) }
        self.navigationController?.popToRootViewController(animated: true)
    }
}
