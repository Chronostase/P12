//
//  HomeCoordinator.swift
//  Unsinkable
//
//  Created by Thomas on 19/05/2021.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    
    
    weak var parentCoordinator: CoordinatorManager?
    var childCoordinator = [Coordinator]()
    var data = CustomResponse(user: UserDetails())
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        tabBar()
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
    
    func projectCreation(isPersonal: Bool) {
        let storyboard = UIStoryboard(name: "ProjectCreation", bundle: Bundle.main)
        guard let projectVC = storyboard.instantiateInitialViewController() as? ProjectCreationViewController else {
            return
        }
        
        projectVC.projectCreationPresenter.data = self.data
        projectVC.coordinator = self
        projectVC.projectCreationPresenter.isPersonal = isPersonal
        navigationController.pushViewController(projectVC, animated: true)
    }
    
    func projectReader(project: Project) {
        let storyboard = UIStoryboard(name: "ProjectReading", bundle: Bundle.main)
        guard let projectReaderVC = storyboard.instantiateInitialViewController() as? ProjectReaderViewController else {
            return
        }
        projectReaderVC.dashBoardPresenter.selectedProject = project
        projectReaderVC.coordinator = self
        navigationController.pushViewController(projectReaderVC, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
}

