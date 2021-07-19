//
//  SignUpViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.text = "SignUp"
        label.backgroundColor = .systemTeal
        view.addSubview(label)
        let button = continueToMainButton()
        
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }
    func continueToMainButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 20.0, y: 200.0, width: 200.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Continue without signup for now", for: .normal)
        button.addTarget(self, action: #selector(self.openMainViewController), for: .touchUpInside)
        return button
    }
    
    @objc func openMainViewController() {
//        let newViewController = LogInViewController()
//        self.navigationController?.pushViewController(MainTabBarViewController(), animated: true)
        MainTabBarViewController().modalPresentationStyle = .overFullScreen
        show(MainTabBarViewController(), sender: self)
//        present(MainTabBarViewController(), animated:true, completion:nil)
    }
}
