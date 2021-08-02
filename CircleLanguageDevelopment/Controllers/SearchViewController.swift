//
//  ViewController.swift
//  Pagination
//
//  Created by Sandy Lord on 7/24/21.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var timerForIndicator : Timer?
    let themeNames = ["body", "color", "fall", "geography", "house", "plant", "space", "transportation", "water", "world culture"]
    
    private let dataManager = CoreDataManager()
    private var data = [String]()
    
    private var circleObjectsData = [Any]()
//    private var circleObjectsData = [CircleImage]()
//    private var indicesForCircleObjectsData = [Int]()
    
    let appDelegate = AppDelegate()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    let spinner = UIActivityIndicatorView()
    let userInput = UITextField()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircle_ELDSmallCornerLabel()
        addTitleLabel()
        addCountLabel()
        let newFont = UIFont(name: "HelveticaNeue-Thin", size: 30)
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        //
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.init(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
            NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            NSAttributedString.Key.font: newFont as Any,
            NSAttributedString.Key.strokeWidth:  1.2,
        ]
        
        userInput.leftViewMode = UITextField.ViewMode.always
        userInput.leftView = spacerView
        userInput.frame = CGRect(x: 10, y: 140, width: view.frame.width - 20, height: 60)
//        userInput.backgroundColor = .systemBlue
        userInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        userInput.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        userInput.backgroundColor = .systemGray5
        userInput.placeholder = "Theme, Vocabulary, or Keyword"
//        userInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        userInput.layer.zPosition = 10
        userInput.layer.cornerRadius = 10
        userInput.layer.borderColor = CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        userInput.layer.borderWidth = 2
        userInput.becomeFirstResponder()
        userInput.defaultTextAttributes = textAttributes
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(userInput)
        view.backgroundColor = .systemBlue
        initializeTableViewSettings()
        
        spinner.center = self.view.center
        view.addSubview(spinner)
        spinner.backgroundColor = .red
        spinner.color = .black
        spinner.layer.zPosition = 100
        spinner.tintColor = .blue
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 250, width: Int(view.frame.width), height: Int(view.frame.height) - 250)
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
        label.text = "Search"
