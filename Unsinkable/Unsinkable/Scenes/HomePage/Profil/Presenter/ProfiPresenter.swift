//
//  ProfiPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

protocol ProfilPresenterDelegate: AnyObject {
    
    func logoutComplete(_ result: Result<Void,UnsinkableError>)
    
    func deleteUserComplete(_ result: Result<Void,UnsinkableError>)
    func deleteAllUSerRefComplete(_ result: Result<Void,UnsinkableError>)
    
    func updateUserComplete(_ result: Result<Void, UnsinkableError>)
    
    func showError(_ message: String)
}

class ProfiPresenter {
    
    weak var delegate: ProfilPresenterDelegate?
    let userAuthenticationService: AuthenticationLogic = UserAuthenticationService()
    let databaseManager: ProjectLogic = ProjectService()
    var data: CustomResponse?
    
    func logOut() {
        if userAuthenticationService.logOut() == true {
            self.delegate?.logoutComplete(.success(()))
        } else {
            self.delegate?.logoutComplete(.failure(UnsinkableError.unknowError))
        }
    }
    
    func deleteUser() {
        guard let user = data?.user else {return}
        userAuthenticationService.deleteUser(user) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteUserComplete(.failure(error))
            } else {
                //Succeed
                self.delegate?.deleteUserComplete(.success(()))
            }
            
        }
    }
    
    func deleteAllUserRef() {
        databaseManager.deleteAllUserRef(data) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteAllUSerRefComplete(.failure(error))
            } else {
                self.delegate?.deleteAllUSerRefComplete(.success(()))
            }
        }
    }
    
    func updateUser(_ firstName: String,_ name: String,_ email: String) {
        
        if firstName == "" || name == "" || email == "" {
            self.delegate?.showError(Constants.Error.Body.fillField)
        }
        if isEmailValid(email) {
            let user = data?.user
            userAuthenticationService.updateUser(user, firstName, name, email) { error in
                if error != nil {
                    guard let error = error else {return}
                    self.delegate?.updateUserComplete(.failure(error))
                } else {
                    self.delegate?.updateUserComplete(.success(()))
                }
            }
        } else {
            self.delegate?.showError(Constants.Error.Body.emailError)
        }
    }
    
    private func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        return Regex.validateEmail(candidate: email)
    }
}
