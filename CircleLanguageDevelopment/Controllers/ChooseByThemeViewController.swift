





//  ViewController.swift
//  webCirc
//
//  Created by Sandy Lord on 6/21/21.


import UIKit
import Foundation
import CoreData

//typealias APIResponses = [APIResponse]

class ChooseByThemeViewController: UIViewController {
    let appDelegate = AppDelegate()
    let imageView = UIImageView()

    let themes = ["body", "color", "fall", "geography", "house", "plant", "space", "transportation", "water", "world culture"]

    let chooseThemePickerView = UIPickerView()
    let themeLabel = UILabel()
    let unit1Image = UIImageView()
    let unit2Image = UIImageView()
    let unit3Image = UIImageView()
    let unit4Image = UIImageView()
    let unit1VocabItemsLabel = UILabel()
    let unit2VocabItemsLabel = UILabel()
    let unit3VocabItemsLabel = UILabel()
    let unit4VocabItemsLabel = UILabel()
    let unit1CoverButton = UIButton()
    let unit2CoverButton = UIButton()
    let unit3CoverButton = UIButton()
    let unit4CoverButton = UIButton()
    let exampleImageLabelLabel = UILabel()
    let unitLabelLabel = UILabel()
    let vocabularyLabelLabel = UILabel()
    let unit1Label = UILabel()
    let unit2Label = UILabel()
    let unit3Label = UILabel()
    let unit4Label = UILabel()
    var allCircleImages = CoreDataManager().accessAllCircleImages()
    let spinner = UIActivityIndicatorView()

//    let unit1CoverButton = UIButton(frame: CGRect(x: 10, y: 220, width: 500, height: 100))
//    let unit2CoverButton = UIButton(frame: CGRect(x: 10, y: 340, width: 500, height: 100))
//    let unit3CoverButton = UIButton(frame: CGRect(x: 10, y: 460, width: 500, height: 100))
//    let unit4CoverButton = UIButton(frame: CGRect(x: 10, y: 580, width: 500, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        while allCircleImages.count > 400 { allCircleImages.removeLast()}
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = .systemBlue
        addCircle_ELDSmallCornerLabel()
        addTitleLabel()
        configurePlacementOfLabelsAndImages()
        chooseThemePickerView.delegate = self
        chooseThemePickerView.dataSource = self
        spinner.center = self.view.center
        view.addSubview(spinner)
        spinner.backgroundColor = .red
        spinner.color = .black
        spinner.layer.zPosition = 100
        spinner.tintColor = .blue
    }
}


extension ChooseByThemeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return themes[row]
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 35)
            pickerLabel?.textAlignment = .center
        }

        pickerLabel?.text = themes[row]
        pickerLabel?.textColor = .white

        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        themeLabel.text = themes[row]

