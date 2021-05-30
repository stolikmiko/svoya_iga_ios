//
//  ChoosePackViewController.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 04.12.2020.
//

import UIKit

class ChoosePackViewController: UIViewController {
    
    struct Packs {
        var classic: Bool = false
        var arrayOfPacks: Array<String> = [String]()
    }
    
    let bgColor:        UIColor         =   ViewController().bgColour
    
    let tableOfPacks:   UITableView     =   UITableView()
    
    let pickerForType:  UIPickerView    =   UIPickerView()
    
    let arrayOfTypes:   Array<String>   =   ["Any", "Classic"]
    let arrayOfChoice:  Array<String>   =   ["Random", "Choose"]
    
    let labelPackName:  UILabel         =   UILabel()
    let textFindPack:   UITextField     =   UITextField()
    
    var packName:       String          =   String()
    
    var listOfPacks:    Packs           =   Packs()
    
//    let buttonChoose:   UIButton        =   UIButton()
    
    // MARK: - Get List Of Packs
    func getListOfPacks() -> Void {
        self.listOfPacks.arrayOfPacks.removeAll()
        
        let files = try! FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
        
        for file in files {
            let filename = String(file.lastPathComponent)
            var packName: String
            
            // .classic_PackName1
            if filename.hasPrefix(".classic") {
                packName = "\u{23A1}C\u{23A6} " +  String(filename[filename.index(after: filename.firstIndex(of: "_")!) ..< filename.lastIndex(of: ".")!])
            } else {
                packName = String(filename[filename.startIndex ..< filename.firstIndex(of: ".")!])
            }
            
            if packName != "" {
                self.listOfPacks.arrayOfPacks.append(packName)
            }
        }
        
        if self.listOfPacks.classic {
            self.listOfPacks.arrayOfPacks = self.listOfPacks.arrayOfPacks.filter { $0.hasPrefix("\u{23A1}") }
        }
    }
    
    // MARK: - Setup Function
    func setUp() {
        self.view.backgroundColor = self.bgColor
        
        [
            self.labelPackName,
            self.pickerForType,
            self.textFindPack,
            self.tableOfPacks,
//            self.buttonChoose,
        ].forEach({
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        self.labelPackName.textColor = .darkGray
        self.labelPackName.textAlignment = .center
        self.labelPackName.font = UIFont(name: "Helvetica", size: 15.0)
        self.labelPackName.text = "Chosen Pack's Name Will Be Here"
        self.labelPackName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15.0).isActive = true
        self.labelPackName.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        self.pickerForType.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.pickerForType.topAnchor.constraint(equalTo: self.labelPackName.bottomAnchor, constant: 15.0).isActive = true
        self.pickerForType.heightAnchor.constraint(equalToConstant: 85.0).isActive = true
        
        self.textFindPack.isUserInteractionEnabled = false
        self.textFindPack.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.textFindPack.topAnchor.constraint(equalTo: self.pickerForType.bottomAnchor, constant: 15.0).isActive = true
        self.textFindPack.attributedPlaceholder = NSAttributedString(string: "Enter Pack's Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.textFindPack.textAlignment = .center
        self.textFindPack.textColor = .white
        self.textFindPack.addTarget(self, action: #selector(selectPack(_:)), for: .editingChanged)
        
        self.tableOfPacks.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableOfPacks.backgroundColor = self.view.backgroundColor
        self.tableOfPacks.separatorColor = .lightGray
        self.tableOfPacks.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableOfPacks.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableOfPacks.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableOfPacks.topAnchor.constraint(equalTo: self.textFindPack.bottomAnchor, constant: 10.0).isActive = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Choose", style: .plain, target: self, action: #selector(choosePack(_:)))
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.pickerForType.dataSource = self
        self.pickerForType.delegate = self
        self.tableOfPacks.dataSource = self
        self.tableOfPacks.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.pickerView(self.pickerForType, didSelectRow: 0, inComponent: 0)

    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\n\n+++++++\nAPPEAR\n+++++++\n\n")
        self.getListOfPacks()
    }
    
    // MARK: - TODO: View Pack Function
    func viewPack() {
        print("\n!!!\nMake Proper View Function\n!!!\n")
    }
    
    // MARK: - Choose Pack
    @objc
    func choosePack(_ sender: UIBarButtonItem) {
        let newFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".play.json")
        let filename = self.labelPackName.text!.replacingOccurrences(of: "\u{23A1}C\u{23A6} ", with: ".classic_") + ".json"
        let origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        let alert = UIAlertController(title: "Choose Pack First", message: nil, preferredStyle: .alert)
        print(self.labelPackName.text!, filename)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        if self.labelPackName.textColor == UIColor.darkGray {
            self.present(alert, animated: true)
        } else {
            do {
                var pack = StartPackViewController.Pack()
                var a: StartPackViewController.Edit? = nil
                RoundsViewController().readData(for: &pack, with: &a, from: filename)
                StartPackViewController().rewriteCurrentPack(using: pack, toFile: ".play.json")
                /*
                if FileManager.default.fileExists(atPath: newFile.path) {
                    try! FileManager.default.removeItem(at: newFile)
                }
                try FileManager.default.copyItem(at: origin, to: newFile)
                
                /*
                let alert = UIAlertController(title: "Quit", message: "Package was successfully saved", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                */
                 */
                let gwb = self.navigationController?.viewControllers.filter({$0 is GameWithBotsVC}).first
                self.navigationController?.popToViewController(gwb!, animated: true)
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    // MARK: - Random Pack
    func randomPack(from type: String) {
        let bound = arc4random()
        let number = arc4random_uniform(bound)
        
        self.labelPackName.textColor = .lightGray
        self.labelPackName.text = self.listOfPacks.arrayOfPacks[Int(number) % self.listOfPacks.arrayOfPacks.count]
    }
    
    // MARK: - Select Pack
    @objc
    func selectPack(_ sender: UITextField) {
        //print(sender.text!)
        self.getListOfPacks()
        if sender.text! != "" {
            self.listOfPacks.arrayOfPacks = self.listOfPacks.arrayOfPacks.filter{ $0.lowercased().contains(sender.text!.lowercased()) }
        }
        self.tableOfPacks.reloadData()
    }
    
    // MARK: - Keyboard Will Show
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                
                self.view.frame.origin.y += height
            }
        }
    }
    
    // MARK: - Keyboard Will Hide
    func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                
                self.view.frame.origin.y -= height
            }
        }
    }
}

