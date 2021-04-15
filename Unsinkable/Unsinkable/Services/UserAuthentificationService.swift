//
//  UserAuthentification.swift
//  Unsinkable
//
//  Created by Thomas on 21/01/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthentificationLogic {
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String, callback: @escaping (Result<AuthDataResult?, Error>) -> Void)
    
    func loginUser(_ email: String,_ password: String, callback: @escaping (Result<AuthDataResult?, Error>) -> Void )
}

class UserAuthentificationService: AuthentificationLogic {
    
    let session: AuthenticationSession
    
    init(session: AuthenticationSession = AuthenticationSession()) {
        self.session = session
    }
    func loginUser(_ email: String, _ password: String, callback: @escaping (Result<AuthDataResult?, Error>) -> Void ) {
//        session.request(email, password) { (authDataResult, error) in
//            if error != nil {
//                
//            }
//        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                guard let error = error else {
                    return
                }
                callback(.failure(error))
                print("An Error append")
                return Void()
            } else {
                callback(.success(result))
                print("successfully log")
            }
        }
    }
    
    
    
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String, callback: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                guard let error = error else {
                    return
                }
                callback(.failure(error))
                // Manage error n//                RegisterViewController().showError("Error creating user")
            } else {
                guard let userId = result?.user.uid else {
                    return
                }
                let dataBase = Firestore.firestore()
                // Add user in database collection
                dataBase.collection("Users").addDocument(data: ["first_name" : firstName,"name": name, "uid": userId]) { (error) in
                    if error != nil {
                        guard let error = error else {
                            return
                        }
                        callback(.failure(error))
                    }
                    callback(.success(result))
                }
            }
        }
    }
    
    
}
