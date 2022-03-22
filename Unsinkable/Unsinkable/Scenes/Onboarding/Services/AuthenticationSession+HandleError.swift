//
//  AuthenticationSession+HandleError.swift
//  Unsinkable
//
//  Created by Thomas on 27/01/2022.
//

import Foundation
import FirebaseAuth

extension FirebaseAuthenticationSession {
    
    func handleErrorWith(_ errorCode: AuthErrorCode) -> UnsinkableError {
        switch errorCode {
        case .invalidEmail:
            return UnsinkableError.registerInvalidEmail
        case .emailAlreadyInUse:
            return UnsinkableError.registerEmailAlreadyUse
        case .weakPassword:
            return UnsinkableError.registerWeakPassword
            
        case .wrongPassword:
            return UnsinkableError.loginWrongPassword
        case .userDisabled:
            return UnsinkableError.loginUserDisabled
        case .operationNotAllowed:
            return UnsinkableError.loginOperationNotAllowed
        case .requiresRecentLogin:
            return UnsinkableError.requieredRecentLogin
        default :
            return UnsinkableError.unknowError
        }
    }
    
}
