//
//  RegisterPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 27/01/2021.
//

import Foundation

protocol RegisterPresenterDelegate: AnyObject {
    
    func registerComplete(_ result: Result<Void,UnsinkableError>)
    func empltyFields()
    func invalidPassword()
    func invalidEmail()
}

protocol RegisterPresenterLogic {
    func registerUser(_ firstname: String?,_ name: String?,_ email: String?,_ password: String?, callback: @escaping (Result<Void, UnsinkableError>) -> Void)
    func isAllFieldsValid(_ firstname: String?,_ name: String?,_ email: String?,_ password: String?) -> Bool
    func isInformedField(_ field: String?) -> Bool
    func formatFields(string: String?) -> String?
    func isPasswordValid(password: String?) -> Bool
    func isEmailValid(_ email: String?) -> Bool
}

class RegisterPresenter {
    
    weak var registerDelegate: RegisterPresenterDelegate?
    let service: AuthenticationLogic
    init (session: AuthenticationLogic = UserAuthenticationService()) {
        self.service = session
    }
    //Initiate register process
    func registerWith(_ firstname: String?,_ name: String?,_ email: String?,_ password: String?) {
        registerUser(firstname, name, email, password) { result in
            switch result {
                case .success():
                    self.registerDelegate?.registerComplete(.success(()))
                case .failure(let error):
                    self.registerDelegate?.registerComplete(.failure(error))
            }
        }
    }
}
