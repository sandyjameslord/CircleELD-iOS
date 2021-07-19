//
//  SearchResultsViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit

class SearchResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.text = "Search Results"
        label.backgroundColor = .systemTeal
        view.addSubview(label)
        view.backgroundColor = .systemIndigo
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
        button.addTarget(self, action: #selector(self.openActivitySelectorViewController), for: .touchUpInside)
        return button
    }
    
    @objc func openActivitySelectorViewController() {
//        let newViewController = LogInViewController()
        ActivitySelectorViewController().modalPresentationStyle = .fullScreen
        present(ActivitySelectorViewController(), animated:true, completion:nil)
    }

}
//func continueToSearchResultsButton() -> UIButton {
//    let button = UIButton()
//    button.frame = CGRect(x: 20.0, y: 200.0, width: 300.0, height: 100.0)
//    button.backgroundColor = .systemGray
//    button.tintColor = .black
//    button.setTitle("Continue to search results", for: .normal)
//    button.addTarget(self, action: #selector(self.openSearchResultsViewController), for: .touchUpInside)
//    return button
//}
//
//@objc func openSearchResultsViewController() {
////        let newViewController = LogInViewController()
//    SearchResultsViewController().modalPresentationStyle = .fullScreen
//    present(SearchResultsViewController(), animated:true, completion:nil)
//}
