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
    
    func registerFailed() {
        self.navigationController?.dismiss(animated: true)
        self.showError(Constants.Error.LoginError.invalidFields)
    }
    
    func invalidEmail() {
        self.showError(Constants.Error.LoginError.emailError)
    }
    
    func empltyFields() {
        self.showError(Constants.Error.LoginError.fillField)
    }
    
    func invalidPassword() {
        self.showError(Constants.Error.LoginError.passwordError)
    }
}
