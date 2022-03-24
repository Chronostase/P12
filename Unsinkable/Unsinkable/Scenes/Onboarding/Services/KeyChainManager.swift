//
//  KeyChainManager.swift
//  Unsinkable
//
//  Created by Thomas on 14/12/2021.
//

import Foundation
import KeychainSwift

class KeyChainManager {
    let keyChain = KeychainSwift()
    
    //Register user credential in KeyChainManager
    func registerUserCredential(_ user: UserDetails,_ password: String) {
        guard let userId = user.userId else {return}
        keyChain.set(password, forKey: userId)
    }
    
    //fetch user credential store in keyChainManager
    func getUserCredential(_ user: UserDetails) -> String? {
        guard let userId = user.userId else {return nil}
        return keyChain.get(userId)
    }
    
    //Remove user credential from keychainmanager 
    func deleteKey(_ user: UserDetails) -> Bool? {
        guard let userId = user.userId else {return nil}
        return keyChain.delete(userId)
    }
}
