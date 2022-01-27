//
//  RegisterViewController+RegisterPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/04/2021.
//

import Foundation

extension RegisterViewController: RegisterPresenterDelegate {
    
    func registerUserSucceed() {
        self.navigationController?.dismiss(animated: true)
        self.transitionToHomeScreen()
    }
    
    func registerFailed(_ message: String) {
        self.navigationController?.dismiss(animated: true)
        self.showError(message)
    }
    
    func invalidEmail() {
        self.navigationController?.dismiss(animated: true)
        self.showError(Constants.Error.Body.emailError)
    }
    
    func empltyFields() {
        self.navigationController?.dismiss(animated: true)
        self.showError(Constants.Error.Body.fillField)
    }
    
    func invalidPassword() {
        self.navigationController?.dismiss(animated: true)
        self.showError(Constants.Error.Body.passwordError)
    }
}
