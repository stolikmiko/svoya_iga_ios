//
// Created by Olya Chebotkova on 23.11.2020.
//

import UIKit


class StartGameWithBotsVC: UIViewController{
    let array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
	let bgColour = UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
	let niceBlue = UIColor.init(red: 92/255, green: 98/255, blue: 167/255, alpha: 1)
	let landscapeRightOrientation = UIInterfaceOrientation.landscapeRight.rawValue
	let buttonBackGround = UIButton()
	let labelRound = UILabel()
    var chosenPack : StartPackViewController.Pack = StartPackViewController.Pack()
    var amountOfPlayers: Int
    
    //let collectionTest: UICollectionView = UICollectionView()
    
    // MARK: - init
    init(with packName: String, for players: Int) {
        var a: StartPackViewController.Edit? = nil
        RoundsViewController().readData(for: &self.chosenPack, with: &a, from: ".play.json")
        
        self.amountOfPlayers = players
        self.chosenPack.packName = packName
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - required init?
    required init?(coder: NSCoder) {
        self.amountOfPlayers = 0
        
        super.init(coder: coder)
    }
    
    // MARK: - Setup Function
    func setUp() {
        self.view.addSubview(buttonBackGround)
        self.buttonBackGround.translatesAutoresizingMaskIntoConstraints = false
        self.buttonBackGround.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.buttonBackGround.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -220).isActive = true
        self.buttonBackGround.setImage(UIImage(named: "/Users/olik_adm/Downloads/BackGround.png"), for: .normal)
        self.buttonBackGround.isUserInteractionEnabled = true
        self.buttonBackGround.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)

        self.view.addSubview(labelRound)
        self.labelRound.text = "Раунд 1"
        self.labelRound.font = UIFont(name: "Helvetica Neue", size: 40)
        self.labelRound.textColor = bgColour
        self.labelRound.translatesAutoresizingMaskIntoConstraints = false
        self.labelRound.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 30).isActive = true
        self.labelRound.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        
        /*
        self.view.addSubview(self.collectionTest)
        self.collectionTest.translatesAutoresizingMaskIntoConstraints = false
        self.collectionTest.topAnchor.constraint(equalTo: self.labelRound.bottomAnchor, constant: 7.0).isActive = true
        self.collectionTest.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.collectionTest.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.collectionTest.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        */
    }
    
    // MARK: - viewDidLoad
	override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = bgColour
        self.navigationController?.setNavigationBarHidden(true,  animated: true)
        print(self.amountOfPlayers, self.chosenPack.packName)
        self.setUp()
        UIDevice.current.setValue(landscapeRightOrientation, forKey: "orientation")
	}
    
    // MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        
	}
    
    @objc
    func goBack(_ sender: UIButton) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let gb = self.navigationController?.viewControllers.filter({$0 is GameWithBotsVC}).first
        self.navigationController?.popToViewController(gb!, animated: true)
    }
}
