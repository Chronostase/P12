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
        
//        let tabBarViewController = TabBarViewController()
//        tabBarViewController.homeCoordinator = self
        //Can cause trouble if user leave just after sign In, move it in logScreen
        getUserData()
//        tabBarViewController.setViewControllers(self.setupVC(), animated: true)
//        navigationController.pushViewController(tabBarViewController, animated: true)
    }
    
    func tabBar() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.homeCoordinator = self
        tabBarViewController.setViewControllers(self.setupVC(), animated: true)
        navigationController.pushViewController(tabBarViewController, animated: true)
    }
    
    private func setupVC() -> [UIViewController]? {
        let storyboard = UIStoryboard(name: "DashBoard", bundle: Bundle.main)
        guard let dashBoardViewController = storyboard.instantiateInitialViewController() as? DashBoardViewController else {
            return nil
        }
        dashBoardViewController.coordinator = self
        dashBoardViewController.dashBoardPresenter.data = self.data
        print(dashBoardViewController.dashBoardPresenter.data == nil)
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
    
    func projectCreation() {
        let storyboard = UIStoryboard(name: "Project", bundle: Bundle.main)
        guard let projectVC = storyboard.instantiateInitialViewController() as? ProjectViewController else {
            return
        }
        projectVC.coordinator = self
        navigationController.pushViewController(projectVC, animated: true)
//        let storyBoard = UIStoryboard(name: "ProjectCreation", bundle: Bundle.main)
//        guard let projectCreationViewController = storyBoard.instantiateInitialViewController() as? ProjectCreationViewController else {
//            return
//        }
//        projectCreationViewController.coordinator = self
//        navigationController.pushViewController(projectCreationViewController, animated: true)
    }
    
    func taskCreation() {
        let storyboard = UIStoryboard(name: "TaskCreation", bundle: Bundle.main)
        guard let taskCreationViewController = storyboard.instantiateInitialViewController() as? TaskCreationViewController else {
            return
        }
        taskCreationViewController.coordinator = self
        navigationController.pushViewController(taskCreationViewController, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    private func getUserData() {
        let loadingVC = LoaderViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        
        navigationController.present(loadingVC, animated: true, completion: nil)
               
        userAuthenticationService.getUserData { [weak self] result in
            switch result {
            case .success(let customResponse):
                guard let userData = customResponse else {
                    return
                }
                self?.data = userData
                self?.tabBar()
                self?.navigationController.dismiss(animated: true, completion: nil)
            case.failure(let error):
                print("Can't fetch data \(error) ")
            }
        }
    }
}

