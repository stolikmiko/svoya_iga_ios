//
//  ThemesViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 15.11.2020.
//

import UIKit

class ThemesViewController: UIViewController {
    let bgColour:       UIColor     =   UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    
    let tableOfThemes:  UITableView =   UITableView()
    
    var currentPack:    StartPackViewController.Pack    =   StartPackViewController.Pack()
    var editInfo:       StartPackViewController.Edit?    =   StartPackViewController.Edit()
    
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
    
    // MARK: - Edit Theme Function
    func editingTheme(_ theme: String) {
        let questionsViewController = QuestionsViewController()
        
        self.editInfo!.themeName = theme
        
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
        
        self.navigationController?.pushViewController(questionsViewController, animated: true)
    }
    
    // MARK: - Add Theme
    func add() {
        self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.append(StartPackViewController.ThemedQuestions(theme: "Theme #" + String(self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.count + 1)))
        //self.currentPack.rounds.append(StartPackViewController.The(number: self.currentPack.rounds.count + 1))
        self.tableOfThemes.reloadData()

        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
    }
    
    // MARK: - Delete Theme Function
    func deletingTheme(_ themeNumber: Int) {
        self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.remove(at: themeNumber)
        self.tableOfThemes.reloadData()
        
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
    }
    
    // MARK: - Setup Function
    func setUp() {
        self.view.addSubview(self.tableOfThemes)
        
        self.tableOfThemes.backgroundColor = self.view.backgroundColor
        self.tableOfThemes.translatesAutoresizingMaskIntoConstraints = false
        self.tableOfThemes.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableOfThemes.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableOfThemes.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableOfThemes.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.tableOfThemes.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableOfThemes.separatorColor = .lightGray
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Quit", style: .plain, target: self, action: #selector(saveAndQuit))
    }
    
    // MARK: - Blank Round
    func createBlankRound() {
        currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.append(StartPackViewController.ThemedQuestions(theme: "Theme #1"))
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.bgColour
        self.title = "Themes"
        self.tableOfThemes.dataSource = self
        self.tableOfThemes.delegate = self
        
        RoundsViewController().readData(for: &self.currentPack, with: &self.editInfo)
        
        if self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.isEmpty {
            createBlankRound()
        }
        
        setUp()
    }
    
    //MARK: - viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RoundsViewController().readData(for: &self.currentPack, with: &self.editInfo)
        self.tableOfThemes.reloadData()
    }
}

// MARK: - TableView Extensions
extension ThemesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.count {
            cell.textLabel?.text = self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[indexPath.row].theme
        } else {
            cell.textLabel?.text = "+"
        }
        
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.count {
            self.editingTheme((tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        } else {
            self.add()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            self.editingTheme((tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            //self.editingTheme(String(indexPath.row))
        })
        
        editAction.backgroundColor = .blue
        
        return indexPath.row < self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.count ? UISwipeActionsConfiguration(actions: [editAction]) : nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            self.deletingTheme(indexPath.row)
        })
        
        deleteAction.backgroundColor = .red
        
        return indexPath.row < self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions.count ? UISwipeActionsConfiguration(actions: [deleteAction]) : nil
    }
}
