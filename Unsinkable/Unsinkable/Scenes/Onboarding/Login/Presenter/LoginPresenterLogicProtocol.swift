//
//  LoginPresenterLogicProtocol.swift
//  Unsinkable
//
//  Created by Thomas on 28/02/2022.
//

import Foundation

extension LoginPresenter: LoginPresenterLogic {
    
    //Check if textField are not nil and not empty
    func isTextFieldAvailable(_ email: String?,_ password: String?) -> Bool {
        guard let email = email, let password = password else {return false}
        if email != "" && password != "" {
            return true
        } else {
            return false
        }
    }
    
    //Use regex to check if email have correct syntax
    func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        return Regex.validateEmail(candidate: email)
    }
    
    //Proceed to check and call service to login user
    func logUser(_ email: String?,_ password: String?,  callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void) {
        if isTextFieldAvailable(email,password) {
            guard let email = email?.formatCharacter(), let password = password?.formatCharacter() else {
                self.delegate?.loginFailed(Constants.Error.Body.incorrectLog)
                return
            }
            if isEmailValid(email) {
                service.loginUser(email, password) { result in
                    switch result {
                    case .success(let customResponse):
                        callback(.success(customResponse))
                        return
                        
                    case .failure(let error):
                        callback(.failure(error))
                        return 
                    }
                }
            } else {
                self.delegate?.loginFailed(Constants.Error.Body.emailError)
                
            }
        } else {
            self.delegate?.emptyFields()
        }
    }
    
    
}
