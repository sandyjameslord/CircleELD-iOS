//
//  MainTabBarViewController.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = ThemeChoiceViewController()
        let vc2 = SearchViewController()
        let vc3 = RandomThemeGeneratorViewController()

        vc1.title = "Choose by Theme"
        vc2.title = "Search"
        vc3.title = "Random Theme"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Choose by Theme", image: UIImage(systemName: "tray.full.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Random Theme", image: UIImage(systemName: "bonjour"), tag: 1)
        
        nav1.modalPresentationStyle = .fullScreen
        nav2.modalPresentationStyle = .fullScreen
        nav3.modalPresentationStyle = .fullScreen
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3], animated: true)
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        appearance.selectionIndicatorTintColor = .white
        tabBar.standardAppearance = appearance
    }
}
