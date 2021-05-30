//
//  DesignerViewController.swift
//  DemonTest
//
//  Created by Daemon on 26.10.2020.
//

import UIKit

class DesignerViewController: UIViewController, UITextFieldDelegate {

	let bgColor:            UIColor         =   UIColor.init(red: 0.106, green: 0.114, blue: 0.204, alpha: 1)
	let niceBlue = UIColor.init(red: 92/255, green: 98/255, blue: 167/255, alpha: 1)
	let nicePink = UIColor.init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)

	let textQ:              UITextField     =   UITextField()
	let textA:              UITextField     =   UITextField()
	let textWA:				UITextField		=	UITextField()
	let textCost:			UITextField		=	UITextField()

	let labelQ:             UILabel         =   UILabel()
	let labelWA:			UILabel			=	UILabel()
	let labelCost:			UILabel			=	UILabel()
	let labelA:             UILabel         =   UILabel()
	let labelP:             UILabel         =   UILabel()

	let buttonSubmitCreate: UIButton        =   UIButton()
    
    var currentPack:        StartPackViewController.Pack    =   StartPackViewController.Pack()
    var editInfo:           StartPackViewController.Edit?    =   StartPackViewController.Edit()

	var user: Array<StartPackViewController.Question> = [StartPackViewController.Question]()
	var questionTypeDropDown = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
	var questionDataTypeDropDown = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
	// MARK: - viewDidLoad()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.user.append(StartPackViewController.Question())
		self.view.backgroundColor = self.bgColor
        
        RoundsViewController().readData(for: &self.currentPack, with: &self.editInfo)
        
		self.setUp()

		print(self.questionTypeDropDown.titleLabel!.text!)
	}

	// MARK: - ViewSetup
	func setUp() {
		self.view.addSubview(self.labelQ)
		self.view.addSubview(self.labelA)
		self.view.addSubview(self.labelWA)
		self.view.addSubview(self.labelCost)
		self.view.addSubview(self.buttonSubmitCreate)
		[
			self.labelQ,
			self.labelA,
			self.labelWA,
			self.labelCost
		].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.textColor = .init(red: 238/255, green: 23/255, blue: 113/255, alpha: 1)
			$0.font = UIFont(name: "Helvetica", size: 20)

			var str = String()
			switch $0 {
			case self.labelCost:
				str = "Cost:"
			case self.labelWA:
				str = "Wrong Answers:"
			case self.labelQ:
				str = "Question:"
			case self.labelA:
				str = "Answer:"
			case self.labelP:
				str = "Files"
			default:
				str = "..."
			}
			$0.attributedText = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		})

		self.view.addSubview(self.textQ)
		self.view.addSubview(self.textA)
		self.view.addSubview(self.textWA)
		self.view.addSubview(self.textCost)
		self.view.addSubview(self.questionDataTypeDropDown)
		self.view.addSubview(self.questionTypeDropDown)
		questionTypeDropDown.setTitle("  В ы б е р и т е   категорию   в о п р о с а  ", for: .normal)
		questionTypeDropDown.translatesAutoresizingMaskIntoConstraints = false
		questionTypeDropDown.layer.backgroundColor = niceBlue.cgColor
		questionDataTypeDropDown.setTitle("  В ы б е р и т е   т и п  вопроса   ", for: .normal)
		questionDataTypeDropDown.translatesAutoresizingMaskIntoConstraints = false
		questionDataTypeDropDown.layer.backgroundColor = niceBlue.cgColor
		[
			self.textQ,
			self.textA,
			self.textWA,
			self.textCost
		].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.isUserInteractionEnabled = true
			$0.borderStyle = .roundedRect
			$0.layer.borderWidth = 2

			var str = String()
			switch $0 {
			case self.textCost:
                str = String(self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[QuestionsViewController().getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions[Int(self.editInfo!.questionNumber)! / 100 - 1].cost)
				// str = "Input Question Cost"
			case self.textWA:
                str = self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[QuestionsViewController().getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions[Int(self.editInfo!.questionNumber)! / 100 - 1].wrong
				// str = "Input Wrong Answers"
			case self.textQ:
                str = self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[QuestionsViewController().getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions[Int(self.editInfo!.questionNumber)! / 100 - 1].q
				// str = "Input Question"
			case self.textA:
                str = self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[QuestionsViewController().getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions[Int(self.editInfo!.questionNumber)! / 100 - 1].a
				// str = "Input Answer"
			default:
				str = "..."
			}

			$0.attributedPlaceholder = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)])
//            $0.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
			$0.layer.borderColor = UIColor.black.cgColor
			$0.textAlignment = .left
			$0.delegate = self
		})


		self.questionTypeDropDown.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
		self.questionTypeDropDown.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		self.questionTypeDropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
		self.questionTypeDropDown.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 3/5).isActive = true
		self.questionTypeDropDown.dropView.dropDownOptions = ["Обычный", "Аукцион", "Кот в мешке", "Обобщенный кот в мешке", "Вопрос без риска"]

		self.questionDataTypeDropDown.topAnchor.constraint(equalTo: self.questionTypeDropDown.bottomAnchor, constant: 10.0).isActive = true
		self.questionDataTypeDropDown.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		self.questionDataTypeDropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
		self.questionDataTypeDropDown.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 3/5).isActive = true
		self.questionDataTypeDropDown.dropView.dropDownOptions = ["Текст", "Картинка", "Аудио", "Видео"]

		self.textQ.topAnchor.constraint(equalTo: self.questionDataTypeDropDown.bottomAnchor, constant: 10.0).isActive = true
		self.textA.topAnchor.constraint(equalTo: self.textQ.bottomAnchor, constant: 10.0).isActive = true

		self.labelQ.centerYAnchor.constraint(equalTo: self.textQ.centerYAnchor).isActive = true
		self.labelA.centerYAnchor.constraint(equalTo: self.textA.centerYAnchor).isActive = true

		self.textQ.leftAnchor.constraint(equalTo: self.labelWA.rightAnchor, constant: 8.0).isActive = true
		self.textA.leftAnchor.constraint(equalTo: self.labelWA.rightAnchor, constant: 8.0).isActive = true

		self.textWA.topAnchor.constraint(equalTo: self.textA.bottomAnchor, constant: 10.0).isActive = true
		self.textCost.topAnchor.constraint(equalTo: self.textWA.bottomAnchor, constant: 10.0).isActive = true

		self.labelWA.centerYAnchor.constraint(equalTo: self.textWA.centerYAnchor).isActive = true
		self.labelCost.centerYAnchor.constraint(equalTo: self.textCost.centerYAnchor).isActive = true

		self.textWA.leftAnchor.constraint(equalTo: self.labelWA.rightAnchor, constant: 8.0).isActive = true
		self.textCost.leftAnchor.constraint(equalTo: self.labelWA.rightAnchor, constant: 8.0).isActive = true


		self.buttonSubmitCreate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.buttonSubmitCreate.topAnchor.constraint(equalTo: self.textCost.bottomAnchor, constant: 30.0).isActive = true

		self.buttonSubmitCreate.setTitle(" Сохранить ", for: .normal)
		self.buttonSubmitCreate.translatesAutoresizingMaskIntoConstraints = false
		self.buttonSubmitCreate.layer.borderWidth = 2
		self.buttonSubmitCreate.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
		self.buttonSubmitCreate.layer.borderColor = UIColor.white.cgColor
		self.buttonSubmitCreate.backgroundColor = self.bgColor
        self.buttonSubmitCreate.isUserInteractionEnabled = true

        self.buttonSubmitCreate.addTarget(self, action: #selector(save), for: .touchUpInside)
        

	}
    
	// MARK: - New Question Function
	@objc
	func clearAndAppend(_ sender: UIButton) {
		self.textQ.text = ""
		self.textA.text = ""
		self.user.append(StartPackViewController.Question())
	}
    
	// MARK: - Save Function
	@objc
	func save(_ sender: UIButton) {
        let origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".editingPack.json")
        let newFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentPack.packName + ".json")
        
        do {
            print("\n\n\n\n\(FileManager.default.fileExists(atPath: newFile.path))\n\n\n")
            if FileManager.default.fileExists(atPath: newFile.path) {
                print(". . . . . . . . . . . . . . . . . . . . . . . . . .\nDELETING\n. . . . . . . . . . . . . . . . . . . . . . . . . .\n")
                try! FileManager.default.removeItem(at: newFile)
            }
            try FileManager.default.copyItem(at: origin, to: newFile)
        } catch let error as NSError {
            print("\n\n_+_+_+_+_+_+_+_COPYING\n")
            print(error)
            print("\n__________________________________________________\n")
            print(origin)
            print(newFile.absoluteString)
            print(newFile)
        }
        /*
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		var str = ""

		for u in self.user {
			let jsonData = try! encoder.encode(u)

			str += String(data: jsonData, encoding: .utf8)!
			str += ",\n"
		}

		str.removeLast(2)

		do {
			try str.write(to: filename, atomically: true, encoding: .utf8)
		} catch {
			print("smth wrong brudda")
		}
*/
		let vc = self.navigationController?.viewControllers.filter({$0 is QuestionsViewController}).first
		self.navigationController?.popToViewController(vc!, animated: true)
 
        
	}



	// MARK: - UITextFieldDelegate

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
		return true
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("textFieldDidBeginEditing ")
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldEndEditing")
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        print("textFieldDidEndEditing")
		switch textField {
		case self.textQ:
			self.user[self.user.endIndex - 1].q = textField.text!.count != 0 ? textField.text! : "No Question Given"
		case self.textA:
			self.user[self.user.endIndex - 1].a = textField.text!.count != 0 ? textField.text! : "No Answer Given"
		default:
			print("!!!___!!!_DUDE WTF_!!!___!!!")
		}
	}


	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("shouldChangeCharactersIn = your input = \(string)")
		return true
	}

	func textFieldDidChangeSelection(_ textField: UITextField) {
//        print("textFieldDidChangeSelection_________\(type(of:textField.text!))")
        switch textField {
        case self.textQ:
            self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[QuestionsViewController().getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions[Int(self.editInfo!.questionNumber)! / 100 - 1].q = textField.text!
        case self.textA:
            self.currentPack.rounds[Int(self.editInfo!.roundNumber)! - 1].themedQuestions[QuestionsViewController().getIndex(for: self.editInfo!.themeName, using: self.currentPack, with: self.editInfo!)].questions[Int(self.editInfo!.questionNumber)! / 100 - 1].a = textField.text!
        default:
            print(". . .")
        }
        
        StartPackViewController().rewriteCurrentPack(using: self.currentPack, with: self.editInfo!)
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        print("textFieldShouldClear")
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("textFieldShouldReturn")
		switch textField {
		case self.textQ:
			self.textQ.resignFirstResponder()
			self.textA.becomeFirstResponder()
		case self.textA:
			self.textA.resignFirstResponder()
		default:
			break
		}
		return true
	}
}

