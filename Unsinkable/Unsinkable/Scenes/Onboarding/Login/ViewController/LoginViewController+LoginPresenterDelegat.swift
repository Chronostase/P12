//
//  LoginViewController+LoginPresenterDelegat.swift
//  Unsinkable
//
//  Created by Thomas on 15/04/2021.
//
import Foundation

extension LogInViewController: LoginPresenterDelegate {
    
    //Dismiss loader, remove viewController from navigation stack to avoid a potential problem, and push to home screen
    func loginSucceed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.navigationController?.viewControllers.removeAll()
        self.transitionToHomeScreen()
    }
    
    //Dismiss loader and show error
    func loginFailed(_ message: String?) {
        if let message = message {
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.showError(message)
        }
    }
    
    //Show error if their is empty fields
    func emptyFields() {
        self.showError(Constants.Error.Body.fillField)
    }
    
    
}
