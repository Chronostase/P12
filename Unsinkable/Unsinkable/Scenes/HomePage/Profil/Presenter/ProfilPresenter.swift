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

class ProfilPresenter {
    
    weak var delegate: ProfilPresenterDelegate?
    let authService: AuthenticationLogic
    let databaseService: ProjectLogic
    var data: CustomResponse?
    
    init(authSession: AuthenticationLogic = UserAuthenticationService(), projectSession: ProjectLogic = ProjectService() ) {
        self.authService = authSession
        self.databaseService = projectSession
    }
    
    //Call authService to logOut user, call delegate to handle result
    func logOut() {
        if authService.logOut() == true {
            self.delegate?.logoutComplete(.success(()))
        } else {
            self.delegate?.logoutComplete(.failure(UnsinkableError.unknowError))
        }
    }
    
    //Call authService to deleteUser, call delegate to handle result
    func deleteUser() {
        guard let user = data?.user else {return}
        authService.deleteUser(user) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteUserComplete(.failure(error))
            } else {
                //Succeed
                self.delegate?.deleteUserComplete(.success(()))
            }
            
        }
    }
    
    //Call databaseService to deleteAllUserRef, call delegate to handle result
    func deleteAllUserRef() {
        databaseService.deleteAllUserRef(data) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteAllUSerRefComplete(.failure(error))
            } else {
                self.delegate?.deleteAllUSerRefComplete(.success(()))
            }
        }
    }
    
    //Call authService to updateUser, call delegate to handle result
    func updateUser(_ firstName: String,_ name: String,_ email: String) {
        
        if firstName == "" || name == "" || email == "" {
            self.delegate?.showError(Constants.Error.Body.fillField)
        }
        if isEmailValid(email) {
            let user = data?.user
            authService.updateUser(user, firstName, name, email) { error in
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
    
    //Check with regex if email is valid 
    func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        return Regex.validateEmail(candidate: email)
    }
}
