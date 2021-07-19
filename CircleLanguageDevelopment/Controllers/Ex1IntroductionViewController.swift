//
//  StudentActivityChoiceViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/12/21.
//


import UIKit
import Foundation
import CoreData
import AVFoundation

class Ex1IntroductionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        currentTextLabel.text = vocab[row]
        updateVocabLabels()
        updateSpeechButtons(row: row)
        updateCurrentIndex(row: row)
        let myBackgroundImageView = UIImageView(frame: CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: 300))
        let rowString = urls[row]
        let url1 = URL(string: rowString)!
        let data1 = try? Data(contentsOf: url1)
        print(labels.count)

        myBackgroundImageView.image = UIImage(data: data1!)

        let images = self.view.subviews.compactMap { $0 as? UIImageView }
        print(images.count)
        for image in images {
            image.removeFromSuperview()
        }
        myBackgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(myBackgroundImageView)

        view.sendSubviewToBack(myBackgroundImageView)

    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var myView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        myView.backgroundColor = .systemBlue

        var myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
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
        var allCircleImages = self.obtainCircleImages()
        while allCircleImages.count > 400 { allCircleImages.removeLast()}
        let userThemeUnitChoice = getUsersThemeUnitChoice()
        let unitNumber = userThemeUnitChoice.last!.wholeNumberValue.unsafelyUnwrapped
        //        print("unitNumber", unitNumber, type(of: unitNumber))
        var theme = String(userThemeUnitChoice[userThemeUnitChoice.index(userThemeUnitChoice.startIndex, offsetBy:0)..<userThemeUnitChoice.index(userThemeUnitChoice.endIndex, offsetBy: -1)])
        if theme.trimmingCharacters(in: .whitespacesAndNewlines) == "world culture" {
            theme = "worldCulture"
        }
        switch dataForm {
        case "vocabulary":
            var vocab: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        vocab.append(image.vocabulary!)
                    }
                }
            }
            return vocab
        case "abSentences":
            var abSentences: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        abSentences.append(image.abSentence!)
                    }
                }
            }
            return abSentences
        case "bcSentences":
            var bcSentences: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        bcSentences.append(image.bcSentence!)
                    }
                }
            }
            return bcSentences
        case "abQuestions":
            var abQuestions: [String] = []
            for image in allCircleImages {
                if image.theme.unsafelyUnwrapped == theme.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if image.unit == unitNumber {
                        abQuestions.append(image.abQuestion!)
                    }
                }
            }
            return abQuestions
        case "bcQuestions":
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
    
    func updateCurrentIndex(row: Int) {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let hiddenIndexLabel = labels[6]
        hiddenIndexLabel.text = "\(row)"
    }
    
    @objc func speakVocab() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let vocab = labels[5].text
        
        let thingToSpeak = vocab!
        let utterance = AVSpeechUtterance(string: thingToSpeak)

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    @objc func speakSentence1() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let absentence = getCircleDataForThisUnit(dataForm: "abSentences")[index!]

        let thingToSpeak = absentence
        let utterance = AVSpeechUtterance(string: thingToSpeak)

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    @objc func speakSentence2() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let bcsentence = getCircleDataForThisUnit(dataForm: "bcSentences")[index!]

        let thingToSpeak = bcsentence
        let utterance = AVSpeechUtterance(string: thingToSpeak)

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    @objc func speakQuestion1() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let abQuestion = getCircleDataForThisUnit(dataForm: "abQuestions")[index!]

        let thingToSpeak = abQuestion
        let utterance = AVSpeechUtterance(string: thingToSpeak)

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    @objc func speakQuestion2() {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        let indexText = labels[6].text

        let index = indexText?.last!.wholeNumberValue.unsafelyUnwrapped
        let bcQuestion = getCircleDataForThisUnit(dataForm: "bcQuestions")[index!]

        let thingToSpeak = bcQuestion
        let utterance = AVSpeechUtterance(string: thingToSpeak)

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    
    func updateSpeechButtons(row: Int) {
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

    func addSoundButtons() {
        let width = 50
        let height = 40
        let wordButton = UIButton(frame: CGRect(x: 140, y: 420, width: width, height: height))
        let sentence1Button = UIButton(frame: CGRect(x: 140, y: 480, width: width, height: height))
        let sentence2Button = UIButton(frame: CGRect(x: 210, y: 480, width: width, height: height))
        let question1Button = UIButton(frame: CGRect(x: 140, y: 540, width: width, height: height))
        let question2Button = UIButton(frame: CGRect(x: 210, y: 540, width: width, height: height))
        
        wordButton.setTitle("Word", for: .normal)
        sentence1Button.setTitle("S 1", for: .normal)
        sentence2Button.setTitle("S 2", for: .normal)
        question1Button.setTitle("Q 1", for: .normal)
        question2Button.setTitle("Q 2", for: .normal)
        
        let buttons = [wordButton, sentence1Button, sentence2Button, question1Button, question2Button]
        for button in buttons {
            button.backgroundColor = .systemIndigo
        }
        
        view.addSubview(wordButton)
        view.addSubview(sentence1Button)
        view.addSubview(sentence2Button)
        view.addSubview(question1Button)
        view.addSubview(question2Button)
    }
    
    func addVocabLabels() {
        let vocab = getCircleDataForThisUnit(dataForm: "vocabulary")
        let vocab5LabelLeft = UILabel(frame: CGRect(x: 5, y: 410, width: 100, height: 30))
        vocab5LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[4]
        vocab5LabelLeft.textAlignment = .center
        vocab5LabelLeft.text = vocab[8]
        vocab5LabelLeft.accessibilityIdentifier = "vocab5LabelLeft"
        
        let vocab4LabelLeft = UILabel(frame: CGRect(x: 5, y: 445, width: 100, height: 30))
        vocab4LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[3]
        vocab4LabelLeft.text = vocab[6]
        vocab4LabelLeft.textAlignment = .center
        vocab4LabelLeft.accessibilityIdentifier = "vocab4LabelLeft"
        
        let vocab3LabelLeft = UILabel(frame: CGRect(x: 5, y: 480, width: 100, height: 30))
        vocab3LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[2]
        vocab3LabelLeft.text = vocab[4]
        vocab3LabelLeft.textAlignment = .center
        vocab3LabelLeft.accessibilityIdentifier = "vocab3LabelLeft"
        
        let vocab2LabelLeft = UILabel(frame: CGRect(x: 5, y: 515, width: 100, height: 30))
        vocab2LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[1]
        vocab2LabelLeft.text = vocab[2]
        vocab2LabelLeft.textAlignment = .center
        vocab2LabelLeft.accessibilityIdentifier = "vocab2LabelLeft"
        
        let vocab1LabelLeft = UILabel(frame: CGRect(x: 5, y: 550, width: 100, height: 30))
        vocab1LabelLeft.backgroundColor = VariablesManager.vocabBackgroundColors[0]
        vocab1LabelLeft.text = vocab[0]
        vocab1LabelLeft.textAlignment = .center
        vocab1LabelLeft.accessibilityIdentifier = "vocab1LabelLeft"
      
        let currentVocabLabel = UILabel(frame: CGRect(x: 20, y: 585, width: view.frame.size.width - 40, height: 50))
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

    }

    let appDelegate = AppDelegate()
    let chooseImagePickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseImagePickerView.frame = CGRect(x: (view.frame.size.width / 3) + 3, y: 480.0, width: 90.0, height: view.frame.size.width + 31 )

        chooseImagePickerView.delegate = self
        chooseImagePickerView.dataSource = self
        chooseImagePickerView.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        chooseImagePickerView.backgroundColor = .systemGray2

        let chosenImageView = UIImageView(frame: CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: 300))

        let urls = getCircleDataForThisUnit(dataForm: "urls")

        let rowString = urls[0]
        let url1 = URL(string: rowString)!
        let data1 = try? Data(contentsOf: url1)
        chosenImageView.image = UIImage(data: data1!)

        view.addSubview(chosenImageView)
        view.addSubview(chooseImagePickerView)
        view.backgroundColor = .systemGray2
        
        addVocabLabels()
        addSoundButtons()
        updateSpeechButtons(row: 0)
        view.addSubview(chooseImagePickerView)
    }
    
    func obtainCircleImages() -> [CircleImage] {
        let context = appDelegate.persistentContainer.viewContext
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
    
    func getUsersThemeUnitChoice() -> String {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserThemeUnitChoice")
        request.returnsObjectsAsFaults = false
        var userThemeUnitChoice: String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
//                    userChoice = result as! UserChoice
                    let theme = result.value(forKey: "theme") as? String
                    let unit = result.value(forKey: "unit") as? String

                    userThemeUnitChoice = "\(theme ?? "theme error") \(unit ?? "unit number error")"
//                    return userChoice
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return userThemeUnitChoice
    }

}
