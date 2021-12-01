//
//  ProfilViewController+ProfilPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

extension ProfilViewController: ProfilPresenterDelegate {
    func deleteAllUserRefSucceed() {
        profilPresenter.deleteUser()
    }
    
    func deleteAllUserRefFailed() {
        print("DeleteAllUserRefFailed")
    }
    
    func deleteUserSucceed() {
        #warning("Don't forget to delete all data from deleted user")
        //Get back to authentification
            self.navigationController?.popViewController(animated: true)
            self.transitionToMainLoginPage()
    }
    
    func deleteUserFailed() {
        //Show error
        print("An error append retry later")
    }
    
    
    func logoutSucceed() {
        self.navigationController?.popToRootViewController(animated: false)
        self.transitionToMainLoginPage()
    }
    
    func logoutFailed() {
        self.showError("An error occured please retry")
    }
}
