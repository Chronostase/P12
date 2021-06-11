//
//  HomeCoordinator.swift
//  Unsinkable
//
//  Created by Thomas on 19/05/2021.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    weak var parentCoordinator: CoordinatorManager?
    var childCoordinator = [Coordinator]()
    var data = CustomResponse(user: UserDetails())
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.homeCoordinator = self
        tabBarViewController.setViewControllers(self.setupVC(), animated: true)
        navigationController.pushViewController(tabBarViewController, animated: true)
        getUserData()
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
    
    func profil() {
        let storyBoard = UIStoryboard(name: "Profil", bundle: Bundle.main)
            guard let profilViewController = storyBoard.instantiateInitialViewController() as? ProfilViewController else {
                return
            }
        profilViewController.data = data
        profilViewController.coordinator = self
        navigationController.pushViewController(profilViewController, animated: true)
        
    }
    
    func didFinishLogin() {
        parentCoordinator?.childDidFinish(self)
    }
    
    private func getUserData() {
        userAuthenticationService.getUserData { [weak self] result in
            switch result {
            case .success(let customResponse):
                guard let userData = customResponse else {
                    return
                }
                self?.data = userData
                
            case.failure(let error):
                print("Can't fetch data \(error) ")
            }
        }
    }
}

