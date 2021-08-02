//
//  SearchResultsViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit
import Foundation
import CoreData
import AVFoundation

class Ex1NewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AVSpeechSynthesizerDelegate {
    let appDelegate = AppDelegate()
    let chooseImagePickerView = UIPickerView()
    let synthesizer = AVSpeechSynthesizer()
    var allCircleImages = CoreDataManager().accessAllCircleImages()
    let chosenImageView = UIImageView()
    let currentVocabLabel = UILabel()
    let themeAndUnitNumberHeaderLabel = UILabel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        while allCircleImages.count > 400 { allCircleImages.removeLast()}
//        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        chooseImagePickerView.frame = CGRect(x: (view.frame.size.width / 3) + 18, y: 470.0, width: 100.0, height: view.frame.size.width + 31 )
        chooseImagePickerView.delegate = self
        chooseImagePickerView.dataSource = self
        chooseImagePickerView.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        chooseImagePickerView.backgroundColor = .systemIndigo

        let urls = getCircleDataForThisUnit(dataForm: "urls")

        let rowString = urls[0]
        let url1 = URL(string: rowString)!
        let data1 = try? Data(contentsOf: url1)
        chosenImageView.image = UIImage(data: data1!)
        chosenImageView.contentMode = .scaleAspectFit
        chosenImageView.frame = CGRect(x: 20, y: 70, width: view.frame.size.width - 40, height: 340)
        view.addSubview(chosenImageView)
        view.addSubview(chooseImagePickerView)
        view.backgroundColor = .systemGray2
        
        addVocabLabels()
        addImageInformationButtons()
        updateSpeechButtons(row: 0)
        
        let themes = ["body", "color", "fall", "geography", "house", "plant", "space", "transportation", "water", "world culture"]
        var unitNumber = Int.random(in: 1..<5)
        let randomThemeIndex = Int.random(in: 0..<10)
        
        var theme = themes[randomThemeIndex]

        var vocabulary = ""
        var chosenType = ""
        var chosenTypeValue = ""
        
        let userThemeUnitChoices = CoreDataManager().accessUsersThemeUnitChoice()
        let userSearch2s = CoreDataManager().accessSearch2CoreData()
        let randomChoice = CoreDataManager().accessRandomChoiceCoreData()
        let userSearch3s = CoreDataManager().accessSearch3CoreData()
        
        
        let userThemeUnitChoicesTimestamp : Double = ((Double(userThemeUnitChoices[2])) ?? 0.0)!
        let userSearch2Timestamp : Double = ((Double(userSearch2s[3])) ?? 0.0)!
        let randomChoiceTimestamp : Double = ((Double(randomChoice[0])) ?? 0.0)!
        let userSearch3Timestamp : Double = ((Double(userSearch3s[3])) ?? 0.0)!
        
        var times : [Double] = []
        times.append(userThemeUnitChoicesTimestamp)
        times.append(userSearch2Timestamp)
        times.append(randomChoiceTimestamp)
        times.append(userSearch3Timestamp)

        let mostRecentTime = times.max()
        if mostRecentTime == randomChoiceTimestamp {
            theme = randomChoice[1]
            unitNumber = Int(randomChoice[2])!
            vocabulary = randomChoice[3]
            chosenType = randomChoice[4]
            chosenTypeValue = randomChoice[3]
        } else if mostRecentTime == userThemeUnitChoicesTimestamp {
            theme = userThemeUnitChoices[0]
            unitNumber = Int(userThemeUnitChoices[1])!
            vocabulary = userThemeUnitChoices[4]
            chosenType = userThemeUnitChoices[3]
            chosenTypeValue = userThemeUnitChoices[4]
        }
        else if mostRecentTime == userSearch2Timestamp{
            theme = userSearch2s[0]
            unitNumber = Int(userSearch2s[1])!
            vocabulary = userSearch2s[2]
            chosenType = userSearch2s[4]
            chosenTypeValue = userSearch2s[5]
        }
        else if mostRecentTime == userSearch3Timestamp {
            theme = userSearch3s[0]
            unitNumber = Int(userSearch3s[1])!
            vocabulary = userSearch3s[2]
            chosenType = userSearch3s[8]
            chosenTypeValue = userSearch3s[9]
        }