//        label.layer.
        label.backgroundColor = .systemBlue
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 50.0)
        label.textAlignment = .center

        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Search", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString

        view.addSubview(label)
    }
    
    func addCountLabel() {
        let label = UILabel(frame: CGRect(x: 10, y: 210, width: 270, height: 50))
        label.text = "Number found: "
        label.backgroundColor = .init(white: 0, alpha: 0.0)
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 26.0)
        label.textAlignment = .left
        label.layer.zPosition = 10
        view.addSubview(label)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let label = labels[2]
        if textField.text!.count < 2 {
            initializeTableViewSettings()
            label.text = "Number found: "
            return
        }
        else {
            clearTableViewSettings()
//            print("----------")
//            print(data.count)
//            print(circleObjectsData.count)
//            print(indicesForCircleObjectsData.count)
            
//            print(textField.text!)
            let searchResults = CoreDataManager().getCircleMatches(userSearch: textField.text!)
            var count = 0
            for search in searchResults {
                count += search.count
            }
//            print(count)
            
            
            
            let themeResults = searchResults[0]
            var themeResult = ""
            
            
            data.append("Results by Theme:")
            circleObjectsData.append("")
            
            for result in themeResults {
                themeResult = result.theme!.capitalized
                if themeResult != "" && data.count == 1 {
                    data.append("Th: \(themeResult)")
                    circleObjectsData.append(result)
                    count -= 39
                }
            }
            
            label.text = "Number found: \(count)"
            
            data.append("")
            circleObjectsData.append("")

            
            let vocabResults = searchResults[1]
            data.append("Results by Circle-ELD Vocabulary:")
            circleObjectsData.append("")
            for result in vocabResults {
                circleObjectsData.append(result)
                data.append("V: \(result.theme!.capitalized) \(result.unit!) :  \(result.vocabulary!)")
            }
            data.append("")
            circleObjectsData.append("")

            
            let abSentenceResults = searchResults[2]
            data.append("Results by Circle-ELD Sentence 1:")
            circleObjectsData.append("")
            for result in abSentenceResults {
                circleObjectsData.append(result)
                data.append("S1, \(result.theme!.capitalized) \(result.unit!) : \(result.abSentence!)")
            }
            data.append("")
            circleObjectsData.append("")
            
            let bcSentenceResults = searchResults[3]
            data.append("Results by Circle-ELD Sentence 2:")
            circleObjectsData.append("")
            for result in bcSentenceResults {
                circleObjectsData.append(result)
                data.append("S2, \(result.theme!.capitalized) \(result.unit!) : \(result.bcSentence!)")
            }
            data.append("")
            circleObjectsData.append("")
            
            let abQuestionResults = searchResults[4]
            data.append("Results by Circle-ELD Question 1:")
            circleObjectsData.append("")
            for result in abQuestionResults {
                circleObjectsData.append(result)
                data.append("Q1, \(result.theme!.capitalized) \(result.unit!) : \(result.abQuestion!)")
            }
            data.append("")
            circleObjectsData.append("")
            
            let bcQuestionResults = searchResults[5]
            data.append("Results by Circle-ELD Question 2:")
            circleObjectsData.append("")
            for result in bcQuestionResults {
                circleObjectsData.append(result)
                data.append("Q2, \(result.theme!.capitalized) \(result.unit!) : \(result.bcQuestion!)")
            }
            data.append("")
            circleObjectsData.append("")
            
            
            
            tableView.reloadData()
        }
        

    }
    @objc func saveCellClickAndOpen(sender: UITapGestureRecognizer) {
        let source = sender.view

        let text : String = source?.value(forKey: "text")! as! String
        let index : Int = Int(source?.value(forKey: "accessibilityIdentifier") as! String)!
        print(text, index)
        if text.starts(with: "Th") {
            let themeNameObject : CircleImage = circleObjectsData[index] as! CircleImage
            let themeName = themeNameObject.theme!
            saveSearch1ToCoreDataAndThenOpen(themeName: themeName)
        }
        if text.starts(with: "V") {
            let circleObject : CircleImage = circleObjectsData[index] as! CircleImage
            saveSearch2ToCoreDataAndThenOpen(circleImage: circleObject)
        }
        if text.starts(with: "S1") {
            let circleObject : CircleImage = circleObjectsData[index] as! CircleImage
            saveSearch3ToCoreDataAndThenOpen(circleImage: circleObject, chosenType: "s1", chosenTypeValue: text)
        }
        if text.starts(with: "S2") {
            let circleObject : CircleImage = circleObjectsData[index] as! CircleImage
            saveSearch3ToCoreDataAndThenOpen(circleImage: circleObject, chosenType: "s2", chosenTypeValue: text)
        }
        if text.starts(with: "Q1") {
            let circleObject : CircleImage = circleObjectsData[index] as! CircleImage
            saveSearch3ToCoreDataAndThenOpen(circleImage: circleObject, chosenType: "q1", chosenTypeValue: text)
        }
        if text.starts(with: "Q2") {
            let circleObject : CircleImage = circleObjectsData[index] as! CircleImage
            saveSearch3ToCoreDataAndThenOpen(circleImage: circleObject, chosenType: "q2", chosenTypeValue: text)
        }
//        print("OBJ::",circleObjectsData[index])

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
    
    func saveSearch3ToCoreDataAndThenOpen(circleImage : CircleImage, chosenType : String, chosenTypeValue : String) {
    //        CoreDataManager().resetAllUserCoreDataToZero()
//        DispatchQueue.main.now() {
//            self.addViewCoverLabel()
//            self.spinner.startAnimating()
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addViewCoverLabel()
            self.spinner.startAnimating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.spinner.stopAnimating()
            self.removeViewCoverLabel()
        }
        let context = appDelegate.persistentContainer.viewContext
        let search3 = NSEntityDescription.insertNewObject(forEntityName: "Search3", into: context)
    
        let time = "\(NSDate().timeIntervalSince1970)"
        let themeText = circleImage.theme!
        if themeText != "" {
            search3.setValue(circleImage.theme!, forKey: "theme")
            search3.setValue("\(circleImage.unit!)", forKey: "unit")
            search3.setValue(circleImage.vocabulary!, forKey: "vocabulary")
            search3.setValue(time, forKey: "timeCreated")
            search3.setValue(circleImage.abSentence, forKey: "s1")
            search3.setValue(circleImage.bcSentence, forKey: "s2")
            search3.setValue(circleImage.abQuestion, forKey: "q1")
            search3.setValue(circleImage.bcQuestion, forKey: "q2")
            search3.setValue(chosenType, forKey: "chosenType")
            search3.setValue(chosenTypeValue, forKey: "chosenTypeValue")
            do {
                try context.save()
                print("Success:  SEARCH3 saved data and now opening Ex1NewViewController")
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }
    
    //            present(Ex1IntroductionViewController(), animated:true, completion:nil)
        }
        if themeText != "" {
            present(Ex1NewViewController(), animated:true, completion:nil)
        }
    
    }
    
    
    func saveSearch2ToCoreDataAndThenOpen(circleImage : CircleImage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addViewCoverLabel()
            self.spinner.startAnimating()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.spinner.stopAnimating()
            self.removeViewCoverLabel()
        }
        let context = appDelegate.persistentContainer.viewContext
        let search2 = NSEntityDescription.insertNewObject(forEntityName: "Search2", into: context)
    
        let time = "\(NSDate().timeIntervalSince1970)"
        let themeText = circleImage.theme!
        if themeText != "" {
            search2.setValue(circleImage.theme!, forKey: "theme")
            search2.setValue("\(circleImage.unit!)", forKey: "unit")
            search2.setValue(circleImage.vocabulary!, forKey: "vocabulary")
            search2.setValue(time, forKey: "timeCreated")
            search2.setValue(circleImage.vocabulary!, forKey: "chosenTypeValue")
            search2.setValue("vocabulary", forKey: "chosenType")
            
            do {
                try context.save()
                print("Success: Search2 saved data and now opening saveSearch2ToCoreDataAndThenOpen")
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }
    
    //            present(Ex1IntroductionViewController(), animated:true, completion:nil)
        }
        if themeText != "" {
            present(Ex1NewViewController(), animated:true, completion:nil)
        }
    
    }

    func saveSearch1ToCoreDataAndThenOpen(themeName : String) {
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
        let context = appDelegate.persistentContainer.viewContext
        let search1 = NSEntityDescription.insertNewObject(forEntityName: "Search1", into: context)

        let theme = themeName
        print("theme::", theme)
        let time = "\(NSDate().timeIntervalSince1970)"
        if !theme.starts(with: "No Theme") && theme != "" {
            search1.setValue(theme.lowercased(), forKey: "theme")
            search1.setValue(time, forKey: "timeCreated")
            do {
                try context.save()
                print("Success: \(theme.lowercased()) saved as saveSearch1ToCoreDataAndThenOpen")
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }
            present(MainTabBarViewController(), animated:true, completion:nil)
        }
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        do {
            let cellText = try data[indexPath.row]
            
            try cell.textLabel?.text = cellText
            if cellText == "" {
                try cell.backgroundColor = .white
                try cell.isUserInteractionEnabled = false
            } else if cellText.starts(with: "Results") {
                try cell.backgroundColor = .systemIndigo
                try cell.imageView?.tintColor = .white
                try cell.tintColor = .white
                try cell.isUserInteractionEnabled = false
                
            }
            else {
                try cell.backgroundColor = .systemTeal
                try cell.isUserInteractionEnabled = true
                cell.accessibilityIdentifier = "\(indexPath.row)"
                try cell.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(saveCellClickAndOpen(sender:))))
            }
        } catch {
            cell.textLabel?.text = ""
            try cell.backgroundColor = .white
            try cell.isUserInteractionEnabled = false
        }
        return cell
    }

               
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showIndicator()
    }
                
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deinitializeIndicator()
    }


    @objc func startContinuosShowingIndicator() {
        UIView.animate(withDuration: 1.5) {
            self.tableView.flashScrollIndicators()
        }
    }

    func showIndicator() {
        self.timerForIndicator = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.startContinuosShowingIndicator), userInfo: nil, repeats: true)
    }

    func deinitializeIndicator() {
        self.timerForIndicator?.invalidate()
        self.timerForIndicator = nil
    }
    
    func initializeTableViewSettings() {
        circleObjectsData.removeAll()
        data.removeAll()
        data.append("Results by Theme:")
        data.append("")
        data.append("Results by Circle-ELD Vocabulary:")
        data.append("")
        data.append("Results by Circle-ELD Sentence 1:")
        data.append("")
        data.append("Results by Circle-ELD Sentence 2:")
        data.append("")
        data.append("Results by Circle-ELD Question 1:")
        data.append("")
        data.append("Results by Circle-ELD Question 2:")
        data.append("")
        tableView.reloadData()
    }
    func clearTableViewSettings() {
        circleObjectsData.removeAll()
        data.removeAll()
        tableView.reloadData()
    }
    
}
