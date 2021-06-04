////
////  DashBoardCoordinator.swift
////  Unsinkable
////
////  Created by Thomas on 25/05/2021.
////
//
//import Foundation
//import UIKit
//
//class DashBoardCoordinator: Coordinator {
//    var childCoordinator = [Coordinator]()
//    weak var parentCoordinator: HomeCoordinator?
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let storyBoard = UIStoryboard(name: "DashBoard", bundle: Bundle.main)
//        guard let dashBoardViewController = storyBoard.instantiateInitialViewController() as? DashBoardViewController else {
//            return
//        }
//        dashBoardViewController.coordinator = self
////        dashBoardViewController.mainCoordinator = self
//    }
//
//    func profil() {
//        let storyBoard = UIStoryboard(name: "Profil", bundle: Bundle.main)
//            guard let profilViewController = storyBoard.instantiateInitialViewController() as? ProfilViewController else {
//                return
//            }
////        guard let window = UIApplication.shared.currentKeyWindow else {
////            return
////        }
////        //Understand why it don't work
//
////
//        profilViewController.coordinator = self
//        parentCoordinator?.navigationController.push(profilViewController)
////        navigationController.pushViewController(profilViewController, animated: true)
////        navigationController.push(profilViewController, animated: true)
//    }
//    
////    func addProject() {
////        let storyBoard = UIStoryboard(name: "ProjectCreation", bundle: Bundle.main)
////        guard let projectCreationViewController = storyBoard.instantiateInitialViewController() as? ProjectCreationViewController else {
////            return
////        }
////        projectCreationViewController.coordinator = self
////        navigationController.push(projectCreationViewController, animated: true)
////    }
//
//
//}
