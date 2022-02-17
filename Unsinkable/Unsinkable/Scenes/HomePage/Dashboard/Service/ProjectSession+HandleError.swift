//
//  ProjectSession+HandleError.swift
//  Unsinkable
//
//  Created by Thomas on 07/02/2022.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

extension ProjectSession {
    
    func handleStorageError(_ errorCode: StorageErrorCode) -> UnsinkableError {
        switch errorCode {
        case .unknown:
            return UnsinkableError.unknowError
        case .objectNotFound:
            return UnsinkableError.storageObjectNotFound
        case .bucketNotFound:
            return UnsinkableError.storageBucketNotFound
        case .projectNotFound:
            return UnsinkableError.storageProjectNotFound
        case .quotaExceeded:
            return UnsinkableError.storageQuotaExceeded
        case .unauthenticated:
            return UnsinkableError.storageUnauthenticate
        case .unauthorized:
            return UnsinkableError.storageUnauthorized
        case .nonMatchingChecksum:
            return UnsinkableError.storageNonMatchingCheckSum
        case .cancelled:
            return UnsinkableError.storageCanceled
        case .downloadSizeExceeded:
            return UnsinkableError.downloadSizeExceeded
        default:
            return UnsinkableError.unknowError
        }
    }
    
    func handleAuthErrorWith(_ errorCode: AuthErrorCode) -> UnsinkableError {
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
