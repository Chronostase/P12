//
//  CoordinatorManager.swift
//  Unsinkable
//
//  Created by Thomas on 26/01/2021.
//

import Foundation
import UIKit

class CoordinatorManager: Coordinator {
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let child = AuthenticationCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start()
    }
    
    func transitionToHomeScreen() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.homeCoordinator = self
        tabBarViewController.setViewControllers(self.setupVC(), animated: true)
        navigationController.pushViewController(tabBarViewController, animated: true)
//        tabBarViewController.modalPresentationStyle = .fullScreen
//        navigationController.present(tabBarViewController, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
    
    func profil() {
        let storyBoard = UIStoryboard(name: "Profil", bundle: Bundle.main)
            guard let profilViewController = storyBoard.instantiateInitialViewController() as? ProfilViewController else {
                return
            }
        profilViewController.coordinator = self
//        navigationController.present(profilViewController, animated: true)
        navigationController.pushViewController(profilViewController, animated: true)
        
    }
    
    private func setupVC() -> [UIViewController]? {
        let storyboard = UIStoryboard(name: "DashBoard", bundle: Bundle.main)
        guard let dashBoardViewController = storyboard.instantiateInitialViewController() as? DashBoardViewController else {
            return nil
        }
        dashBoardViewController.coordinator = self
        
        
        let secondStoryboard = UIStoryboard(name: "NotificationCenter", bundle: Bundle.main)
        guard let notificationViewController = secondStoryboard.instantiateInitialViewController() as? NotificationCenterViewController else {
            return nil
        }
        let dashBoardNavigationViewController = UINavigationController(rootViewController: dashBoardViewController)
        dashBoardViewController.tabBarItem.image = UIImage(named: "clipboard")
        let notificationNavigationController = UINavigationController(rootViewController: notificationViewController)
        notificationViewController.tabBarItem.image = UIImage(systemName: "bell")
        
        return [dashBoardNavigationViewController, notificationNavigationController]
    }
    
}
