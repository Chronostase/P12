//
//  ProfilViewController+ProfilPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

extension ProfilViewController: ProfilPresenterDelegate {
    
    //Switch deleteAllUser ref result to handle error, or delete user in FireAuth
    func deleteAllUSerRefComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            profilPresenter.deleteUser()
        case .failure(let error):
            guard let message = error.errorDescription else {return}
            showError(message)
        }
    }
    
    //Switch deleteUser result to manage navigation or handle error
    func deleteUserComplete(_ result: Result<Void,UnsinkableError>) {
        switch result {
        case .success(()):
            //Get back to authentication
            self.errorLabel.isHidden = true
            self.navigationController?.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
            
            self.navigationController?.viewControllers.removeAll()
            self.transitionToMainLoginPage()
            
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            self.navigationController?.dismiss(animated: true)
            showError(messageBody)
            
        }
    }
    
    //Switch logout result to manage navigation / handle error
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
    //Switch udpateUser result to manage error
    func updateUserComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            self.errorLabel.isHidden = true
        case .failure(let error):
            self.errorLabel.isHidden = false
            self.errorLabel.text = error.errorDescription
        }
    }
    
    //Show error to user 
    func showError(_ message: String) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = message
    }
}
