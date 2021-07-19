//
//  SearchViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit
import Foundation
import CoreData
//import Cocoa

class SearchViewController: UIViewController {
    let appDelegate = AppDelegate()
    let userSearchInput                     = UITextField   (frame: CGRect(x: 10, y: 100, width: 200, height: 50))
    let searchAndFoundByThemeLabel          = UILabel       (frame: CGRect(x: 10, y: 160, width: 350, height: 80))
    let searchAndFoundByVocabLabel          = UILabel       (frame: CGRect(x: 10, y: 250, width: 350, height: 100))
    let searchAndFoundByGeneralSearchLabel  = UILabel       (frame: CGRect(x: 10, y: 360, width: 350, height: 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink

        userSearchInput.backgroundColor = .systemGray3
        userSearchInput.placeholder = "Search..."
        userSearchInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchAndFoundByThemeLabel.numberOfLines = 0
        searchAndFoundByThemeLabel.backgroundColor = .systemGray
        
        searchAndFoundByVocabLabel.numberOfLines = 0
        searchAndFoundByVocabLabel.backgroundColor = .systemGray
        
        searchAndFoundByGeneralSearchLabel.numberOfLines = 0
        searchAndFoundByGeneralSearchLabel.backgroundColor = .systemGray

        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveSearch1ToCoreDataAndThenOpen))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        
        searchAndFoundByThemeLabel.addGestureRecognizer(tap)
        searchAndFoundByThemeLabel.isUserInteractionEnabled = true// after adding this it worked
        
        view.addSubview(userSearchInput)
        view.addSubview(searchAndFoundByThemeLabel)
        view.addSubview(searchAndFoundByVocabLabel)
        view.addSubview(searchAndFoundByGeneralSearchLabel)
    }

    @objc func saveSearch1ToCoreDataAndThenOpen() {
        let context = appDelegate.persistentContainer.viewContext
        let search1 = NSEntityDescription.insertNewObject(forEntityName: "Search1", into: context)
        let theme = String(searchAndFoundByThemeLabel.text!.dropFirst(33))
        if theme != "" {
            search1.setValue(theme, forKey: "theme")

            do {
                try context.save()
                print("Success: \(theme) saved as saveSearch1ToCoreDataAndThenOpen")
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }

            present(ActivitySelectorViewController(), animated:true, completion:nil)
        }
        
    }
    @objc func saveSearch2ToCoreDataAndThenOpen() {
        let context = appDelegate.persistentContainer.viewContext
        let search1 = NSEntityDescription.insertNewObject(forEntityName: "Search1", into: context)
        let theme = String(searchAndFoundByThemeLabel.text!.dropFirst(33))
        if theme != "" {
            search1.setValue(theme, forKey: "theme")

            do {
                try context.save()
                print("Success: \(theme) saved as saveSearch1ToCoreDataAndThenOpen")
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }

            present(ActivitySelectorViewController(), animated:true, completion:nil)
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        var circleImages = obtainCircleImages()
        while circleImages.count > 400 { circleImages.removeLast()}
        
        let cleanedUserText = textField.text?.lowercased()
        
        
        let themes = circleImages.filter({ return $0.theme == cleanedUserText })
        if themes.count != 0 {
            let themeName = themes[0].theme
            searchAndFoundByThemeLabel.text = """
Found match by CircleELD Theme:

\(themeName?.capitalized ?? "error")
"""
        } else {
            searchAndFoundByThemeLabel.text = """
Found match by CircleELD Theme:

No Theme matches for \(textField.text!)
"""
        }
        
        let vocabulary = circleImages.filter({ return $0.vocabulary == cleanedUserText })
        if vocabulary.count != 0 {
            var vocabDisplay = """
"""
            for vocab in vocabulary {
                vocabDisplay += "Vocab: " + vocab.vocabulary! + "; Theme: " + vocab.theme! + "\n"
            }

            searchAndFoundByVocabLabel.text = """
Found matches by CircleELD Vocabulary:

\(vocabDisplay)
"""
        } else {
            searchAndFoundByVocabLabel.text = """
Found matches by CircleELD Vocabulary:

No Vocabulary matches for \(textField.text!)
"""
        }

        let abSentences = circleImages.filter({ return $0.abSentence!.lowercased().contains(cleanedUserText!) })
        let bcSentences = circleImages.filter({ return $0.bcSentence!.lowercased().contains(cleanedUserText!) })
        let abQuestions = circleImages.filter({ return $0.abQuestion!.lowercased().contains(cleanedUserText!) })
        let bcQuestions = circleImages.filter({ return $0.bcQuestion!.lowercased().contains(cleanedUserText!) })
        let generalSearch = [abSentences, bcSentences, abQuestions, bcQuestions]
        if generalSearch[0].count > 0 || generalSearch[1].count > 0 || generalSearch[2].count > 0 || generalSearch[3].count > 0 {
            var generalSearchDisplay = """
"""
            
            
            
            var abSentencesDisplay = """
"""
            for sentence in abSentences {
                abSentencesDisplay += "Vocab: " + sentence.vocabulary! + "; Sentence 1: " + sentence.abSentence! + "\n"
            }
            
            
            var bcSentencesDisplay = """
"""
            for sentence in bcSentences {
                bcSentencesDisplay += "Vocab: " + sentence.vocabulary! + "; Sentence 2: " + sentence.bcSentence! + "\n"
            }
            
            
            var abQuestionsDisplay = """
"""
            for question in abQuestions {
                abQuestionsDisplay += "Vocab: " + question.vocabulary! + "; Question 1: " + question.abQuestion! + "\n"
            }
            
            
            var bcQuestionsDisplay = """
"""
            for question in bcQuestions {
                bcQuestionsDisplay += "Vocab: " + question.vocabulary! + "; Question 2: " + question.bcQuestion! + "\n"
            }
            
            generalSearchDisplay += abSentencesDisplay + bcSentencesDisplay + abQuestionsDisplay + bcQuestionsDisplay
            searchAndFoundByGeneralSearchLabel.text = """
Found matches by CircleELD General Search:

\(generalSearchDisplay)
"""
        } else {
            searchAndFoundByGeneralSearchLabel.text = """
Found matches by CircleELD General Search:

No General Search matches for \(textField.text!)
"""
        }
//        let abSen = circleImages.filter({ return $0.abSentence!.contains((textField.text?.lowercased())!) })
        
        
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

}
