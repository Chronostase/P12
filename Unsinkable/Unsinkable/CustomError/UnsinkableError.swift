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
    case operationNotAllowed
    
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
    
    //projectCreation
    case setTitle
    
    //Dabase
    case databaseCantFetchData
    case databaseCantStoreUser
    case databaseCantUpdate
    case databaseCantDeleteUser
    case databaseCantFetchTask
    case databaseCantStoreProject
    case databaseCantStoreTask
    case databaseCantAccessToProject
    case databaseCantDeleteProject
    case databaseCantUpdateTask
    case databaseCantDeleteTask
    case databaseCantFetchUserData
    
    //Storage
    case storageCantDeleteItems
    case storageCantListItems
    case storageCantSaveImage
    
    //StorageErrorCode
    case storageObjectNotFound
    case storageBucketNotFound
    case storageProjectNotFound
    case storageQuotaExceeded
    case storageUnauthenticate
    case storageUnauthorized
    case storageRetryLimiteExceeded
    case storageNonMatchingCheckSum
    case storageCanceled
    case downloadSizeExceeded 
    
    //Image
    case imageDownloadUrl
    
    
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
            case .operationNotAllowed:
                return Constants.Error.Title.operationNotAllowed
            
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
                
                //Project creation
            case .setTitle:
                return Constants.Error.Title.setTitle
                
                //Database
            case .databaseCantStoreProject:
                return Constants.Error.Title.databaseCantStoreProject
            case .databaseCantStoreUser:
                return Constants.Error.Title.databaseCantStoreUser
            case .databaseCantUpdate:
                return Constants.Error.Title.databaseCantUpdate
            case .databaseCantDeleteUser:
                return Constants.Error.Title.databaseCantDeleteUser
            case .databaseCantFetchData:
                return Constants.Error.Title.databaseCantFetchData
            case .databaseCantFetchTask:
                return Constants.Error.Title.databaseCantFetchTask
            case .databaseCantStoreTask:
                return Constants.Error.Title.databaseCantStoreTask
            case .databaseCantAccessToProject:
                return Constants.Error.Title.databaseCantAccessToProject
            case .databaseCantDeleteProject:
                return Constants.Error.Title.databaseCantDeleteProject
            case .databaseCantUpdateTask:
                return Constants.Error.Title.databaseCantUpdateTask
            case .databaseCantDeleteTask:
                return Constants.Error.Title.databaseCantDeleteTask
            case .databaseCantFetchUserData:
                return Constants.Error.Title.databaseCantFetchUserData
                
                //Storage
            case .storageCantListItems:
                return Constants.Error.Title.storageCantListItems
            case .storageCantDeleteItems:
                return Constants.Error.Title.storageCantDeleteItems
            case .storageCantSaveImage:
                return Constants.Error.Title.storageCantSaveImage
                                
                //StorageErrorCode
        case .storageObjectNotFound:
            return Constants.Error.Title.storageObjectNotFound
        case .storageBucketNotFound:
            return Constants.Error.Title.storageBucketNotFound
        case .storageProjectNotFound:
            return Constants.Error.Title.storageProjectNotFound
        case .storageQuotaExceeded:
            return Constants.Error.Title.storageQuotaExceeded
        case .storageUnauthenticate:
            return Constants.Error.Title.storageUnauthenticate
        case .storageUnauthorized:
            return Constants.Error.Title.storageUnauthorized
        case .storageRetryLimiteExceeded:
            return Constants.Error.Title.storageRetryLimiteExceeded
        case .storageNonMatchingCheckSum:
            return Constants.Error.Title.nonMatchingCheckSum
        case .storageCanceled:
            return Constants.Error.Title.canceled
        case .downloadSizeExceeded:
            return Constants.Error.Title.downloadSizeExceeded
            
            //Image
        case .imageDownloadUrl:
            return Constants.Error.Title.imageDownloadUrl

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
            case .operationNotAllowed:
                return Constants.Error.Body.operationNotAllowed
            
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
                
                //project creation
            
            case .setTitle:
                return Constants.Error.Body.setTitle
                
                //Database
            case .databaseCantStoreProject:
                return Constants.Error.Body.databaseCantStoreProject
            case .databaseCantStoreUser:
                return Constants.Error.Body.databaseCantStoreUser
            case .databaseCantUpdate:
                return Constants.Error.Body.databaseCantUpdate
            case .databaseCantDeleteUser:
                return Constants.Error.Body.databaseCantDeleteUser
            case .databaseCantFetchData:
                return Constants.Error.Body.databaseCantFetchData
            case .databaseCantFetchTask:
                return Constants.Error.Body.databaseCantFetchData
            case .databaseCantStoreTask:
                return Constants.Error.Body.databaseCantStoreTask
            case .databaseCantAccessToProject:
                return Constants.Error.Body.databaseCantAccessToProject
            case .databaseCantDeleteProject:
                return Constants.Error.Body.databaseCantDeleteProject
            case .databaseCantUpdateTask:
                return Constants.Error.Body.databaseCantUpdateTask
            case .databaseCantDeleteTask:
                return Constants.Error.Body.databaseCantDeleteTask
            case .databaseCantFetchUserData:
                return Constants.Error.Body.databaseCantFetchUserData
                
                //Storage
            case .storageCantListItems :
                return Constants.Error.Body.storageCantListItems
            case .storageCantDeleteItems:
                return Constants.Error.Body.storageCantDeleteItems
            case .storageCantSaveImage:
                return Constants.Error.Body.storageCantSaveImage
                
                //StorageErrorCode
        case .storageObjectNotFound:
            return Constants.Error.Body.storageObjectNotFound
        case .storageBucketNotFound:
            return Constants.Error.Body.storageBucketNotFound
        case .storageProjectNotFound:
            return Constants.Error.Body.storageProjectNotFound
        case .storageQuotaExceeded:
            return Constants.Error.Body.storageQuotaExceeded
        case .storageUnauthenticate:
            return Constants.Error.Body.storageUnauthenticate
        case .storageUnauthorized:
            return Constants.Error.Body.storageUnauthorized
        case .storageRetryLimiteExceeded:
            return Constants.Error.Body.storageRetryLimiteExceeded
        case .storageNonMatchingCheckSum:
            return Constants.Error.Body.nonMatchingCheckSum
        case .storageCanceled:
            return Constants.Error.Body.canceled
        case .downloadSizeExceeded:
            return Constants.Error.Body.downloadSizeExceeded
            
            //Image
        case .imageDownloadUrl:
            return Constants.Error.Body.imageDownloadUrl
        }
    }
}
