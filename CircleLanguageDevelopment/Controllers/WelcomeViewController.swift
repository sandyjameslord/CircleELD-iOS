//
//  ViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit
import CoreData
class WelcomeViewController: UIViewController {
    let appDelegate = AppDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager().getDataFromCircleAPI{(APIResponse) in
//            print("apiresponse:", APIResponse)
            self.saveCircleImageDataToCoreData(APIResponse!)
        }
        
        
        view.backgroundColor = .systemBlue
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.text = "Welcome"
        label.backgroundColor = .systemTeal
        view.addSubview(label)
        
        let loginButton = createLoginButton()
        let signupButton = createSignUpButton()
        let continueAsGuestButton = createContinueAsGuestButton()
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(continueAsGuestButton)
        
        
        
        // Do any additional setup after loading the view.
    }
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
            print("Success")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    func createContinueAsGuestButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 20.0, y: 200.0, width: 200.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Continue as Guest", for: .normal)
        button.addTarget(self, action: #selector(self.openMainViewController), for: .touchUpInside)
        return button
    }
    
    @objc func openMainViewController() {
//        print("inside function")
//        let newViewController = LogInViewController()
//        MainTabBarViewController().modalPresentationStyle = .fullScreen
//        UIStoryboardSegue
        present(MainTabBarViewController(), animated:true, completion:nil)
    }

    
    
    func createLoginButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 20.0, y: 350.0, width: 200.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(self.presentLogInViewController), for: .touchUpInside)
        return button
    }
    
    @objc func presentLogInViewController() {
//        let newViewController = LogInViewController()
        present(LogInViewController(), animated:true, completion:nil)
    }
    
    func createSignUpButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 20.0, y: 500.0, width: 200.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(self.presentSignUpViewController), for: .touchUpInside)
        return button
    }
    
    @objc func presentSignUpViewController() {
//        print("inside function")
//        let newViewController = SignUpViewController()
        present(SignUpViewController(), animated:true, completion:nil)
//        self.navigationController!.pushViewController(SignUpViewController(), animated: true)
    }


}

