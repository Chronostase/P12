//
//  LoginPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 10/02/2021.
//

import Foundation

protocol LoginPresenterDelegate: class {
    func checkTextFieldsAvailable(_ email: String?, _ password: String?) -> Bool
}

class LoginPresenter {
    
    weak var loginPresenterDelegate: LoginPresenterDelegate?
    
    func checkTextFieldsAvailable(_ email: String?, _ password: String?) -> Bool {
        if email != "" && password != "" {
            return true
        } else {
            return false
        }
    }
}
