//
//  LoginPresenterLogicProtocol.swift
//  Unsinkable
//
//  Created by Thomas on 28/02/2022.
//

import Foundation

extension LoginPresenter: LoginPresenterLogic {
    
    func isTextFieldAvailable(_ email: String?,_ password: String?) -> Bool {
        guard let email = email, let password = password else {return false}
        if email != "" && password != "" {
            return true
        } else {
            return false
        }
    }
    
    func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        return Regex.validateEmail(candidate: email)
    }
    
    func logUser(_ email: String?,_ password: String?,  callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void) {
        //param callBack handle in presenter allow to fall in .success/fail
        //Ou passer par le delegate OVD return Bool 
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
