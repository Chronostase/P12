//
//  UnsinkableError.swift
//  Unsinkable
//
//  Created by Thomas on 27/01/2022.
//

import Foundation

enum UnsinkableError: Error {
    case unknowError
    
    case loginInvalidEmail
    case loginWrongPassword
    case loginUserDisabled
    case loginOperationNotAllowed
    
    case registerInvalidEmail
    case registerEmailAlreadyUse
    case registerOperationNotAllowed
    case registerWeakPassword
    
}

extension UnsinkableError: LocalizedError {
    public var localizedDescription: String {
        //Handle alert error title
        switch self {
        
            case .unknowError:
                return Constants.Error.Title.unknowError
            
            case .loginInvalidEmail:
                return Constants.Error.Title.invalidEmail
            case .loginWrongPassword:
                return Constants.Error.Title.loginWrongPassword
            case .loginUserDisabled:
                return Constants.Error.Title.loginUserDisabled
            case .loginOperationNotAllowed:
                return Constants.Error.Title.operationNotAllowed
            
            case .registerInvalidEmail:
                return Constants.Error.Title.invalidEmail
            case .registerEmailAlreadyUse:
                return Constants.Error.Title.registerEmailAlreadyUse
            case .registerOperationNotAllowed:
                return Constants.Error.Title.operationNotAllowed
            case .registerWeakPassword:
                return Constants.Error.Title.registerWeakPassword
        }
    }
    public var errorDescription: String? {
        //Body alert description
        switch self {
            case .unknowError:
                return Constants.Error.Body.unknowError
            
            case .loginInvalidEmail:
                return Constants.Error.Body.emailError
            case .loginWrongPassword:
                return Constants.Error.Body.incorrectPassword
            case .loginUserDisabled:
                return Constants.Error.Body.userDisable
            case .loginOperationNotAllowed:
                return Constants.Error.Body.notAllowOperation
                
            case .registerInvalidEmail:
                return Constants.Error.Body.emailError
            case .registerEmailAlreadyUse:
                return Constants.Error.Body.emailAlreadyUse
            case .registerOperationNotAllowed:
                return Constants.Error.Body.notAllowOperation
            case .registerWeakPassword:
                return Constants.Error.Body.weakPassword
        }
    }
}
