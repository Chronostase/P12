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

protocol AuthentificationLogic {
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String)
    
    func loginUser(_ email: String,_ password: String) -> Void
}

class UserAuthentificationService: AuthentificationLogic {
    
    func loginUser(_ email: String, _ password: String) -> Void {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("An Error append")
                return RegisterViewController().showError("\(error?.localizedDescription ?? "")")
            }
            print("SuccessFully log")
        }
    }
    
    
    
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // Manage error
//                RegisterViewController().showError("Error creating user")
            } else {
                guard let userId = result?.user.uid else {
                    return
                }
                let dataBase = Firestore.firestore()
                dataBase.collection("Users").addDocument(data: ["first_name" : firstName,"name": name, "uid": userId]) { (error) in
                    if error != nil {
//                        RegisterViewController().showError("Error saving user Data")
                    }
                }
            }
        }
    }
    
    
}