// MARK: - Extensions For Picker
extension ChoosePackViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.arrayOfTypes.count
        } else {
            return self.arrayOfChoice.count
        }
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrayOfChoice[row]
    }
     */
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = UILabel()
        if let v = view {
            pickerLabel = v as! UILabel
        }
        
        pickerLabel.textAlignment = .center
        pickerLabel.font = UIFont(name: "Helvetica", size: 20.0)
        pickerLabel.text = component == 0 ? self.arrayOfTypes[row] : self.arrayOfChoice[row]
        pickerLabel.textColor = .red
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.listOfPacks.classic =  self.arrayOfTypes[self.pickerForType.selectedRow(inComponent: 0)] == "Classic" ? true : false
        self.getListOfPacks()
        
        switch self.arrayOfChoice[pickerView.selectedRow(inComponent: 1)] {
        case "Random":
            self.tableOfPacks.reloadData()
            self.textFindPack.text = ""
            self.textFindPack.isUserInteractionEnabled = false
            self.textFindPack.attributedPlaceholder = NSAttributedString(string: "Enter Pack's Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            self.randomPack(from: self.arrayOfTypes[pickerView.selectedRow(inComponent: 0)])
        case "Choose":
            self.tableOfPacks.reloadData()
            self.labelPackName.text = "Chosen Pack's Name Will Be Here"
            self.labelPackName.textColor = .darkGray
            self.textFindPack.attributedPlaceholder = NSAttributedString(string: "Enter Pack's Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            self.textFindPack.isUserInteractionEnabled = true
        default:
            self.tableOfPacks.reloadData()
            print(self.arrayOfChoice[pickerView.selectedRow(inComponent: 1)])
        }
    }
}

// MARK: - Extensions for TableView
extension ChoosePackViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfPacks.arrayOfPacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         
        cell.textLabel?.textColor = self.arrayOfChoice[self.pickerForType.selectedRow(inComponent: 1)] == "Random" ? .lightGray : .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = self.listOfPacks.arrayOfPacks[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.labelPackName.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        self.labelPackName.textColor = .lightGray
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let viewPackAction = UIContextualAction(style: .normal, title: "View", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            success(true)
            self.viewPack()
        })
        
        viewPackAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [viewPackAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        self.tableView(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
    }
}