//        var allCircleImages = CoreDataManager().accessAllCircleImages()
//        while allCircleImages.count > 400 { allCircleImages.removeLast()}

        var theme = themes[row]
        if theme == "world culture" {
            theme = "worldCulture"
        }

        let url1 = URL(string: allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 1 })[0].photo!)
        let url2 = URL(string: allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 2 })[0].photo!)
        let url3 = URL(string: allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 3 })[0].photo!)
        let url4 = URL(string: allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 4 })[0].photo!)

        let data1 = try? Data(contentsOf: url1!)
        let data2 = try? Data(contentsOf: url2!)
        let data3 = try? Data(contentsOf: url3!)
        let data4 = try? Data(contentsOf: url4!)

        unit1Image.image = UIImage(data: data1!)
        unit2Image.image = UIImage(data: data2!)
        unit3Image.image = UIImage(data: data3!)
        unit4Image.image = UIImage(data: data4!)


        var vocab1 : [String] = []
        var vocab2 : [String] = []
        var vocab3 : [String] = []
        var vocab4 : [String] = []

        let unit1CircleImages = allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 1})
        let unit2CircleImages = allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 2})
        let unit3CircleImages = allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 3})
        let unit4CircleImages = allCircleImages.filter({ return $0.theme == theme }).filter({ return $0.unit == 4})

        for i in stride(from: 0, to: 10, by: 2){
            vocab1.append(unit1CircleImages[i].vocabulary!)
            vocab2.append(unit2CircleImages[i].vocabulary!)
            vocab3.append(unit3CircleImages[i].vocabulary!)
            vocab4.append(unit4CircleImages[i].vocabulary!)
        }

        unit1VocabItemsLabel.text = "\(vocab1[0]) \(vocab1[1]) \(vocab1[2]) \(vocab1[3]) \(vocab1[4])"
        unit2VocabItemsLabel.text = "\(vocab2[0]) \(vocab2[1]) \(vocab2[2]) \(vocab2[3]) \(vocab2[4])"
        unit3VocabItemsLabel.text = "\(vocab3[0]) \(vocab3[1]) \(vocab3[2]) \(vocab3[3]) \(vocab3[4])"
        unit4VocabItemsLabel.text = "\(vocab4[0]) \(vocab4[1]) \(vocab4[2]) \(vocab4[3]) \(vocab4[4])"

        unit1CoverButton.addTarget(self, action: #selector(openUnit1), for: .touchUpInside)
        unit2CoverButton.addTarget(self, action: #selector(openUnit2), for: .touchUpInside)
        unit3CoverButton.addTarget(self, action: #selector(openUnit3), for: .touchUpInside)
        unit4CoverButton.addTarget(self, action: #selector(openUnit4), for: .touchUpInside)

    }
    func configurePlacementOfLabelsAndImages() {
        var theme = CoreDataManager().accessSearch1CoreData()[0]

        let sessionTimeCreated = CoreDataManager().accessUserSessionCoreData()[1]
        let searchTimeCreated = CoreDataManager().accessSearch1CoreData()[1]
//        if sessionTimeCreated > searchTimeCreated {
//            theme = themes[0]
//        }

        print("sessionTimeCreated::", sessionTimeCreated)
        print("searchTimeCreated::", searchTimeCreated)

        let sessionTimeCreatedTimestamp : Double = ((Double(sessionTimeCreated)) ?? 0.0)!
        let searchTimeCreatedTimestamp : Double = ((Double(searchTimeCreated)) ?? 0.0)!

        if sessionTimeCreatedTimestamp > searchTimeCreatedTimestamp {
            theme = themes[0]
        }
//HERE
        let themeRowInt = themes.firstIndex(of: theme.lowercased()) ?? 0
//        let themeRowInt = 0
//        func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {}
        chooseThemePickerView.frame = CGRect(x: view.frame.midX - 125, y: 130, width: 250, height: 120)
        chooseThemePickerView.selectRow(themeRowInt, inComponent: 0, animated: false)
        chooseThemePickerView.backgroundColor = .systemIndigo
        chooseThemePickerView.layer.cornerRadius = 10
        chooseThemePickerView.tintColor = .white

//        chooseThemePickerView.se
        self.pickerView(self.chooseThemePickerView, didSelectRow: themeRowInt, inComponent: 0)
        self.chooseThemePickerView.selectRow(themeRowInt, inComponent: 0, animated: false)
//        chooseThemePickerView.selectRow(themeRowInt, inComponent: 0, animated: false)
//        self.pickerView(self.chooseThemePickerView, selectRow
        themeLabel.frame = CGRect(x: view.frame.midX - 175, y: 265, width: 350, height: 60)
        themeLabel.font = UIFont.boldSystemFont(ofSize: 45.0)
        themeLabel.textAlignment = .center
        themeLabel.layer.borderColor = CGColor(gray: 100, alpha: 1.0)
        themeLabel.layer.borderWidth = 2
        themeLabel.layer.cornerRadius = 10

//        themeLabel.text = themeLabel.text?.capitalized
        view.addSubview(chooseThemePickerView)
        view.addSubview(themeLabel)

        let width = CGFloat(90.00)
        let height = CGFloat(90.00)

        exampleImageLabelLabel.frame = CGRect(x: 10.0, y: view.frame.maxY - 550, width: width, height: height)
        exampleImageLabelLabel.text = "Example Image"
        exampleImageLabelLabel.textAlignment = .center
        exampleImageLabelLabel.numberOfLines = 0
        exampleImageLabelLabel.font = UIFont(name: "AppleSDGothicNeo", size: 18.0)
        view.addSubview(exampleImageLabelLabel)

        unit1Image.contentMode = .scaleAspectFit
        unit2Image.contentMode = .scaleAspectFit
        unit3Image.contentMode = .scaleAspectFit
        unit4Image.contentMode = .scaleAspectFit

        unit1Image.frame = CGRect(x: 10.0, y: view.frame.maxY - 480, width: width, height: height)
        unit2Image.frame = CGRect(x: 10.0, y: view.frame.maxY - 380, width: width, height: height)
        unit3Image.frame = CGRect(x: 10.0, y: view.frame.maxY - 280, width: width, height: height)
        unit4Image.frame = CGRect(x: 10.0, y: view.frame.maxY - 180, width: width, height: height)

        view.addSubview(unit1Image)
        view.addSubview(unit2Image)
        view.addSubview(unit3Image)
        view.addSubview(unit4Image)

        unitLabelLabel.frame = CGRect(x: 110.0, y: view.frame.maxY - 550, width: 60, height: height)
        unitLabelLabel.text = "Unit #"
        unitLabelLabel.textAlignment = .center
        unitLabelLabel.numberOfLines = 0
        unitLabelLabel.font = UIFont(name: "AppleSDGothicNeo", size: 18.0)
        view.addSubview(unitLabelLabel)

        unit1Label.frame = CGRect(x: 110.0, y: view.frame.maxY - 480, width: 60, height: height)
        unit1Label.text = "1"
        unit1Label.textAlignment = .center
        unit1Label.numberOfLines = 0
        unit1Label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 38.0)
        view.addSubview(unit1Label)

        unit2Label.frame = CGRect(x: 110.0, y: view.frame.maxY - 380, width: 60, height: height)
        unit2Label.text = "2"
        unit2Label.textAlignment = .center
        unit2Label.numberOfLines = 0
        unit2Label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 38.0)
        view.addSubview(unit2Label)

        unit3Label.frame = CGRect(x: 110.0, y: view.frame.maxY - 280, width: 60, height: height)
        unit3Label.text = "3"
        unit3Label.textAlignment = .center
        unit3Label.numberOfLines = 0
        unit3Label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 38.0)
        view.addSubview(unit3Label)

        unit4Label.frame = CGRect(x: 110.0, y: view.frame.maxY - 180, width: 60, height: height)
        unit4Label.text = "4"
        unit4Label.textAlignment = .center
        unit4Label.numberOfLines = 0
        unit4Label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 38.0)
        view.addSubview(unit4Label)

        vocabularyLabelLabel.frame = CGRect(x: 220.0, y: view.frame.maxY - 550, width: 120, height: height)
        vocabularyLabelLabel.text = "Vocabulary in Unit"
        vocabularyLabelLabel.textAlignment = .center
        vocabularyLabelLabel.numberOfLines = 0
        vocabularyLabelLabel.font = UIFont(name: "AppleSDGothicNeo", size: 18.0)
        view.addSubview(vocabularyLabelLabel)


        unit1VocabItemsLabel.numberOfLines = 0
        unit2VocabItemsLabel.numberOfLines = 0
        unit3VocabItemsLabel.numberOfLines = 0
        unit4VocabItemsLabel.numberOfLines = 0

        unit1VocabItemsLabel.textAlignment = .center
        unit2VocabItemsLabel.textAlignment = .center
        unit3VocabItemsLabel.textAlignment = .center
        unit4VocabItemsLabel.textAlignment = .center

        unit1VocabItemsLabel.frame = CGRect(x: 170, y: view.frame.maxY - 490, width: 220, height: 100)
        unit2VocabItemsLabel.frame = CGRect(x: 170, y: view.frame.maxY - 390, width: 220, height: 100)
        unit3VocabItemsLabel.frame = CGRect(x: 170, y: view.frame.maxY - 290, width: 220, height: 100)
        unit4VocabItemsLabel.frame = CGRect(x: 170, y: view.frame.maxY - 190, width: 220, height: 100)

        view.addSubview(unit1VocabItemsLabel)
        view.addSubview(unit2VocabItemsLabel)
        view.addSubview(unit3VocabItemsLabel)
        view.addSubview(unit4VocabItemsLabel)

        unit1CoverButton.frame = CGRect(x: 0, y: view.frame.maxY - 480, width: view.frame.maxX, height: 90)
        unit2CoverButton.frame = CGRect(x: 0, y: view.frame.maxY - 380, width: view.frame.maxX, height: 90)
        unit3CoverButton.frame = CGRect(x: 0, y: view.frame.maxY - 280, width: view.frame.maxX, height: 90)
        unit4CoverButton.frame = CGRect(x: 0, y: view.frame.maxY - 180, width: view.frame.maxX, height: 90)

        unit1CoverButton.layer.borderColor = CGColor(gray: 100, alpha: 1.0)
        unit2CoverButton.layer.borderColor = CGColor(gray: 100, alpha: 1.0)
        unit3CoverButton.layer.borderColor = CGColor(gray: 100, alpha: 1.0)
        unit4CoverButton.layer.borderColor = CGColor(gray: 100, alpha: 1.0)

        unit1CoverButton.layer.borderWidth = 2
        unit2CoverButton.layer.borderWidth = 2
        unit3CoverButton.layer.borderWidth = 2
        unit4CoverButton.layer.borderWidth = 2

        view.addSubview(unit1CoverButton)
        view.addSubview(unit2CoverButton)
        view.addSubview(unit3CoverButton)
        view.addSubview(unit4CoverButton)
    }
    func addCircle_ELDSmallCornerLabel() {
        let label = UILabel(frame: CGRect(x: 3, y: 22, width: 200, height: 50))
        label.text = "CIRCLE-ELD"
        label.backgroundColor = .init(white: 0, alpha: 0.0)
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 26.0)
        label.textAlignment = .left
        label.layer.zPosition = 10
        view.addSubview(label)
    }

    func addTitleLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: 60))
        label.text = "Choose a Theme"
