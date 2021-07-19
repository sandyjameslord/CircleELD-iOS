//
//  ThemeChoiceViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit

class ThemeChoiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = .systemGreen
        let button = continueToUnitSelectorButton()
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }
    func continueToUnitSelectorButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 20.0, y: 200.0, width: 300.0, height: 100.0)
        button.backgroundColor = .systemGray
        button.tintColor = .black
        button.setTitle("Continue to unit selector", for: .normal)
        button.addTarget(self, action: #selector(self.openUnitSelectorViewController), for: .touchUpInside)
        return button
    }
    
    @objc func openUnitSelectorViewController() {
//        let newViewController = LogInViewController()
        UnitChoiceViewController().modalPresentationStyle = .fullScreen
        present(UnitChoiceViewController(), animated:true, completion:nil)
    }

}
