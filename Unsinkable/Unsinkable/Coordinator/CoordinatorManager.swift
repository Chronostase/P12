//
//  CoordinatorManager.swift
//  Unsinkable
//
//  Created by Thomas on 26/01/2021.
//

import Foundation
import UIKit
import Firebase

class CoordinatorManager: Coordinator {
    
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if userAuthenticationService.isUserLogin() {
            self.transitionToHomeScreen()
        } else {
            let child = AuthenticationCoordinator(navigationController: navigationController)
            child.parentCoordinator = self
            childCoordinator.append(child)
            child.start()
        }
        //See to fetch user data 
    }
    
    func transitionToHomeScreen() {
        //Asyn need to wait response to login call
        let child = HomeCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
    
}
