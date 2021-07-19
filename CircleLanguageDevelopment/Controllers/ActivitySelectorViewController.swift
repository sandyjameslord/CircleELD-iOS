//
//  ViewController.swift
//  webCirc
//
//  Created by Sandy Lord on 6/21/21.
//

import UIKit
import Foundation
import CoreData

typealias APIResponses = [APIResponse]


extension ActivitySelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return themes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        themeLabel.text = themes[row]
        var allCircleImages = self.obtainCircleImages()
        while allCircleImages.count > 400 { allCircleImages.removeLast()}
        
        var theme = themes[row]
        if theme == "world culture" {
            theme = "worldCulture"
        }

        let url1 = URL(string: allCircleImages.filter({ return $0.theme == theme })[0].photo!)
        let url2 = URL(string: allCircleImages.filter({ return $0.theme == theme })[10].photo!)
        let url3 = URL(string: allCircleImages.filter({ return $0.theme == theme })[20].photo!)
        let url4 = URL(string: allCircleImages.filter({ return $0.theme == theme })[30].photo!)
        
        let data1 = try? Data(contentsOf: url1!)
        let data2 = try? Data(contentsOf: url2!)
        let data3 = try? Data(contentsOf: url3!)
        let data4 = try? Data(contentsOf: url4!)
        
        unit1Image.image = UIImage(data: data1!)
        unit2Image.image = UIImage(data: data2!)
        unit3Image.image = UIImage(data: data3!)
        unit4Image.image = UIImage(data: data4!)

        let width = CGFloat(100.00)
        let height = CGFloat(100.00)
        
        unit1Image.frame = CGRect(x: 10.0, y: 180.0, width: width, height: height)
        unit2Image.frame = CGRect(x: 10.0, y: 290.0, width: width, height: height)
        unit3Image.frame = CGRect(x: 10.0, y: 400.0, width: width, height: height)
        unit4Image.frame = CGRect(x: 10.0, y: 510.0, width: width, height: height)
        
        view.addSubview(unit1Image)
        view.addSubview(unit2Image)
        view.addSubview(unit3Image)
        view.addSubview(unit4Image)
        
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
        
        unit1VocabItemsLabel.numberOfLines = 0
        unit2VocabItemsLabel.numberOfLines = 0
        unit3VocabItemsLabel.numberOfLines = 0
        unit4VocabItemsLabel.numberOfLines = 0
        
        unit1VocabItemsLabel.frame = CGRect(x: 130, y: 180, width: 250, height: 100)
        unit2VocabItemsLabel.frame = CGRect(x: 130, y: 290, width: 250, height: 100)
        unit3VocabItemsLabel.frame = CGRect(x: 130, y: 400, width: 250, height: 100)
        unit4VocabItemsLabel.frame = CGRect(x: 130, y: 510, width: 250, height: 100)
        
        view.addSubview(unit1VocabItemsLabel)
        view.addSubview(unit2VocabItemsLabel)
        view.addSubview(unit3VocabItemsLabel)
        view.addSubview(unit4VocabItemsLabel)
        
        let unit1CoverButton = UIButton(frame: CGRect(x: 10, y: 180, width: 500, height: 100))
        let unit2CoverButton = UIButton(frame: CGRect(x: 10, y: 290, width: 500, height: 100))
        let unit3CoverButton = UIButton(frame: CGRect(x: 10, y: 400, width: 500, height: 100))
        let unit4CoverButton = UIButton(frame: CGRect(x: 10, y: 510, width: 500, height: 100))
        
        unit1CoverButton.addTarget(self, action: #selector(openUnit1), for: .touchUpInside)
        unit2CoverButton.addTarget(self, action: #selector(openUnit2), for: .touchUpInside)
        unit3CoverButton.addTarget(self, action: #selector(openUnit3), for: .touchUpInside)
        unit4CoverButton.addTarget(self, action: #selector(openUnit4), for: .touchUpInside)
        
        view.addSubview(unit1CoverButton)
        view.addSubview(unit2CoverButton)
        view.addSubview(unit3CoverButton)
        view.addSubview(unit4CoverButton)
        
        
        
    }
    
    @objc func openUnit1() {
        let unit = "1"
        let theme = themeLabel.text ?? "color"
        
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1IntroductionViewController(), animated:true, completion:nil)
    }
    @objc func openUnit2() {
        let unit = "2"
        let theme = themeLabel.text ?? "color"
        
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1IntroductionViewController(), animated:true, completion:nil)
    }
    @objc func openUnit3() {
        let unit = "3"
        let theme = themeLabel.text ?? "color"
        
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1IntroductionViewController(), animated:true, completion:nil)
    }
    @objc func openUnit4() {
        let unit = "4"
        let theme = themeLabel.text ?? "color"
        
        let context = appDelegate.persistentContainer.viewContext
        let userThemeUnitChoice = NSEntityDescription.insertNewObject(forEntityName: "UserThemeUnitChoice", into: context)
        userThemeUnitChoice.setValue(theme, forKey: "theme")
        userThemeUnitChoice.setValue(unit, forKey: "unit")

        do {
            try context.save()
            print("Success: \(theme) unit \(unit) saved as userThemeUnitChoice")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

        present(Ex1IntroductionViewController(), animated:true, completion:nil)
    }
}

