//
//  AuthenticationSession.swift
//  Unsinkable
//
//  Created by Thomas on 25/02/2021.
//

import Foundation
import Firebase

class AuthenticationSession {
   
    func signInRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (dataResponse, error) in
            
            guard let user = dataResponse?.user else {
                
                return completion(nil,error)
            }
            let customUser = CustomResponse(user: UserDetails(email: user.email, password: user.displayName, userId: user.uid))

            completion(customUser, error)
        }
    }
    
    func createUserRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (dataResponse, error) in
            
            guard let user = dataResponse?.user else {
                
                return completion(nil,error)
            }
            let customUser = CustomResponse(user: UserDetails(email: user.email, displayName: user.displayName, userId: user.uid))
            completion(customUser,error)
        }
    }
    
    func addUserToDataBase(customResponse: CustomResponse?,_ firstName: String, _ name: String, _ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = customResponse?.user.userId else { return }
        let dataBase = Firestore.firestore()
        // Add user in database collection
        dataBase.collection("Users").addDocument(data: ["first_name" : firstName,"name": name, "uid": userId]) { (error) in
            if error != nil {
                guard let error = error else { return }
                completion(nil,error)
            }
            completion(customResponse,error)
        }
    }
}
