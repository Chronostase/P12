//
//  RegisterViewController+RegisterPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/04/2021.
//

import Foundation

extension RegisterViewController: RegisterPresenterDelegate {
    
    func registerSucceed() {
        self.transitionToHomeScreen()
    }
    
    func registerFailed() {
        self.showError("some fields are invalid please check them.")
    }
    
    func invalidEmail() {
        self.showError("Email is not correct.")
    }
    
    func empltyFields() {
        self.showError("Please fill all fields.")
    }
    
    func invalidPassword() {
        self.showError("Password needs at least 8 characters, one special, one uppercase.")
    }
}
