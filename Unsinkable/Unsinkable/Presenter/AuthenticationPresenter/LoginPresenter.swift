//
//  LoginPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 10/02/2021.
//

import Foundation

protocol LoginPresenterDelegate: class {
    func loginSucceed()
    func loginFailed()
    func emptyFields()
}

class LoginPresenter {

    weak var delegate: LoginPresenterDelegate?
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    
    func checkTextFieldsAvailable(_ email: String?, _ password: String?) -> Bool {
        if email != "" && password != "" {
            return true
        } else {
            return false
        }
    }
    
    func login(email: String?, password: String?) {
        if checkTextFieldsAvailable(email, password) {
            guard let email = email?.formatCharacter(), let password = password?.formatCharacter() else {
                self.delegate?.loginFailed()
                return
            }
            userAuthenticationService.loginUser(email, password) { [weak self] result in
                switch result {
                case .success(_):
                    self?.delegate?.loginSucceed()
                    return
                    
                case .failure(_):
                    self?.delegate?.loginFailed()
                    return
                }
            }
        } else {
            delegate?.emptyFields()
        }
    }
}
