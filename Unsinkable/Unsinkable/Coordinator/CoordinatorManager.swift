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
    
    func register() {
        let storyBoard = UIStoryboard(name: "Register", bundle: Bundle.main)
        guard let registerVC = storyBoard.instantiateInitialViewController() as? RegisterViewController else {
            return
        }
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func signIn() {
        let storyBoard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
        guard let signInVC = storyBoard.instantiateInitialViewController() as? LogInViewController else {
            return
        }
        signInVC.coordinator = self
        navigationController.pushViewController(signInVC, animated: true)
    }
    
    func start() {
        
        //Add LogIn view
        let storyBoard = UIStoryboard(name: "MainLoginPage", bundle: Bundle.main)
        guard let mainLoginVC = storyBoard.instantiateInitialViewController() as? MainLoginViewController else {
            return
        }
        mainLoginVC.coordinator = self
        navigationController.pushViewController(mainLoginVC, animated: true)
    }
    
    func transitionToHomeScreen(_ view: UIView) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainStoryBoard = storyBoard.instantiateViewController(withIdentifier: "main") as? UITabBarController else {
            return
        }
        view.window?.rootViewController = mainStoryBoard
        view.window?.makeKeyAndVisible()
        
    }
    
    
}
