//
//  LoginViewController+LoginPresenterDelegat.swift
//  Unsinkable
//
//  Created by Thomas on 15/04/2021.
//
//import UIKit
import Foundation

extension LogInViewController: LoginPresenterDelegate {
    func loginSucceed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
        self.transitionToHomeScreen()
    }
    
    func loginFailed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.showError("Incorrect log please retry.")
    }
    
    func emptyFields() {
        self.showError("Please fill in all fields")
    }
    
    
}
