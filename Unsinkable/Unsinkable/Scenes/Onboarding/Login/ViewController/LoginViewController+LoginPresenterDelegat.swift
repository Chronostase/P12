//
//  LoginViewController+LoginPresenterDelegat.swift
//  Unsinkable
//
//  Created by Thomas on 15/04/2021.
//
import Foundation

extension LogInViewController: LoginPresenterDelegate {
    func loginSucceed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        #warning("not sure")
        self.navigationController?.viewControllers.removeAll()
        self.transitionToHomeScreen()
    }
    
    func loginFailed(_ message: String?) {
        if let message = message {
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.showError(message)
        }
    }
    
    func emptyFields() {
        self.showError(Constants.Error.Body.fillField)
    }
    
    
}