        if theme.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "world culture" {
            theme = "worldCulture"
        }
    
        selectConditionsFromSearch(conditions: [theme, String(unitNumber), vocabulary, chosenType, chosenTypeValue])

    }
    
    func selectConditionsFromSearch(conditions : [String]) {
        let searchType = conditions[3]
        let data = getCircleDataForThisUnit(dataForm: searchType)
        
        var chosenTypeValue = conditions[4]
        if !chosenTypeValue.contains(":") {
            chosenTypeValue = " :" + chosenTypeValue
        }
        
        var searchString : String = String(chosenTypeValue.split(separator: ":")[1])
        searchString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        var index = 0
        for circleImage in data {
            if circleImage == searchString {
                break
            }
            index += 1
        }
        self.pickerView(self.chooseImagePickerView, didSelectRow: index, inComponent: 0)
        self.chooseImagePickerView.selectRow(index, inComponent: 0, animated: true)
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let label = labels[5]
        label.text = searchString
        if !label.text!.contains(" ") {
            label.font = UIFont.boldSystemFont(ofSize: 25.0)
            label.numberOfLines = 0
        }
        else {
            label.font = UIFont.boldSystemFont(ofSize: 25.0)
            label.numberOfLines = 0
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(.strokeColor, value: UIColor.black, range: characterRange)
        mutableAttributedString.addAttribute(.backgroundColor, value:  UIColor.systemGray6, range: characterRange)
        
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let label = labels[5]
        label.attributedText = mutableAttributedString
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let label = labels[5]
        label.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
//    @objc func rotated() {
//        if UIDevice.current.orientation.isLandscape {
//            chosenImageView.frame = CGRect(x: 0, y: 10, width: view.frame.size.width, height: view.frame.size.height)
//            themeAndUnitNumberHeaderLabel.frame     = CGRect(x: 3, y: 3, width: 100, height: 40)
//            themeAndUnitNumberHeaderLabel.font = UIFont(name: "AppleSDGothicNeo", size: 28.0)
//            currentVocabLabel.frame                 = CGRect(x: 3, y: 350, width: 140, height: 40)
//
//            print("Landscape")
//        }
//
//        if UIDevice.current.orientation.isPortrait {
//            chosenImageView.frame = CGRect(x: 20, y: 70, width: view.frame.size.width - 40, height: 340)
//
//
//            themeAndUnitNumberHeaderLabel.frame = CGRect(x: 0, y: 30, width: Int(view.bounds.width), height: 40)
//            themeAndUnitNumberHeaderLabel.font = UIFont.boldSystemFont(ofSize: 45.0)
//            currentVocabLabel.frame = CGRect(x: 30, y: 430, width: view.frame.size.width - 60, height: 130)
//
//            print("Portrait")
//        }
//    }
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 20
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 120
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let urls = getCircleDataForThisUnit(dataForm: "urls")
        return urls.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let urls = getCircleDataForThisUnit(dataForm: "urls")
        return urls[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let urls = getCircleDataForThisUnit(dataForm: "urls")
        let vocab = getCircleDataForThisUnit(dataForm: "vocabulary")

        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let currentTextLabel = labels[5]
        currentTextLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        currentTextLabel.textAlignment = .center
        currentTextLabel.text = vocab[row]
        currentTextLabel.numberOfLines = 0
        updateVocabLabels()
        updateSpeechButtons(row: row)

        updateCurrentIndexAndVocab(row: row, vocab: vocab[row])

        let rowString = urls[row]
        let url1 = URL(string: rowString)!
        let data1 = try? Data(contentsOf: url1)

        chosenImageView.image = UIImage(data: data1!)

        let images = self.view.subviews.compactMap { $0 as? UIImageView }

        for image in images {
            image.removeFromSuperview()
        }
        chosenImageView.contentMode = .scaleAspectFit
        view.addSubview(chosenImageView)

        view.sendSubviewToBack(chosenImageView)

    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        myView.backgroundColor = .systemBlue

        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        myImageView.transform = CGAffineTransform(rotationAngle: -270 * (.pi / 180))

        let urls = getCircleDataForThisUnit(dataForm: "urls")
        
        var rowString = String()
        switch row {
        case 0:
            rowString = urls[0]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 1:
            rowString = urls[1]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 2:
            rowString = urls[2]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 3:
            rowString = urls[3]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 4:
            rowString = urls[4]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 5:
            rowString = urls[5]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 6:
            rowString = urls[6]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 7:
            rowString = urls[7]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 8:
            rowString = urls[8]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 9:
            rowString = urls[9]
            let url1 = URL(string: rowString)!
            let data1 = try? Data(contentsOf: url1)
            myImageView.image = UIImage(data: data1!)

        case 10:
            break
            default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        myView.addSubview(myImageView)
        
        return myView
    }

    func getCircleDataForThisUnit(dataForm: String) -> [String] {
        let themes = ["body", "color", "fall", "geography", "house", "plant", "space", "transportation", "water", "world culture"]
        var unitNumber = Int.random(in: 1..<5)
        let randomThemeIndex = Int.random(in: 0..<10)
        var theme = themes[randomThemeIndex]

        var vocabulary = ""
        var chosenType = ""
        var chosenTypeValue = ""
        
        let userThemeUnitChoices = CoreDataManager().accessUsersThemeUnitChoice()
        let userSearch2s = CoreDataManager().accessSearch2CoreData()
        let randomChoice = CoreDataManager().accessRandomChoiceCoreData()
        let userSearch3s = CoreDataManager().accessSearch3CoreData()
        
        
        let userThemeUnitChoicesTimestamp : Double = ((Double(userThemeUnitChoices[2])) ?? 0.0)!
        let userSearch2Timestamp : Double = ((Double(userSearch2s[3])) ?? 0.0)!
        let randomChoiceTimestamp : Double = ((Double(randomChoice[0])) ?? 0.0)!
        let userSearch3Timestamp : Double = ((Double(userSearch3s[3])) ?? 0.0)!
        
        var times : [Double] = []
        times.append(userThemeUnitChoicesTimestamp)
        times.append(userSearch2Timestamp)
        times.append(randomChoiceTimestamp)
        times.append(userSearch3Timestamp)

        let mostRecentTime = times.max()
        if mostRecentTime == randomChoiceTimestamp {
            theme = randomChoice[1]
            unitNumber = Int(randomChoice[2])!
            vocabulary = randomChoice[3]
            chosenType = randomChoice[4]
            chosenTypeValue = randomChoice[3]
        } else if mostRecentTime == userThemeUnitChoicesTimestamp {
            theme = userThemeUnitChoices[0]
            unitNumber = Int(userThemeUnitChoices[1])!
            vocabulary = userThemeUnitChoices[4]
            chosenType = userThemeUnitChoices[3]
            chosenTypeValue = userThemeUnitChoices[4]
        }
        else if mostRecentTime == userSearch2Timestamp{
            theme = userSearch2s[0]
            unitNumber = Int(userSearch2s[1])!
            vocabulary = userSearch2s[2]
            chosenType = userSearch2s[4]
            chosenTypeValue = userSearch2s[5]
        }
        else if mostRecentTime == userSearch3Timestamp {
            theme = userSearch3s[0]
            unitNumber = Int(userSearch3s[1])!
            vocabulary = userSearch3s[2]
            chosenType = userSearch3s[8]
            chosenTypeValue = userSearch3s[9]
        }

        if theme.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "world culture" {
            theme = "worldCulture"
        }
        
        let buttons = self.view.subviews.compactMap { $0 as? UIButton }
        for button in buttons {
            if chosenType == "vocabulary" {
                if button.titleLabel?.text! == "Word" {
                    button.backgroundColor = .systemTeal
                } else {
                    button.backgroundColor = .systemIndigo
                }
            }
            else if chosenType == "s1" {
                if button.titleLabel?.text! == "S 1" {
                    button.backgroundColor = .systemTeal
                } else {
                    button.backgroundColor = .systemIndigo
                }
            }
            else if chosenType == "s2" {
                if button.titleLabel?.text! == "S 2" {
                    button.backgroundColor = .systemTeal
                } else {
                    button.backgroundColor = .systemIndigo
                }
            }
            else if chosenType == "q1" {
                if button.titleLabel?.text! == "Q 1" {
                    button.backgroundColor = .systemTeal
                } else {
                    button.backgroundColor = .systemIndigo
                }
            }
            else if chosenType == "q2" {
                if button.titleLabel?.text! == "Q 2" {
                    button.backgroundColor = .systemTeal
                } else {
                    button.backgroundColor = .systemIndigo
                }
            }
        }
        
        
        
        switch dataForm {
        case "vocabulary":
            var vocab: [String] = []
            for image in self.allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        vocab.append(image.vocabulary!)
                    }
                }
            }
            return vocab
        case "abSentences", "s1":
            var abSentences: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        abSentences.append(image.abSentence!)
                    }
                }
            }
            return abSentences
        case "bcSentences", "s2":
            var bcSentences: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        bcSentences.append(image.bcSentence!)
                    }
                }
            }
            return bcSentences
        case "abQuestions", "q1":
            var abQuestions: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        abQuestions.append(image.abQuestion!)
                    }
                }
            }
            return abQuestions
        case "bcQuestions", "q2":
            var bcQuestions: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        bcQuestions.append(image.bcQuestion!)
                    }
                }
            }
            return bcQuestions
        case "urls":
            var urls: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        urls.append(image.photo!)
                    }
                }
            }
            return urls
        default:
                return ["Incorrect parameter"]
            
        }
    }
    
    func updateCurrentIndexAndVocab(row: Int, vocab: String) {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let hiddenIndexLabel = labels[6]
        hiddenIndexLabel.text = "\(row)"
        
        let hiddenVocabLabel = labels[8]
        hiddenVocabLabel.text = vocab
    }
    
    @objc func speakVocab() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let vocabulary = getCircleDataForThisUnit(dataForm: "vocabulary")[index!]

        let thingToSpeak = vocabulary
        let utterance = AVSpeechUtterance(string: thingToSpeak)
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        
        
        let mainDisplayLabel = labels[5]
        mainDisplayLabel.text = vocabulary
        mainDisplayLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        mainDisplayLabel.textAlignment = .center
        mainDisplayLabel.numberOfLines = 0
        
        let buttons = self.view.subviews.compactMap { $0 as? UIButton }
        for button in buttons {
            if button.titleLabel?.text! == "Word" {
                button.backgroundColor = .systemTeal
            } else {
                button.backgroundColor = .systemIndigo
            }
        }
        
    }
    
    @objc func speakSentence1() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }

        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let absentence = getCircleDataForThisUnit(dataForm: "abSentences")[index!]

        let thingToSpeak = absentence
        let utterance = AVSpeechUtterance(string: thingToSpeak)
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        
        let mainDisplayLabel = labels[5]
        mainDisplayLabel.text = absentence
        mainDisplayLabel.font = UIFont(name: "AppleSDGothicNeo", size: 30.0)
        mainDisplayLabel.textAlignment = .left
        mainDisplayLabel.numberOfLines = 0
        
        let buttons = self.view.subviews.compactMap { $0 as? UIButton }
        for button in buttons {
            if button.titleLabel?.text! == "S 1" {
                button.backgroundColor = .systemTeal
            } else {
                button.backgroundColor = .systemIndigo
            }
        }
    }
    
    @objc func speakSentence2() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let bcsentence = getCircleDataForThisUnit(dataForm: "bcSentences")[index!]

        let thingToSpeak = bcsentence
        let utterance = AVSpeechUtterance(string: thingToSpeak)
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        
        let mainDisplayLabel = labels[5]
        mainDisplayLabel.text = bcsentence
        mainDisplayLabel.font = UIFont(name: "AppleSDGothicNeo", size: 30.0)
        mainDisplayLabel.textAlignment = .left
        mainDisplayLabel.numberOfLines = 0
        
        let buttons = self.view.subviews.compactMap { $0 as? UIButton }
        for button in buttons {
            if button.titleLabel?.text! == "S 2" {
                button.backgroundColor = .systemTeal
            } else {
                button.backgroundColor = .systemIndigo
            }
        }
        
    }
    
    @objc func speakQuestion1() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let abQuestion = getCircleDataForThisUnit(dataForm: "abQuestions")[index!]

        let thingToSpeak = abQuestion
        let utterance = AVSpeechUtterance(string: thingToSpeak)
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        
        let mainDisplayLabel = labels[5]
        mainDisplayLabel.text = abQuestion
        mainDisplayLabel.font = UIFont(name: "AppleSDGothicNeo", size: 22.0)
        mainDisplayLabel.textAlignment = .left
        mainDisplayLabel.numberOfLines = 0
        
        let buttons = self.view.subviews.compactMap { $0 as? UIButton }
        for button in buttons {
            if button.titleLabel?.text! == "Q 1" {
                button.backgroundColor = .systemTeal
            } else {
                button.backgroundColor = .systemIndigo
            }
        }
    }
    
    @objc func speakQuestion2() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let bcQuestion = getCircleDataForThisUnit(dataForm: "bcQuestions")[index!]

        let thingToSpeak = bcQuestion
        let utterance = AVSpeechUtterance(string: thingToSpeak)
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        
        let mainDisplayLabel = labels[5]
        mainDisplayLabel.text = bcQuestion
        mainDisplayLabel.font = UIFont(name: "AppleSDGothicNeo", size: 22.0)
        mainDisplayLabel.textAlignment = .left
        mainDisplayLabel.numberOfLines = 0
        
        let buttons = self.view.subviews.compactMap { $0 as? UIButton }
        for button in buttons {
            if button.titleLabel?.text! == "Q 2" {
                button.backgroundColor = .systemTeal
            } else {
                button.backgroundColor = .systemIndigo
            }
        }
    }
    
    func updateSpeechButtons(row: Int) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        let buttons = self.view.subviews.compactMap { $0 as? UIButton }
        let wordButton = buttons[0]
        let sent1Button = buttons[1]
        let sent2Button = buttons[2]
        let ques1Button = buttons[3]
        let ques2Button = buttons[4]
        
        wordButton.addTarget(self, action: #selector(speakVocab), for: .touchUpInside)
        sent1Button.addTarget(self, action: #selector(speakSentence1), for: .touchUpInside)
        sent2Button.addTarget(self, action: #selector(speakSentence2), for: .touchUpInside)
        ques1Button.addTarget(self, action: #selector(speakQuestion1), for: .touchUpInside)
        ques2Button.addTarget(self, action: #selector(speakQuestion2), for: .touchUpInside)
    }
    
    func updateVocabLabels() {
        let vocab = getCircleDataForThisUnit(dataForm: "vocabulary")
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let currentTextLabelText = labels[5].text
        if currentTextLabelText == vocab[0] {
            labels[0].backgroundColor = VariablesManager.vocabBackgroundColors[4]
            labels[1].backgroundColor = VariablesManager.vocabBackgroundColors[3]
            labels[2].backgroundColor = VariablesManager.vocabBackgroundColors[2]
            labels[3].backgroundColor = VariablesManager.vocabBackgroundColors[1]
            labels[4].backgroundColor = VariablesManager.vocabBackgroundColors[0]
        }
        else if currentTextLabelText == vocab[2] {
            labels[0].backgroundColor = VariablesManager.vocabBackgroundColors[3]
            labels[1].backgroundColor = VariablesManager.vocabBackgroundColors[2]
            labels[2].backgroundColor = VariablesManager.vocabBackgroundColors[1]
            labels[3].backgroundColor = VariablesManager.vocabBackgroundColors[0]
            labels[4].backgroundColor = VariablesManager.vocabBackgroundColors[1]
        }
        else if currentTextLabelText == vocab[4] {
            labels[0].backgroundColor = VariablesManager.vocabBackgroundColors[2]
            labels[1].backgroundColor = VariablesManager.vocabBackgroundColors[1]
            labels[2].backgroundColor = VariablesManager.vocabBackgroundColors[0]
            labels[3].backgroundColor = VariablesManager.vocabBackgroundColors[1]
            labels[4].backgroundColor = VariablesManager.vocabBackgroundColors[2]
        }
        else if currentTextLabelText == vocab[6] {
            labels[0].backgroundColor = VariablesManager.vocabBackgroundColors[1]
            labels[1].backgroundColor = VariablesManager.vocabBackgroundColors[0]
            labels[2].backgroundColor = VariablesManager.vocabBackgroundColors[1]
            labels[3].backgroundColor = VariablesManager.vocabBackgroundColors[2]
            labels[4].backgroundColor = VariablesManager.vocabBackgroundColors[3]
        }
        else if currentTextLabelText == vocab[8] {
            labels[0].backgroundColor = VariablesManager.vocabBackgroundColors[0]
            labels[1].backgroundColor = VariablesManager.vocabBackgroundColors[1]
            labels[2].backgroundColor = VariablesManager.vocabBackgroundColors[2]
            labels[3].backgroundColor = VariablesManager.vocabBackgroundColors[3]
            labels[4].backgroundColor = VariablesManager.vocabBackgroundColors[4]
        }
    }

    func addImageInformationButtons() {
        let width = 60
        let height = 50
        let middle = Int(view.layer.bounds.midX)
        let y = 580
        let wordButton      = UIButton(frame: CGRect(x: middle - 190, y: y, width: width, height: height))
        let sentence1Button = UIButton(frame: CGRect(x: middle - 110, y: y, width: width, height: height))
        let sentence2Button = UIButton(frame: CGRect(x: middle - 30, y: y, width: width, height: height))
        let question1Button = UIButton(frame: CGRect(x: middle + 50, y: y, width: width, height: height))
        let question2Button = UIButton(frame: CGRect(x: middle + 130, y: y, width: width, height: height))
        
        wordButton.setTitle("Word", for: .normal)
        sentence1Button.setTitle("S 1", for: .normal)
        sentence2Button.setTitle("S 2", for: .normal)
        question1Button.setTitle("Q 1", for: .normal)
        question2Button.setTitle("Q 2", for: .normal)

        let buttons = [wordButton, sentence1Button, sentence2Button, question1Button, question2Button]
        for button in buttons {
            button.backgroundColor = .systemIndigo
            button.layer.cornerRadius = 10
        }
        
        view.addSubview(wordButton)
        view.addSubview(sentence1Button)
        view.addSubview(sentence2Button)
        view.addSubview(question1Button)
        view.addSubview(question2Button)
    }
    @objc func adjustToCorrectVocab(sender: UITapGestureRecognizer) {
        print("inside adjustToCorrectVocab")
        let source = sender.view
        let index : Int = Int(source?.value(forKey: "accessibilityIdentifier") as! String)!

        self.pickerView(self.chooseImagePickerView, didSelectRow: index, inComponent: 0)
        self.chooseImagePickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    func addVocabLabels() {
        let vocab = getCircleDataForThisUnit(dataForm: "vocabulary")
        let width = 80
        let height = 60
        let middle = Int(view.layer.bounds.midX)
        let y = 750
        let vocab5LabelLeft = UILabel(frame: CGRect(x: middle + 120, y: y, width: width, height: height))
        vocab5LabelLeft.layer.zPosition = 100
        vocab5LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[4]
        vocab5LabelLeft.textAlignment = .center
        vocab5LabelLeft.text = vocab[8]
        vocab5LabelLeft.numberOfLines = 0
        vocab5LabelLeft.accessibilityIdentifier = "8"
        vocab5LabelLeft.isUserInteractionEnabled = true
        vocab5LabelLeft.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(adjustToCorrectVocab(sender:))))

        let vocab4LabelLeft = UILabel(frame: CGRect(x: middle + 40, y: y, width: width, height: height))
        vocab4LabelLeft.layer.zPosition = 100
        vocab4LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[3]
        vocab4LabelLeft.text = vocab[6]
        vocab4LabelLeft.numberOfLines = 0
        vocab4LabelLeft.textAlignment = .center
        vocab4LabelLeft.accessibilityIdentifier = "6"
        vocab4LabelLeft.isUserInteractionEnabled = true
        vocab4LabelLeft.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(adjustToCorrectVocab(sender:))))

        let vocab3LabelLeft = UILabel(frame: CGRect(x: middle - 40, y: y, width: width, height: height))
        vocab3LabelLeft.layer.zPosition = 100
        vocab3LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[2]
        vocab3LabelLeft.text = vocab[4]
        vocab3LabelLeft.numberOfLines = 0
        vocab3LabelLeft.textAlignment = .center
        vocab3LabelLeft.accessibilityIdentifier = "4"
        vocab3LabelLeft.isUserInteractionEnabled = true
        vocab3LabelLeft.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(adjustToCorrectVocab(sender:))))

        let vocab2LabelLeft = UILabel(frame: CGRect(x: middle - 120, y: y, width: width, height: height))
        vocab2LabelLeft.layer.zPosition = 100
        vocab2LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[1]
        vocab2LabelLeft.text = vocab[2]
        vocab2LabelLeft.numberOfLines = 0
        vocab2LabelLeft.textAlignment = .center
        vocab2LabelLeft.accessibilityIdentifier = "2"
        vocab2LabelLeft.isUserInteractionEnabled = true
        vocab2LabelLeft.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(adjustToCorrectVocab(sender:))))

        let vocab1LabelLeft = UILabel(frame: CGRect(x: middle - 200, y: y, width: width, height: height))
        vocab1LabelLeft.layer.zPosition = 100
        vocab1LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[0]
        vocab1LabelLeft.text = vocab[0]
        vocab1LabelLeft.numberOfLines = 0
        vocab1LabelLeft.textAlignment = .center
        vocab1LabelLeft.accessibilityIdentifier = "0"
        vocab1LabelLeft.isUserInteractionEnabled = true
        vocab1LabelLeft.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(adjustToCorrectVocab(sender:))))

        currentVocabLabel.frame = CGRect(x: 30, y: 430, width: view.frame.size.width - 60, height: 130)
        currentVocabLabel.backgroundColor = VariablesManager.vocabBackgroundColors[0]
        currentVocabLabel.text = vocab[0]
        currentVocabLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        currentVocabLabel.textAlignment = .center
        currentVocabLabel.accessibilityIdentifier = "currentVocabLabel"

        view.addSubview(vocab5LabelLeft)
        view.addSubview(vocab4LabelLeft)
        view.addSubview(vocab3LabelLeft)
        view.addSubview(vocab2LabelLeft)
        view.addSubview(vocab1LabelLeft)
        view.addSubview(currentVocabLabel)
        
        let hiddenIndexLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        hiddenIndexLabel.text = "0"
        view.addSubview(hiddenIndexLabel)
        
        
