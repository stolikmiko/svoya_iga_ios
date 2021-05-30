//
//  TEMPGWBViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 13.05.2021.
//

import UIKit

class TEMPGWBViewController: UIViewController {
    
    
    struct GameRes: Codable {
        var points: Dictionary<String, Int> = [String: Int]()
        var nextPlayer: String = String()
    }
    
    let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
    var chosenPack: StartPackViewController.Pack = StartPackViewController.Pack()
    let tableOfRounds: UITableView = UITableView()
    var hiddenSections: Set<String> = Set<String>()
    var playedQs: Dictionary<Int, Dictionary<String, Set<Int>>> = [Int: [String: Set<Int>]]()
    var results: GameRes = GameRes()
    //    var playingRound: Int
    
    //MARK: - Init
    init(with packName: String, for players: Int) {
        self.results = GameRes(points: Dictionary<String, Int>(), nextPlayer: "")
        if players != 0 {
            self.results.points["player"] = 0
            for i in 1 ..< players {
                self.results.points["bot#" + String(i)] = 0
            }
            
            var a : StartPackViewController.Edit? = nil
            RoundsViewController().readData(for: &self.chosenPack, with: &a, from: ".play.json")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.results = GameRes()
        super.init(coder: coder)
    }
    
    //MARK: - writeResults
    func writeResults(_ results: GameRes) {
        let filename = ".results.json"
        let newFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: newFile.path) {
            try! FileManager.default.removeItem(at: newFile)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try! encoder.encode(results)
        
        try! jsonData.write(to: newFile, options: .atomic)
    }
    
    //MARK: - readResults
    func readResults(into currentResults: inout GameRes) {
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".results.json")
        
        if FileManager.default.fileExists(atPath: file.path) {
            do {
                let data = try String(contentsOf: file).data(using: .utf8)
                currentResults = try JSONDecoder().decode(TEMPGWBViewController.GameRes.self, from: data!)
            } catch let error as NSError {
                print("read results:", error)
            }
        }
    }
    
    //MARK: - setUp
    func setUp() {
        self.writeResults(self.results)
        /*
        let alert = UIAlertController(title: "Quit", message: "Package was successfully saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        */
        
        self.view.backgroundColor = self.bgColour
        self.title = self.chosenPack.packName + "#" + String(self.playedQs.count)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
//        self.view.addSubview(self.qLabel)
//        self.view.addSubview(self.aLabel)
//        self.view.addSubview(self.naLabel)
        self.view.addSubview(self.tableOfRounds)
        self.tableOfRounds.backgroundColor = self.view.backgroundColor
        
        self.tableOfRounds.translatesAutoresizingMaskIntoConstraints = false
        self.tableOfRounds.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableOfRounds.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableOfRounds.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableOfRounds.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.tableOfRounds.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableOfRounds.separatorColor = .lightGray
        
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let round = self.playedQs.count
        self.playedQs[round + 1] = Dictionary<String, Set<Int>>()
        for theme in self.chosenPack.rounds[round].themedQuestions {
            self.playedQs[round + 1]?[theme.theme] = Set<Int>()
        }
        self.tableOfRounds.dataSource = self
        self.tableOfRounds.delegate = self
        for i in self.chosenPack.rounds[round].themedQuestions {
            self.hiddenSections.insert(i.theme)
        }
        setUp()
    }
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.readResults(into: &self.results)
        self.checkRound()
    }
    
    //MARK: - Check Round
    func checkRound() {
        var roundOver: Bool = true
        self.tableOfRounds.reloadData()
        self.tableOfRounds.layoutIfNeeded()
        
        for section in 0..<self.tableOfRounds.numberOfSections {
            if self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[section].questions.count != self.playedQs[self.playedQs.count]![self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[section].theme]!.count {
                roundOver = false
            }
        }
        
        if roundOver {
            if self.chosenPack.rounds.count == self.playedQs.count {
                //Game Over
                let tres = TEMPResViewController()
                self.navigationController?.pushViewController(tres, animated: true)
            } else {
                let round = self.playedQs.count
                self.playedQs[round + 1] = Dictionary<String, Set<Int>>()
                
                for theme in self.chosenPack.rounds[round].themedQuestions {
                    self.playedQs[round + 1]![theme.theme] = Set<Int>()
                }
                
                self.title = self.chosenPack.packName + "#" + String(self.playedQs.count)
            }
        }
        
        self.tableOfRounds.reloadData()
        self.tableOfRounds.layoutIfNeeded()
    }
    
    //MARK: - playQ
    func playQ(theme themeNumber: Int, q qNumber: Int) {
        self.playedQs[self.chosenPack.rounds[self.playedQs.count - 1].number]![self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[themeNumber].theme]!.insert(qNumber)
        
        let tqa = TEMPQAViewController(question: self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[themeNumber].questions[qNumber], bots: self.results.points.count - 1)
        self.navigationController?.pushViewController(tqa, animated: true)
    }
}

//MARK: - Extension for TableView
extension TEMPGWBViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.hiddenSections.contains(self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[section].theme) {
            for round in self.chosenPack.rounds {
                if round.number == self.playedQs.count {
                    return round.themedQuestions[section].questions.count
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = String(self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[indexPath.section].questions[indexPath.row].cost)
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
        cell.textLabel?.textAlignment = .center
        
        if self.playedQs[self.playedQs.count]![self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[indexPath.section].theme]!.contains(indexPath.row) {
            cell.textLabel?.textColor = .gray
            cell.isUserInteractionEnabled = false
        } else {
            cell.textLabel?.textColor = .white
            cell.isUserInteractionEnabled = true
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let selectRound: UIButton = UIButton()
        selectRound.setTitle(self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[section].theme, for: .normal)
        
        if self.playedQs[self.playedQs.count]![selectRound.currentTitle!]!.count == self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions[section].questions.count {
            selectRound.backgroundColor = .systemRed
        } else {
            selectRound.backgroundColor = .systemGreen
        }
        
        selectRound.tag = section
        selectRound.addTarget(self, action: #selector(toggleTheme(_:)), for: .touchUpInside)
        
        return selectRound
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.playQ(theme: indexPath.section, q: indexPath.row)
    }
    
    @objc
    func toggleTheme(_ sender: UIButton) {
        let theme = sender.currentTitle!
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            var q: StartPackViewController.ThemedQuestions = StartPackViewController.ThemedQuestions()
            
            for thm in self.chosenPack.rounds[self.playedQs.count - 1].themedQuestions {
                if thm.theme == theme {
                    q = thm
                    break
                }
            }
            
            for row in 0..<q.questions.count {
                indexPaths.append(IndexPath(row: row, section: sender.tag))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(theme) {
            self.hiddenSections.remove(theme)
            self.tableOfRounds.insertRows(at: indexPathsForSection(), with: .fade)
        } else {
            self.hiddenSections.insert(theme)
            self.tableOfRounds.deleteRows(at: indexPathsForSection(), with: .fade)
        }
    }
}
