//
//  MainTabBarViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit
import CoreData
//MyTabsViewController : UITabBarController <UITabBarDelegate>
class MainTabBarViewController: UITabBarController {
    let appDelegate = AppDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        let vc1 = ChooseByThemeViewController()
        let vc2 = SearchViewController()
        let vc3 = Ex1NewViewController()

//        vc1.title = "Choose by Theme"
//        vc2.title = "Search"
//        vc3.title = "Random Theme"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Choose by Theme", image: UIImage(systemName: "tray.full.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Random Theme", image: UIImage(systemName: "bonjour"), tag: 3)
        
        nav1.modalPresentationStyle = .fullScreen
        nav2.modalPresentationStyle = .fullScreen
        nav3.modalPresentationStyle = .fullScreen
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        
        
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(submitRandomUnit))
//        nav3.
        
        setViewControllers([nav1, nav2, nav3], animated: true)
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        appearance.selectionIndicatorTintColor = .white
        tabBar.standardAppearance = appearance
    }
    @objc func submitRandomUnit() {
        let context = appDelegate.persistentContainer.viewContext
        let themes = ["body", "color", "fall", "geography", "house", "plant", "space", "transportation", "water", "world culture"]
        let unitNumber = Int.random(in: 1..<5)
        let randomThemeIndex = Int.random(in: 0..<10)
        
        let theme = themes[randomThemeIndex]
        let vocab = getVocabCorrespondingToThemeAndUnitChoice(choiceTheme: theme, choiceUnit: "\(unitNumber)")
        let randomChoice = NSEntityDescription.insertNewObject(forEntityName: "RandomChoice", into: context)
        let timeCreated = "\(NSDate().timeIntervalSince1970)"
        randomChoice.setValue(timeCreated, forKey: "timeCreated")
        randomChoice.setValue(theme, forKey: "theme")
        randomChoice.setValue(String(unitNumber), forKey: "unit")
        randomChoice.setValue("vocabulary", forKey: "chosenType")
        randomChoice.setValue(vocab, forKey: "chosenTypeValue")
        
        
        
        do {
            try context.save()
            print("Success: \(timeCreated), unit \(unitNumber), \(theme) saved as randomchoice, vocab: \(vocab)")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }

    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag==3){
            submitRandomUnit()
        }
    }
    
    func getVocabCorrespondingToThemeAndUnitChoice(choiceTheme: String, choiceUnit: String) -> String {
        let allCircleInfo = CoreDataManager().accessAllCircleImages()
        let thisTheme = allCircleInfo.filter({ return $0.theme == choiceTheme })
        let choiceUnitInt = Int(choiceUnit)
        let thisUnit = thisTheme.filter({ $0.unit == choiceUnitInt})
        let firstImage = thisUnit[0]
        let vocabToReturn = firstImage.vocabulary
        return vocabToReturn!
//        return (CoreDataManager().accessAllCircleImages().filter({ return $0.theme == choiceTheme }).filter({ return "\($0.unit ?? 1)" == choiceUnit }).first?.vocabulary)!
    }
    
    
}
