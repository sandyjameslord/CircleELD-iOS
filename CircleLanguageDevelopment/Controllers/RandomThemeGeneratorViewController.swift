//
//  ViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/10/21.
//

import UIKit

class RandomThemeGeneratorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = .systemOrange
        // Do any additional setup after loading the view.
        let button = continueToActvitySelectorButton()
        
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }
    func continueToActvitySelectorButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 20.0, y: 200.0, width: 300.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Continue to activity selector", for: .normal)
        button.addTarget(self, action: #selector(self.openChooseByThemeViewController), for: .touchUpInside)
        return button
    }
    
    @objc func openChooseByThemeViewController() {
//        let newViewController = LogInViewController()
        ChooseByThemeViewController().modalPresentationStyle = .fullScreen
        present(ChooseByThemeViewController(), animated:true, completion:nil)
    }


}