//        label.layer.
        label.backgroundColor = .systemBlue
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 50.0)
        label.textAlignment = .center

        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Choose a Theme", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString

        view.addSubview(label)
    }
    
    func addViewCoverLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.backgroundColor = UIColor.init(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: 0.6)
        label.accessibilityIdentifier = "viewCoverLabel"
        label.isUserInteractionEnabled = false
        view.addSubview(label)
    }
    
    func removeViewCoverLabel() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        for label in labels {
            if label.accessibilityIdentifier == "viewCoverLabel" {
                label.removeFromSuperview()
            }
        }
    }
    

    
    func getVocabCorrespondingToThemeAndUnitChoice(choiceTheme: String, choiceUnit: String) -> String {
        return (CoreDataManager().accessAllCircleImages().filter({ return $0.theme == choiceTheme }).filter({ return "\($0.unit ?? 1)" == choiceUnit }).first?.vocabulary)!
    }

    @objc func openUnit1() {
//        CoreDataManager().resetAllUserCoreDataToZero()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addViewCoverLabel()
            self.spinner.startAnimating()
        }
//        addViewCoverLabel()
//        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.spinner.stopAnimating()
            self.removeViewCoverLabel()
        }
        let unit = "1"
        let theme = themeLabel.text ?? "color"
        let chosenTypeValue = getVocabCorrespondingToThemeAndUnitChoice(choiceTheme: theme, choiceUnit: unit)
        let time = "\(NSDate().timeIntervalSince1970)"
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")
        userThemeUnitChoice.setValue(time, forKey: "timeCreated")
        userThemeUnitChoice.setValue("vocabulary", forKey: "chosenType")
        userThemeUnitChoice.setValue(chosenTypeValue, forKey: "chosenTypeValue")
        

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice -- time: \(time), vocab: \(chosenTypeValue)")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1NewViewController(), animated:true, completion:nil)
    }
    @objc func openUnit2() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addViewCoverLabel()
            self.spinner.startAnimating()
        }
