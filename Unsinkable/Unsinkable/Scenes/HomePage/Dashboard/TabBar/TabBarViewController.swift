//
//  TabBarViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/05/2021.
//
//
//import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    weak var homeCoordinator: HomeCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let navStack = navigationController?.viewControllers
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
    }
}