class ActivitySelectorViewController: UIViewController {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chooseThemePickerView.delegate = self
        chooseThemePickerView.dataSource = self
        
        let theme = getUsersThemeChoice()
        print("theme inside activity selector::", theme)
        let themeRowInt = themes.firstIndex(of: theme.lowercased()) ?? 0
        
        chooseThemePickerView.frame = CGRect(x: 10, y: 80, width: 300, height: 100)
        chooseThemePickerView.selectRow(themeRowInt, inComponent: 0, animated: false)
        self.pickerView(self.chooseThemePickerView, didSelectRow: themeRowInt, inComponent: 0)
//        self.pickerView(self.chooseThemePickerView, didSelectRow: themeRowInt, inComponent: 0)

        themeLabel.frame = CGRect(x: 10, y: 70, width: 350, height: 100)
        
        view.addSubview(chooseThemePickerView)
        view.addSubview(themeLabel)

        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 150, height: 52))
        label.backgroundColor = .systemGray2
        label.text = "Activity Selector"
        
        view.addSubview(label)

        view.backgroundColor = .systemPurple

    }
    
    func getUsersThemeChoice() -> String {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Search1")
        request.returnsObjectsAsFaults = false
        var theme: String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
//                    userChoice = result as! UserChoice
                    theme = (result.value(forKey: "theme") as? String)!
//                    let unit = result.value(forKey: "unit") as? String

//                    userThemeUnitChoice = "\(theme ?? "theme error") \(unit ?? "unit number error")"
//                    return userChoice
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return theme
    }
    // save APIResponses to CoreData
//    func saveCircleImageDataToCoreData(_ circleImagesAPIValues: [APIResponse]) {
//        let context = self.appDelegate.persistentContainer.viewContext
//        for circleImageAPIValue in circleImagesAPIValues {
//            let newCircleImage = NSEntityDescription.insertNewObject(forEntityName: "CircleImages", into: context)
//         
//            newCircleImage.setValue(circleImageAPIValue.id?.oid, forKey: "id")
//            newCircleImage.setValue(circleImageAPIValue.vocabulary, forKey: "vocabulary")
//            newCircleImage.setValue(Int(circleImageAPIValue.unit!.numberInt), forKey: "unit")
//            newCircleImage.setValue(circleImageAPIValue.abSentence, forKey: "abSentence")
//            newCircleImage.setValue(circleImageAPIValue.abQuestion, forKey: "abQuestion")
//            newCircleImage.setValue(circleImageAPIValue.abQuestionDomain, forKey: "abQuestionDomain")
//            newCircleImage.setValue(circleImageAPIValue.bcSentence, forKey: "bcSentence")
//            newCircleImage.setValue(circleImageAPIValue.bcQuestion, forKey: "bcQuestion")
//            newCircleImage.setValue(circleImageAPIValue.bcQuestionDomain, forKey: "bcQuestionDomain")
//            newCircleImage.setValue(circleImageAPIValue.imageName, forKey: "imageName")
//            newCircleImage.setValue(circleImageAPIValue.photo, forKey: "photo")
//            newCircleImage.setValue(circleImageAPIValue.progName, forKey: "progName")
//            newCircleImage.setValue(circleImageAPIValue.syllStructure, forKey: "syllStructure")
//            newCircleImage.setValue(circleImageAPIValue.theme, forKey: "theme")
//        }
//        do {
//            try context.save()
//            print("Success")
//        } catch {
//            print("Error saving: \(error.localizedDescription)")
//        }
//    }
    
    // access CircleImages in CoreData
    func obtainCircleImages() -> [CircleImage] {
        print("obtaining circle images")
        let context = self.appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CircleImages")
        request.returnsObjectsAsFaults = false
        var retrievedCircleImages: [CircleImage] = []
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    let id = result.value(forKey: "id") as? String
                    let unit = result.value(forKey: "unit") as? Int
                    let abSentence = result.value(forKey: "abSentence") as? String
                    let abQuestion = result.value(forKey: "abQuestion") as? String
                    let abQuestionDomain = result.value(forKey: "abQuestionDomain") as? String
                    let bcSentence = result.value(forKey: "bcSentence") as? String
                    let bcQuestion = result.value(forKey: "bcQuestion") as? String
                    let bcQuestionDomain = result.value(forKey: "bcQuestionDomain") as? String
                    let imageName = result.value(forKey: "imageName") as? String
                    let photo = result.value(forKey: "photo") as? String
                    let progName = result.value(forKey: "progName") as? String
                    let syllStructure = result.value(forKey: "syllStructure") as? String
                    let theme = result.value(forKey: "theme") as? String
                    let vocabulary = result.value(forKey: "vocabulary") as? String

                    let circleImage = CircleImage(id: id, unit: unit, abQuestion: abQuestion, abQuestionDomain: abQuestionDomain, abSentence: abSentence, bcQuestion: bcQuestion, bcQuestionDomain: bcQuestionDomain, bcSentence: bcSentence, imageName: imageName, photo: photo, progName: progName, syllStructure: syllStructure, theme: theme, vocabulary: vocabulary)
                    retrievedCircleImages.append(circleImage)
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return retrievedCircleImages
    }
   
}
