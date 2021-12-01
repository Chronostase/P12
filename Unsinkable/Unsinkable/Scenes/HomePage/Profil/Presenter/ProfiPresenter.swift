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
        userAuthenticationService.deleteUser() { error in
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
}
