//
//  RegisterViewController+RegisterPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/04/2021.
//

import Foundation

extension RegisterViewController: RegisterPresenterDelegate {
    
    func registerComplete(_ result: Result<Void,UnsinkableError>) {
        switch result {
        case .success(()):
            self.navigationController?.dismiss(animated: true)
            #warning("not sure")
            self.navigationController?.viewControllers.removeAll()
            self.transitionToHomeScreen()
        case .failure(let error):
            self.navigationController?.dismiss(animated: true)
            guard let errorBody = error.errorDescription else {return}
            self.showError(errorBody)
            
        }
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
