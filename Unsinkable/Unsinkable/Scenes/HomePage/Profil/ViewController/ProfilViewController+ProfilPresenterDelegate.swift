//
//  ProfilViewController+ProfilPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

extension ProfilViewController: ProfilPresenterDelegate {
    func showError(_ message: String) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = message
    }
    
    func deleteAllUserRefSucceed() {
        profilPresenter.deleteUser()
    }
    
    func deleteAllUserRefFailed() {
        print("DeleteAllUserRefFailed")
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
        self.errorLabel.text = Constants.Error.retry
    }
    
    
    func logoutSucceed() {
        self.navigationController?.popToRootViewController(animated: false)
        self.transitionToMainLoginPage()
    }
    
    func logoutFailed() {
        self.showError(Constants.Error.retry)
    }
    
    func updateUserFailed() {
        self.errorLabel.isHidden = false
        self.errorLabel.text = Constants.Error.retry
    }
    
    func updateUserSucceed() {
        self.errorLabel.isHidden = true 
    }
}
