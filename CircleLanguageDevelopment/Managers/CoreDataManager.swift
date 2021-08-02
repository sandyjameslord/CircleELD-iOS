//
//  CoreDataManager.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/20/21.
//

import Foundation
import CoreData
import UIKit

struct CoreDataManager {
    let appDelegate = AppDelegate()
    func saveCircleImageDataToCoreData(_ circleImagesAPIValues: [APIResponse]) {
        let context = self.appDelegate.persistentContainer.viewContext
        for circleImageAPIValue in circleImagesAPIValues {
            let newCircleImage = NSEntityDescription.insertNewObject(forEntityName: "CircleImages", into: context)
         
            newCircleImage.setValue(circleImageAPIValue.id?.oid, forKey: "id")
            newCircleImage.setValue(circleImageAPIValue.vocabulary, forKey: "vocabulary")
            newCircleImage.setValue(Int(circleImageAPIValue.unit!.numberInt), forKey: "unit")
            newCircleImage.setValue(circleImageAPIValue.abSentence, forKey: "abSentence")
            newCircleImage.setValue(circleImageAPIValue.abQuestion, forKey: "abQuestion")
            newCircleImage.setValue(circleImageAPIValue.abQuestionDomain, forKey: "abQuestionDomain")
            newCircleImage.setValue(circleImageAPIValue.bcSentence, forKey: "bcSentence")
            newCircleImage.setValue(circleImageAPIValue.bcQuestion, forKey: "bcQuestion")
            newCircleImage.setValue(circleImageAPIValue.bcQuestionDomain, forKey: "bcQuestionDomain")
            newCircleImage.setValue(circleImageAPIValue.imageName, forKey: "imageName")
            newCircleImage.setValue(circleImageAPIValue.photo, forKey: "photo")
            newCircleImage.setValue(circleImageAPIValue.progName, forKey: "progName")
            newCircleImage.setValue(circleImageAPIValue.syllStructure, forKey: "syllStructure")
            newCircleImage.setValue(circleImageAPIValue.theme, forKey: "theme")
        }
        do {
            try context.save()
            print("Success saving Circle Image data to Core Data")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    func getCircleMatches(userSearch : String) -> [[CircleImage]] {
        var circleImages = CoreDataManager().accessAllCircleImages()
        while circleImages.count > 400 { circleImages.removeLast()}
        
        print(circleImages.count)
        
        var themes : [CircleImage] = []
        var vocab : [CircleImage] = []
        var abSentences : [CircleImage] = []
        var bcSentences : [CircleImage] = []
        var abQuestions : [CircleImage] = []
        var bcQuestions : [CircleImage] = []
        for image in circleImages {
            if image.theme!.lowercased().contains(userSearch.lowercased())        {themes.append(image)}
            if image.vocabulary!.lowercased().contains(userSearch.lowercased())   {vocab.append(image)}
            if image.abSentence!.lowercased().contains(userSearch.lowercased())   {abSentences.append(image)}
            if image.bcSentence!.lowercased().contains(userSearch.lowercased())   {bcSentences.append(image)}
            if image.abQuestion!.lowercased().contains(userSearch.lowercased())   {abQuestions.append(image)}
            if image.bcQuestion!.lowercased().contains(userSearch.lowercased())   {bcQuestions.append(image)}
        }
        

        return [themes, vocab, abSentences, bcSentences, abQuestions, bcQuestions]
    }
    
    func accessAllCircleImages() -> [CircleImage] {
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
    
    func accessUserSessionCoreData() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserSession")
        request.returnsObjectsAsFaults = false
        var userID: String = ""
        var timeCreated: String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    userID = (result.value(forKey: "userID") as? String)!
                    timeCreated = (result.value(forKey: "timeCreated") as? String)!
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return [userID, timeCreated]
    }
    
    func resetCoreData(entityName: String) {
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
            print("properly deleted \(entityName) entity data from CoreData")
        } catch let error as NSError {
            print("Deleted all my data in \(entityName) error : \(error) \(error.userInfo)")
        }
    }
    
    func accessUsersThemeUnitChoice() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserThemeUnitChoice")
        request.returnsObjectsAsFaults = false
        var userThemeUnitChoice: [String] = []
        var theme : String = ""
        var unit : String = ""
        var time : String = ""
        var chosenTypeValue : String = ""
        var chosenType : String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    theme = (result.value(forKey: "theme") as? String)!
                    unit = (result.value(forKey: "unit") as? String)!
                    time = (result.value(forKey: "timeCreated") as? String)!
                    chosenTypeValue = result.value(forKey: "chosenTypeValue") as? String ?? "blue"
                    chosenType = result.value(forKey: "chosenType") as? String ?? "vocabulary"
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        userThemeUnitChoice = [theme, unit, time, chosenType, chosenTypeValue]
        return userThemeUnitChoice
    }
    
