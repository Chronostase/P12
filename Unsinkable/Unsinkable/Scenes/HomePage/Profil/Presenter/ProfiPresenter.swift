//
//  ProfiPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

protocol ProfilPresenterDelegate: AnyObject {
    func logoutSucceed()
    func logoutFailed()
    func deleteUserSucceed()
    func deleteUserFailed()
    func deleteAllUserRefSucceed()
    func deleteAllUserRefFailed()
    func updateUserSucceed()
    func updateUserFailed()
    func showError()
}

class ProfiPresenter {
    
    weak var delegate: ProfilPresenterDelegate?
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    let databaseManager: ProjectLogic = ProjectService()
    var data: CustomResponse?
    
    func logOut() {
        if userAuthenticationService.logOut() == true {
            delegate?.logoutSucceed()
        } else {
            delegate?.logoutFailed()
        }
    }
    
    func deleteUser() {
        guard let user = data?.user else {return}
        userAuthenticationService.deleteUser(user) { error in
            if error != nil {
                self.delegate?.deleteUserFailed()
            } else {
                //Succeed
                self.delegate?.deleteUserSucceed()
            }
            
        }
    }
    
    func deleteAllUserRef() {
        databaseManager.deleteAllUserRef(data) { error in
            if error != nil {
                self.delegate?.deleteAllUserRefFailed()
            } else {
                self.delegate?.deleteAllUserRefSucceed()
            }
        }
    }
    
    func updateUser(_ firstName: String,_ name: String,_ email: String) {
        if isEmailValid(email) {
            let user = data?.user
            userAuthenticationService.updateUser(user, firstName, name, email) { error in
                if error != nil {
                    self.delegate?.updateUserFailed()
                } else {
                    self.delegate?.updateUserSucceed()
                }
            }
        } else {
            self.delegate?.showError()
        }
    }
    
    private func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        return Regex.validateEmail(candidate: email)
    }
}
