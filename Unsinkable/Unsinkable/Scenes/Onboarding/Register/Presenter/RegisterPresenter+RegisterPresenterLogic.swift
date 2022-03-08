//
//  RegisterPresenter+RegisterPresenterLogic.swift
//  Unsinkable
//
//  Created by Thomas on 02/03/2022.
//

import Foundation

extension RegisterPresenter: RegisterPresenterLogic {
    
    func registerUser(_ firstname: String?, _ name: String?, _ email: String?, _ password: String?, callback: @escaping (Result<Void, UnsinkableError>)-> Void) {
        //Check if all fields are valid and format string
        if isAllFieldsValid(firstname, name, email, password) {
            guard let firstname = formatFields(string: firstname), let name = formatFields(string: name), let email = formatFields(string: email), let password = formatFields(string: password) else {
                return
            }
            //CreateUser
            service.createUserWithInformations(firstname, name, email, password) { (result) in
                switch result {
                case .success(_):
                    callback(.success(()))
                    return
                    
                case .failure(let customError):
                    callback(.failure(customError))
                    return
                }
            }
        }
    }
    
    func isAllFieldsValid(_ firstname: String?, _ name: String?, _ email: String?, _ password: String?) -> Bool {
        guard isInformedField(firstname) && isInformedField(name) && isInformedField(email) && isInformedField(password) else {
            self.registerDelegate?.empltyFields()
            return false
        }
        
        guard isEmailValid(email) else {
            self.registerDelegate?.invalidEmail()
            return false
        }
        
        guard isPasswordValid(password: password) else {
            self.registerDelegate?.invalidPassword()
            return false
        }
        return true
    }
    
    func isInformedField(_ field: String?) -> Bool {
        guard let field = field else {
            return false
        }
        return field.count > 1
    }
    
    func isPasswordValid(password: String?) -> Bool {
        guard let cleanedPassword = formatFields(string: password) else {
            return false
        }
        
        if Regex.isPasswordValide(cleanedPassword) {
            
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
    
    
    func formatFields(string: String?) -> String? {
        guard let newString = string?.formatCharacter() else {
            return nil
        }
        return newString
    }
    
    
}
