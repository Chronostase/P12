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
    
    let userAuthenticationService: AuthenticationLogic = UserAuthenticationService()
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    //If user is already logIn transition to home screen else mainLogin
    func start() {
        if userAuthenticationService.isUserLogin() {
            self.transitionToHomeScreen()
        } else {
            let child = AuthenticationCoordinator(navigationController: navigationController)
            child.parentCoordinator = self
            childCoordinator.append(child)
            child.start()
        }
    }
    
    //Add childCoordinator to push to homeScreen
    func transitionToHomeScreen() {
        //Asyn need to wait response to login call
        let child = HomeCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinator.append(child)
        child.start()
    }
    
    //Remove child
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
    
}
