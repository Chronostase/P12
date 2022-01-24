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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
//        showLoader()
    }
    
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }
    
//    private func showLoader() {
//        let loadingVC = LoaderViewController()
//        loadingVC.modalPresentationStyle = .overCurrentContext
//        loadingVC.modalTransitionStyle = .crossDissolve
//        navigationController?.present(loadingVC, animated: true, completion: nil)
//    }
}
