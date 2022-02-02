//
//  UnsinkableError.swift
//  Unsinkable
//
//  Created by Thomas on 27/01/2022.
//

import Foundation

enum UnsinkableError: Error {
    //Generic Error
    case unknowError
    case requieredRecentLogin
    
    //Login Error
    case loginInvalidEmail
    case loginWrongPassword
    case loginUserDisabled
    case loginOperationNotAllowed
    
    //Register Error
    case registerInvalidEmail
    case registerEmailAlreadyUse
    case registerOperationNotAllowed
    case registerWeakPassword
    
    //Reauthenticate
    case reauthenticateInvalidCredential
    case userMisMatch
    
    //Dabase
    case databaseCantUpdate
    case databaseCantDeleteUser
    case storageCantDeleteItems
    case storageCantListItems
    
    
}

extension UnsinkableError: LocalizedError {
    public var localizedDescription: String {
        //Handle alert error title
        switch self {
                //Generic error
            case .unknowError:
                return Constants.Error.Title.unknowError
            case .requieredRecentLogin :
                return Constants.Error.Title.recentLogin
            
                //Login Error
            case .loginInvalidEmail:
                return Constants.Error.Title.invalidEmail
            case .loginWrongPassword:
                return Constants.Error.Title.loginWrongPassword
            case .loginUserDisabled:
                return Constants.Error.Title.loginUserDisabled
            case .loginOperationNotAllowed:
                return Constants.Error.Title.operationNotAllowed
            
                //register Error
            case .registerInvalidEmail:
                return Constants.Error.Title.invalidEmail
            case .registerEmailAlreadyUse:
                return Constants.Error.Title.registerEmailAlreadyUse
            case .registerOperationNotAllowed:
                return Constants.Error.Title.operationNotAllowed
            case .registerWeakPassword:
                return Constants.Error.Title.registerWeakPassword
                
                //Reauthenticate
            case .reauthenticateInvalidCredential:
                return Constants.Error.Title.invalidCredential
            case .userMisMatch:
                return Constants.Error.Title.userMisMatch
                
                //Database
            case .databaseCantUpdate:
                return Constants.Error.Title.databaseCantUpdate
            case .databaseCantDeleteUser:
                return Constants.Error.Title.databaseCantDeleteUser
            case .storageCantListItems:
                return Constants.Error.Title.storageCantListItems
            case .storageCantDeleteItems:
                return Constants.Error.Title.storageCantDeleteItems
        }
    }
    public var errorDescription: String? {
        //Body alert description
        switch self {
                //Generic Error
            case .unknowError:
                return Constants.Error.Body.unknowError
            case .requieredRecentLogin:
                return Constants.Error.Body.recentLogin
            
                //Login Error
            case .loginInvalidEmail:
                return Constants.Error.Body.emailError
            case .loginWrongPassword:
                return Constants.Error.Body.incorrectPassword
            case .loginUserDisabled:
                return Constants.Error.Body.userDisable
            case .loginOperationNotAllowed:
                return Constants.Error.Body.notAllowOperation
                
                //Register Error
            case .registerInvalidEmail:
                return Constants.Error.Body.emailError
            case .registerEmailAlreadyUse:
                return Constants.Error.Body.emailAlreadyUse
            case .registerOperationNotAllowed:
                return Constants.Error.Body.notAllowOperation
            case .registerWeakPassword:
                return Constants.Error.Body.weakPassword
                
                //Reauthenticate Error
        
            case .reauthenticateInvalidCredential:
                return Constants.Error.Body.invalidCredential
            case .userMisMatch:
                return Constants.Error.Body.userMisMatch
                
                //Database
            case .databaseCantUpdate:
                return Constants.Error.Body.databaseCantUpdate
            case .databaseCantDeleteUser:
                return Constants.Error.Body.databaseCantDeleteUser
            case .storageCantListItems :
                return Constants.Error.Body.storageCantListItems
            case .storageCantDeleteItems:
                return Constants.Error.Body.storageCantDeleteItems
        }
    }
}
