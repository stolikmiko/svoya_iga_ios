//
//  RoundsViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 15.11.2020.
//

import UIKit

class RoundsViewController: UIViewController {
    let bgColour:       UIColor     =   UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    
    let tableOfRounds:  UITableView =   UITableView()
    
    let buttonTest:     UIButton    =   UIButton()
    
    let urlPath:        URL         =   FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
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
    
    // MARK: - Edit Round Function
    func editingRound(_ roundNumber: Int) {
        // print("editing round #\(roundNumber + 1)")
        
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: StartPackViewController.Edit(roundNumber: String(roundNumber + 1)))
        
        let themesViewController = ThemesViewController()
        
        self.navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    // MARK: - Delete Round Funcrion
    func deletingRound(_ roundNumber: Int) {
        // print("deleting round #\(roundNumber + 1)")
        self.currentPack.rounds.remove(at: roundNumber)
        
        for i in 0..<self.currentPack.rounds.count {
            self.currentPack.rounds[i].number = i + 1
        }
        
        self.tableOfRounds.reloadData()
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: StartPackViewController.Edit())
    }
    
    // MARK: - Add Round
    func add() {
        self.currentPack.rounds.append(StartPackViewController.Round(number: self.currentPack.rounds.count + 1))
        self.tableOfRounds.reloadData()
        
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
    }
    
    // MARK: - Read Data For Current Pack
    func readData(for currentPack: inout StartPackViewController.Pack, with edit: inout StartPackViewController.Edit?, from packName: String = ".editingPack.json") {
        var dataFromFile: String = ""
        var packData: Data
        var editData: Data?
        let files = try! FileManager.default.contentsOfDirectory(at: self.urlPath, includingPropertiesForKeys: [])
        let packURL = URL(fileURLWithPath: packName).absoluteString
        for file in files {
            if file.absoluteString.hasSuffix(packURL[packURL.index(packURL.startIndex, offsetBy: 8)...]) {
                dataFromFile = try! String(contentsOf: file, encoding: .utf8)
                break
            }
        }
        
        if packName != ".play.json" {
            packData = dataFromFile[dataFromFile.startIndex ... dataFromFile.index(before: dataFromFile.lastIndex(of: "{")!)].data(using: .utf8)!
            editData = dataFromFile[dataFromFile.lastIndex(of: "{")! ..< dataFromFile.endIndex].data(using: .utf8)!
        } else {
            packData = dataFromFile.data(using: .utf8)!
            editData = nil
        }
        
        let decoder  = JSONDecoder()
        
        if edit != nil {
            edit! = try! decoder.decode(StartPackViewController.Edit.self, from: editData!)
        }
        
        currentPack = try! decoder.decode(StartPackViewController.Pack.self, from: packData)
    }
    
    // MARK: - Setup Function
    func setUp () {
        self.view.addSubview(self.tableOfRounds)
        
        self.tableOfRounds.backgroundColor = self.view.backgroundColor
        
        self.tableOfRounds.translatesAutoresizingMaskIntoConstraints = false
        self.tableOfRounds.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableOfRounds.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableOfRounds.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableOfRounds.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.tableOfRounds.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableOfRounds.separatorColor = .lightGray
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Quit", style: .plain, target: self, action: #selector(saveAndQuit))
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.bgColour
        self.title = "Rounds"
        
        self.tableOfRounds.dataSource = self
        self.tableOfRounds.delegate = self
        
        // print("______\n\n\(self.currentPack)\n\n______")
        setUp()
        //self.tableOfRounds.reloadData()
    }
    
    // MARK: - viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        readData(for: &self.currentPack, with: &self.editInfo)
        self.tableOfRounds.reloadData()
    }
}

// MARK: - Extension For TableView
extension RoundsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentPack.rounds.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < self.currentPack.rounds.count {
            cell.textLabel?.text = "Round " + String(self.currentPack.rounds[indexPath.row].number)
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
        
        if indexPath.row < self.currentPack.rounds.count {
            self.editingRound(indexPath.row)
        } else {
            self.add()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            self.editingRound(indexPath.row)
        })
        
        editAction.backgroundColor = .blue
        
        return indexPath.row < self.currentPack.rounds.count ? UISwipeActionsConfiguration(actions: [editAction]) : nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            self.deletingRound(indexPath.row)
        })
        
        deleteAction.backgroundColor = .red
        
        return indexPath.row < self.currentPack.rounds.count ? UISwipeActionsConfiguration(actions: [deleteAction]) : nil
    }
}

