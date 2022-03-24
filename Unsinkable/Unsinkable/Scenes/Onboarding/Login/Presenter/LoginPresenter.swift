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

protocol LoginPresenterLogic {
    func isTextFieldAvailable(_ email: String?,_ password: String?) -> Bool
    func isEmailValid(_ email: String?) -> Bool
    func logUser(_ email: String?,_ password: String?, callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void)
}

class LoginPresenter {
    
    weak var delegate: LoginPresenterDelegate?
    let service: AuthenticationLogic
    init (session: AuthenticationLogic = UserAuthenticationService()) {
        self.service = session
    }
    
    //Initiate login process and call delegate method 
    func login(_ email: String?,_ password: String?) {
        logUser(email, password) { result in
            switch result {
            case .success(_):
                self.delegate?.loginSucceed()
            case .failure(let error):
                guard let messageError = error.errorDescription else {return}
                self.delegate?.loginFailed(messageError)
            }
        }
    }
}
