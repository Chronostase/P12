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
    //Push mainLoginVC
    func start() {
        let storyBoard = UIStoryboard(name: Constants.StoryBoard.mainLoginPage, bundle: Bundle.main)
        guard let mainLoginVC = storyBoard.instantiateInitialViewController() as? MainLoginViewController else {
            return
        }
        mainLoginVC.coordinator = self
        navigationController.pushViewController(mainLoginVC, animated: true)
    }
    
    //Push singIn ViewController
    func signIn() {
        let storyBoard = UIStoryboard(name: Constants.StoryBoard.signIn, bundle: Bundle.main)
        guard let signInVC = storyBoard.instantiateInitialViewController() as? LogInViewController else {
            return
        }
        signInVC.coordinator = self
        navigationController.pushViewController(signInVC, animated: true)
    }
    
    //push registerViewController 
    func register() {
        let storyBoard = UIStoryboard(name: Constants.StoryBoard.register , bundle: Bundle.main)
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
