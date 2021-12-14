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
        userAuthenticationService.updateUser(firstName, name, email) { error in
            if error != nil {
                self.delegate?.updateUserFailed()
            } else {
                self.delegate?.updateUserSucceed()
            }
        }
    }
    
    func isFieldFill(_ firstName: String?,_ name: String?,_ email: String?) -> Bool {
        if firstName == nil || name == nil || email == nil {
            return false
        } else {
            return true
        }
    }
}
