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
        self.transitionToHomeScreen()
    }
    
    func loginFailed() {
        self.showError("Incorrect log please retry.")
    }
    
    
}
