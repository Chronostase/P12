//
//  AuthenticationCoordinator.swift
//  Unsinkable
//
//  Created by Thomas on 25/05/2021.
//

import Foundation
import UIKit

class AuthenticationCoordinator: Coordinator {
    
    var user: CustomResponse?
    var childCoordinator = [Coordinator]()
    weak var parentCoordinator: CoordinatorManager?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyBoard = UIStoryboard(name: "MainLoginPage", bundle: Bundle.main)
        guard let mainLoginVC = storyBoard.instantiateInitialViewController() as? MainLoginViewController else {
            return
        }
        mainLoginVC.coordinator = self
        navigationController.pushViewController(mainLoginVC, animated: true)
    }

    func signIn() {
        let storyBoard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
        guard let signInVC = storyBoard.instantiateInitialViewController() as? LogInViewController else {
            return
        }
        signInVC.coordinator = self
        navigationController.pushViewController(signInVC, animated: true)
    }

    func register() {
        let storyBoard = UIStoryboard(name: "Register", bundle: Bundle.main)
        guard let registerVC = storyBoard.instantiateInitialViewController() as? RegisterViewController else {
            return
        }
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    func transitionToHomeScreenNeeded() {
        parentCoordinator?.transitionToHomeScreen()
    }

    func didFinishLogin() {
        parentCoordinator?.childDidFinish(self)
    }


}
