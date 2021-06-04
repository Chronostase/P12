////
////  HomeCoordinator.swift
////  Unsinkable
////
////  Created by Thomas on 19/05/2021.
////
//
//import Foundation
//import UIKit
//
//class HomeCoordinator: Coordinator {
//    weak var parentCoordinator: CoordinatorManager?
//    var childCoordinator = [Coordinator]()
//    
//    var navigationController: UINavigationController
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        let storyBoard = UIStoryboard(name: "DashBoard", bundle: Bundle.main)
//        guard let dashVC = storyBoard.instantiateInitialViewController() as? DashBoardViewController else {
//            return
//        }
//        
//        dashVC.coordinator = self
//        navigationController.pushViewController(dashVC, animated: true)
//    }
//    
////    func profil() {
////        let storyBoard = UIStoryboard(name: "Profil", bundle: Bundle.main)
////            guard let profilViewController = storyBoard.instantiateInitialViewController() as? ProfilViewController else {
////                return
////            }
////        profilViewController.coordinator = self
////        navigationController.pushViewController(profilViewController, animated: true)
////
////    }
//    
////    func start() {
////        let tabBarViewController = TabBarViewController()
////        guard let window = UIApplication.shared.currentKeyWindow else {
////            return
////        }
////        tabBarViewController.viewControllers = setupVC()
////        tabBarViewController.homeCoordinator = self
////        print("///////////////////////////////////////////")
////        print("Is coordinator nil", tabBarViewController.homeCoordinator == nil)
////        print("Show TabBarVC")
////        print("///////////////////////////////////////////")
////        window.rootViewController = UINavigationController(rootViewController: tabBarViewController)
////        window.makeKeyAndVisible()
////    }
//    
////    func profil() {
////        let storyBoard = UIStoryboard(name: "Profil", bundle: Bundle.main)
////            guard let profilViewController = storyBoard.instantiateInitialViewController() as? ProfilViewController else {
////                return
////            }
////        profilViewController.coordinator = self
//////        navigationController.pushViewController(profilViewController, animated: true)
////
////    }
//    
//    
//    
////    func launchDashBoard() {
////        let child = DashBoardCoordinator(navigationController: navigationController)
////        child.parentCoordinator = self
////        childCoordinator.append(child)
////        child.start()
////    }
//}
//
