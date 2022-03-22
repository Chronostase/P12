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
    
    func registerUserCredential(_ user: UserDetails,_ password: String) {
        guard let userId = user.userId else {return}
        keyChain.set(password, forKey: userId)
    }
    
    func getUserCredential(_ user: UserDetails) -> String? {
        guard let userId = user.userId else {return nil}
        return keyChain.get(userId)
    }
    
    func deleteKey(_ user: UserDetails) -> Bool? {
        guard let userId = user.userId else {return nil}
        return keyChain.delete(userId)
    }
}
