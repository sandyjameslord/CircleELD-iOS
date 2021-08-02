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
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        spinner.center = self.view.center
        view.addSubview(spinner)
        spinner.backgroundColor = .red
        spinner.color = .black
        spinner.layer.zPosition = 100
        spinner.tintColor = .blue

        let beginningImages = CoreDataManager().accessAllCircleImages()
        if beginningImages.count == 0 {
            JSONDataManager().getDataFromCircleAPI{(APIResponse) in
                CoreDataManager().saveCircleImageDataToCoreData(APIResponse!)
            }
        }

        addTitleLabel()
        addMainTextLabel()
//        let loginButton = createLoginButton()
//        let signupButton = createSignUpButton()
        let continueAsGuestButton = createContinueAsGuestButton()
//        view.addSubview(loginButton)
//        view.addSubview(signupButton)
        view.addSubview(continueAsGuestButton)
        createUserSession()
    }
    
    func createUserSession() {
        let time = "\(NSDate().timeIntervalSince1970)"
        let userID = "initialNoValueID"
        let context = appDelegate.persistentContainer.viewContext
        let userSession = NSEntityDescription.insertNewObject(forEntityName: "UserSession", into: context)
        userSession.setValue(userID, forKey: "userID")
        userSession.setValue(time, forKey: "timeCreated")
        
        do {
            try context.save()
            print("Success: \(userID) session \(time) saved as userSession")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    func addMainTextLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: 500))
        label.text = "A friendly resource for all English learners.\n\n Click on the images and buttons to hear English words, sentences and questions in context. \n\nExplore and have fun!\n\n First, continue as a Guest."
        label.backgroundColor = .systemBlue
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 35.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
    }
    
    func addTitleLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 200))
        label.text = "CIRCLE-ELD"
        label.backgroundColor = .systemBlue
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 76.0)
        label.textAlignment = .center
        view.addSubview(label)
    }

    func createContinueAsGuestButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: view.center.x - 170, y: view.bounds.maxY - 200, width: 340.0, height: 100.0)
        button.backgroundColor = .systemIndigo
        button.tintColor = .black
        button.setTitle("Continue as a Guest", for: .normal)
        button.addTarget(self, action: #selector(self.openMainViewController), for: .touchUpInside)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
//        button.font = UIFont(name: , size: 76.0)!
        button.layer.cornerRadius = 10
        
        return button
    }
    
    @objc func openMainViewController() {
        MainTabBarViewController().modalPresentationStyle = UIModalPresentationStyle(rawValue: 0)!
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
        present(MainTabBarViewController(), animated:true, completion:nil)
    }

    func createLoginButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 30.0, y: 640.0, width: 150.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(self.presentLogInViewController), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }
    
    @objc func presentLogInViewController() {
        present(LogInViewController(), animated:true, completion:nil)
    }
    
    func createSignUpButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: view.frame.width - 180, y: 640.0, width: 150.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(self.presentSignUpViewController), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }
    
    @objc func presentSignUpViewController() {
        present(SignUpViewController(), animated:true, completion:nil)
    }


}

