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
            print(error.errorDescription)
        }
    }
    
    
    
    func showError(_ message: String) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = message
    }
    
    func deleteUserSucceed() {
        //Get back to authentification
        self.errorLabel.isHidden = true
        self.navigationController?.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
        self.transitionToMainLoginPage()
    }
    
    func deleteUserFailed() {
        //Show error
        self.navigationController?.dismiss(animated: true)
        self.errorLabel.isHidden = false
        self.errorLabel.text = Constants.Error.Body.unknowError
    }
    
    
    func logoutSucceed() {
        self.navigationController?.popToRootViewController(animated: false)
        self.transitionToMainLoginPage()
    }
    
    func logoutFailed() {
        self.showError(Constants.Error.Body.unknowError)
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
}
