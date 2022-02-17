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

class RegisterPresenter {
    
    weak var registerDelegate: RegisterPresenterDelegate?
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    
    func registerWith(_ firstname: String?,_ name: String?,_ email: String?,_ password: String?) {
        //Check if all fields are valid and format string
        if isAllFieldsValid(firstname, name, email, password) {
            guard let firstname = formatFields(string: firstname), let name = formatFields(string: name), let email = formatFields(string: email), let password = formatFields(string: password) else {
                return
            }
            //CreateUser
            userAuthenticationService.createUserWithInformations(firstname, name, email, password) { (result) in
                switch result {
                case .success(_):
                    self.registerDelegate?.registerComplete(.success(()))
                case .failure(let customError):
                    self.registerDelegate?.registerComplete(.failure(customError))
                }
            }
        }
    }
    
    private func isAllFieldsValid(_ firstname: String?,_ name: String?,_ email: String?,_ password: String?) -> Bool {
        
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
    
    private func isInformedField(_ field: String?) -> Bool {
        guard let field = field else {
            return false
        }
        return field.count > 1
    }
    
    private func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        return Regex.validateEmail(candidate: email)
    }
    
    private func isPasswordValid(password: String?) -> Bool {
        guard let cleanedPassword = formatFields(string: password) else {
            return false
        }
        
        if Regex.isPasswordValide(cleanedPassword) {
            
            return true
        } else {
            return false
        }
    }
    
    private func formatFields(string: String?) -> String? {
        guard let newString = string?.formatCharacter() else {
            return nil
        }
        return newString
    }
}
