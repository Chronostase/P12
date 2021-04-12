//
//  AuthenticationSession.swift
//  Unsinkable
//
//  Created by Thomas on 25/02/2021.
//

import Foundation
import Firebase


protocol AuthenticationResultProtocol {
    var user: User { get }

}
extension AuthDataResult: AuthenticationResultProtocol {
    
}

class AuthenticationSession {
    
    func request(_ email: String,_ password: String, completion: @escaping (AuthenticationResultProtocol, Error) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { (dataResponse, error) in
//            completion(dataResponse, error)
//        }
    }
}