    func accessSearch1CoreData() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Search1")
        request.returnsObjectsAsFaults = false
        var theme: String = ""
        var timeCreated: String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    theme = (result.value(forKey: "theme") as? String)!
                    timeCreated = (result.value(forKey: "timeCreated") as? String)!
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return [theme, timeCreated]
    }

    func accessSearch2CoreData() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Search2")
        request.returnsObjectsAsFaults = false
        var theme : String = ""
        var unit : String = ""
        var vocab : String = ""
        var time : String = ""
        var chosenTypeValue : String = ""
        var chosenType : String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    theme = result.value(forKey: "theme") as? String ?? "color"
                    unit = result.value(forKey: "unit") as? String ?? "1"
                    vocab = result.value(forKey: "vocabulary") as? String ?? "blue"
                    time = result.value(forKey: "timeCreated") as? String ?? "3.0"
                    chosenTypeValue = result.value(forKey: "chosenTypeValue") as? String ?? "blue"
                    chosenType = result.value(forKey: "chosenType") as? String ?? "vocabulary"
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return [theme, unit, vocab, time, chosenType, chosenTypeValue]
    }
    
    func accessSearch3CoreData() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Search3")
        request.returnsObjectsAsFaults = false
        var theme : String = ""
        var unit : String = ""
        var vocab : String = ""
        var time : String = ""
        var s1 : String = ""
        var s2 : String = ""
        var q1 : String = ""
        var q2 : String = ""
        var chosenTypeValue : String = ""
        var chosenType : String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    theme = result.value(forKey: "theme") as? String ?? "color"
                    unit = result.value(forKey: "unit") as? String ?? "1"
                    vocab = result.value(forKey: "vocabulary") as? String ?? "blue"
                    time = result.value(forKey: "timeCreated") as? String ?? "3.0"

                    s1 = result.value(forKey: "s1") as? String ?? "blue"
                    s2 = result.value(forKey: "s2") as? String ?? "blue"
                    q1 = result.value(forKey: "q1") as? String ?? "blue"
                    q2 = result.value(forKey: "q2") as? String ?? "blue"
                    
                    chosenTypeValue = result.value(forKey: "chosenTypeValue") as? String ?? "blue"
                    chosenType = result.value(forKey: "chosenType") as? String ?? "vocabulary"

                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return [theme, unit, vocab, time, s1, s2, q1, q2, chosenType, chosenTypeValue]
    }
    
    
    func accessRandomChoiceCoreData() -> [String] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RandomChoice")
        request.returnsObjectsAsFaults = false
        
        var time : String = ""
        var theme : String = ""
        var unit : String = ""
        var chosenTypeValue : String = ""
        var chosenType : String = ""
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    theme = result.value(forKey: "theme") as? String ?? "color"
                    time = result.value(forKey: "timeCreated") as? String ?? "3.0"
                    unit = result.value(forKey: "unit") as? String ?? "3"
                    chosenTypeValue = result.value(forKey: "chosenTypeValue") as? String ?? "blue"
                    chosenType = result.value(forKey: "chosenType") as? String ?? "vocabulary"
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return [time, theme, unit, chosenTypeValue, chosenType]
    }
}
