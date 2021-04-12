//
//  RegisterPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 27/01/2021.
//

import Foundation

protocol RegisterPresenterDelegate: class {
    
    func formatedString(string: String?) -> String?
    
    func checkTextFieldsAvailable(firstName: String?, _ name: String?, _ email: String?, _ password: String?) -> Bool
    
    func checkPasswordAvailable(password: String?) -> Bool
}

class RegisterPresenter {
    
    weak var registerDelegate: RegisterPresenterDelegate?
    
    func checkTextFieldsAvailable(firstName: String?, _ name: String?, _ email: String?, _ password: String?) -> Bool {
        if firstName != "" && name != "" && email != "" && password != "" {
            return true
        } else {
            return false
        }
    }
    
    func isValideFirstName(_ firstName: String) -> Bool {
        return firstName.count > 1
    }
    
    func isValideName(_ name: String) -> Bool {
        return name.count > 1
    }
    
    func isEmailValide(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    func checkIfPasswordIsCorrect(password: String?) -> Bool {
        guard let cleanedPassword = formatFields(string: password) else {
            
            return false
        }
        
        if Utilities.isPasswordValide(cleanedPassword) {
            
            return true
        } else {
            
            return false
        }
    }
    
    func formatFields(string: String?) -> String? {
        guard let newString = string?.formatCharacter() else {
            return nil
        }
        return newString
    }
}
