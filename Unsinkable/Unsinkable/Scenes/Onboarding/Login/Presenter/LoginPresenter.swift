//
//  LoginPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 10/02/2021.
//

import Foundation

protocol LoginPresenterDelegate: AnyObject {
    func loginSucceed()
    func loginFailed(_ message: String?)
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
                self.delegate?.loginFailed(Constants.Error.Body.incorrectLog)
                return
            }
            
            if isEmailValid(email) {
                userAuthenticationService.loginUser(email, password) { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.delegate?.loginSucceed()
                        return
                        
                    case .failure(let error):
                        guard let errorMessage = error.errorDescription else {return}
                        self?.delegate?.loginFailed(errorMessage)
                        return
                    }
                }

            } else {
                self.delegate?.loginFailed(Constants.Error.Body.emailError)
            }
            
        } else {
            delegate?.emptyFields()
        }
    }
    
    private func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        return Regex.validateEmail(candidate: email)
    }
}