//        addViewCoverLabel()
//        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.spinner.stopAnimating()
            self.removeViewCoverLabel()
        }
//        CoreDataManager().resetAllUserCoreDataToZero()
        let unit = "2"
        let theme = themeLabel.text ?? "color"
        let chosenTypeValue = getVocabCorrespondingToThemeAndUnitChoice(choiceTheme: theme, choiceUnit: unit)
        let time = "\(NSDate().timeIntervalSince1970)"
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")
        userThemeUnitChoice.setValue(time, forKey: "timeCreated")
        userThemeUnitChoice.setValue("vocabulary", forKey: "chosenType")
        userThemeUnitChoice.setValue(chosenTypeValue, forKey: "chosenTypeValue")
        

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice -- time: \(time), vocab: \(chosenTypeValue)")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1NewViewController(), animated:true, completion:nil)
    }
    @objc func openUnit3() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addViewCoverLabel()
            self.spinner.startAnimating()
        }
//        addViewCoverLabel()
//        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.spinner.stopAnimating()
            self.removeViewCoverLabel()
        }
//        CoreDataManager().resetAllUserCoreDataToZero()
        let unit = "3"
        let theme = themeLabel.text ?? "color"
        let chosenTypeValue = getVocabCorrespondingToThemeAndUnitChoice(choiceTheme: theme, choiceUnit: unit)
        let time = "\(NSDate().timeIntervalSince1970)"
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")
        userThemeUnitChoice.setValue(time, forKey: "timeCreated")
        userThemeUnitChoice.setValue("vocabulary", forKey: "chosenType")
        userThemeUnitChoice.setValue(chosenTypeValue, forKey: "chosenTypeValue")
        

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice -- time: \(time), vocab: \(chosenTypeValue)")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1NewViewController(), animated:true, completion:nil)
    }
    @objc func openUnit4() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addViewCoverLabel()
            self.spinner.startAnimating()
        }
//        addViewCoverLabel()
//        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.spinner.stopAnimating()
            self.removeViewCoverLabel()
        }
//        CoreDataManager().resetAllUserCoreDataToZero()
        let unit = "4"
        let theme = themeLabel.text ?? "color"
        let chosenTypeValue = getVocabCorrespondingToThemeAndUnitChoice(choiceTheme: theme, choiceUnit: unit)
        let time = "\(NSDate().timeIntervalSince1970)"
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")
        userThemeUnitChoice.setValue(time, forKey: "timeCreated")
        userThemeUnitChoice.setValue("vocabulary", forKey: "chosenType")
        userThemeUnitChoice.setValue(chosenTypeValue, forKey: "chosenTypeValue")
        

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice -- time: \(time), vocab: \(chosenTypeValue)")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1NewViewController(), animated:true, completion:nil)
    }
}

