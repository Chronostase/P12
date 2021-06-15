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
        //        dataBase.collection("Users").addDocument(data: ["first_name" : firstName,"name": name, "uid": userId])
        dataBase.collection("Users").document("\(userId)").setData(["first_name" : firstName,"name": name,"email" : email, "uid": userId]) { (error) in
            if error != nil {
                guard let error = error else { return }
                completion(nil,error)
            }
            completion(customResponse,error)
        }
    }
    
    func fetchUserFirestoreData(completion: @escaping (CustomResponse?, Error?) -> Void) {
        var user = CustomResponse(user: UserDetails() )
        guard let data = Auth.auth().currentUser else {
            return
        }
        
        let database = Firestore.firestore()
        let documentRef = database.collection("Users").document("\(data.uid)")
        documentRef.getDocument { (documentSnapshot, error) in
            if error != nil {
                completion(nil, error)
            } else {
                if let document = documentSnapshot, document.exists {
                    guard let data = document.data() else {
                        return
                    }
                    
                    let firstname = data["first_name"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    user = CustomResponse(user: UserDetails(email: email, firstName: firstname, name: name, userId: uid))
                    completion(user,nil)
                }
            }
        }
    }
    
    //    func getCurrentUser() -> CustomResponse? {
    //        guard let response =  Auth.auth().currentUser else {
    //            return nil
    //        }
    //        let user = CustomResponse(user: UserDetails(email: response.email,  displayName: response.displayName , userId: response.uid))
    //        return user
    //    }
}