//        let themes = ["body", "color", "fall", "geography", "house", "plant", "space", "transportation", "water", "world culture"]
        var unitNumber = 1
        var theme = "body"

        let userThemeUnitChoices = CoreDataManager().accessUsersThemeUnitChoice()
        let userSearch2s = CoreDataManager().accessSearch2CoreData()
        let randomChoice = CoreDataManager().accessRandomChoiceCoreData()
        let userSearch3s = CoreDataManager().accessSearch3CoreData()
        
        let userThemeUnitChoicesTimestamp : Double = ((Double(userThemeUnitChoices[2])) ?? 0.0)!
        let userSearch2Timestamp : Double = ((Double(userSearch2s[3])) ?? 0.0)!
        let randomChoiceTimestamp : Double = ((Double(randomChoice[0])) ?? 0.0)!
        let userSearch3Timestamp : Double = ((Double(userSearch3s[3])) ?? 0.0)!

        var times : [Double] = []
        times.append(userThemeUnitChoicesTimestamp)
        times.append(userSearch2Timestamp)
        times.append(randomChoiceTimestamp)
        times.append(userSearch3Timestamp)

        let mostRecentTime = times.max()
        if mostRecentTime == randomChoiceTimestamp {
            unitNumber = Int(randomChoice[2])!
            theme = randomChoice[1]
        } else if mostRecentTime == userThemeUnitChoicesTimestamp {
            theme = userThemeUnitChoices[0]
        }
        else if mostRecentTime == userSearch2Timestamp{
            theme = userSearch2s[0]
            unitNumber = Int(userSearch2s[1])!

        }
        else if mostRecentTime == userSearch3Timestamp {
            theme = userSearch3s[0]
            unitNumber = Int(userSearch3s[1])!
        }

        if theme.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "world culture" {
            theme = "worldCulture"
        }

        themeAndUnitNumberHeaderLabel.frame = CGRect(x: 0, y: 30, width: Int(view.bounds.width), height: 40)
        themeAndUnitNumberHeaderLabel.text = "\(theme.capitalized) \(unitNumber)"
        themeAndUnitNumberHeaderLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        themeAndUnitNumberHeaderLabel.textAlignment = .center
        view.addSubview(themeAndUnitNumberHeaderLabel)
        
        let hiddenCurrentVocabLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        hiddenCurrentVocabLabel.text = "randomText"
        view.addSubview(hiddenCurrentVocabLabel)
    }
}


