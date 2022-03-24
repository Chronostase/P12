//
//  RegisterViewController+RegisterPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/04/2021.
//

import Foundation

extension RegisterViewController: RegisterPresenterDelegate {
    
    //Switch between register result to show error or push homeScreen
    func registerComplete(_ result: Result<Void,UnsinkableError>) {
        switch result {
        case .success(()):
            self.navigationController?.dismiss(animated: true)
            self.navigationController?.viewControllers.removeAll()
            self.transitionToHomeScreen()
        case .failure(let error):
            self.navigationController?.dismiss(animated: true)
            guard let errorBody = error.errorDescription else {return}
            self.showError(errorBody)
            
        }
    }
    
    //Dismiss loader and show email error
    func invalidEmail() {
        self.navigationController?.dismiss(animated: true)
        self.showError(Constants.Error.Body.emailError)
    }
    
    //Dismiss loader and show emptyFields error
    func empltyFields() {
        self.navigationController?.dismiss(animated: true)
        self.showError(Constants.Error.Body.fillField)
    }
    
    //Dismiss loader and show password error
    func invalidPassword() {
        self.navigationController?.dismiss(animated: true)
        self.showError(Constants.Error.Body.passwordError)
    }
}
