//
//  ProfilViewController+ProfilPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

extension ProfilViewController: ProfilPresenterDelegate {
    
    func deleteAllUSerRefComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            profilPresenter.deleteUser()
        case .failure(let error):
            guard let message = error.errorDescription else {return}
            showError(message)
        }
    }
    
    func deleteUserComplete(_ result: Result<Void,UnsinkableError>) {
        switch result {
        case .success(()):
            //Get back to authentication
            self.errorLabel.isHidden = true
            self.navigationController?.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
            self.transitionToMainLoginPage()
            
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            self.navigationController?.dismiss(animated: true)
            showError(messageBody)
            
        }
    }
    
    func logoutComplete(_ result: Result<Void,UnsinkableError>) {
        switch result {
        case .success(()):
            self.navigationController?.popToRootViewController(animated: false)
            self.transitionToMainLoginPage()
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            self.showError(messageBody)
        }
    }
    
    func updateUserComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            self.errorLabel.isHidden = true
        case .failure(let error):
            self.errorLabel.isHidden = false
            self.errorLabel.text = error.errorDescription
        }
    }
    
    func showError(_ message: String) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = message
    }
}
