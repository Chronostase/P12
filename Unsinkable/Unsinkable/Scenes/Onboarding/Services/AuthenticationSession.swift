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
            let customUser = CustomResponse(user: UserDetails(email: user.email, password: user.displayName, userId: user.uid, projects: nil))
            
            completion(customUser, error)
        }
    }
    
    func createUserRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (dataResponse, error) in
            
            guard let user = dataResponse?.user else {
                
                return completion(nil,error)
            }
            let customUser = CustomResponse(user: UserDetails(email: user.email, userId: user.uid))
            completion(customUser,error)
        }
    }
    
    func addUserToDataBase(customResponse: CustomResponse?,_ firstName: String, _ name: String, _ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = customResponse?.user.userId else { return }
        let dataBase = Firestore.firestore()
        let documentRef = dataBase.collection("Users").document(userId)
        documentRef.setData(["first_name" : firstName,"name": name,"email" : email, "uid": userId])
        { (error) in
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
                    user = CustomResponse(user: UserDetails(email: email, firstName: firstname, name: name, userId: uid, projects: []))
                    completion(user,nil)
                }
            }
        }
    }
    
    func fetchProjects(_ userData: CustomResponse?, completion: @escaping ([Project?]?, Error?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        let dataBase = Firestore.firestore()
        let documentRef = dataBase.collection("Users").document(userId).collection("Projects")
            documentRef.getDocuments() { (querySnapshot, error) in
            if error != nil {
                guard let error = error else { return }
                completion(nil, error)
            } else {
                var projectList = [Project?]()
                guard let query = querySnapshot else { return }
                for document in query.documents {
                    let data = document.data()
                    let title = data["Title"] as? String ?? ""
                    let description = data["Description"] as? String ?? ""
                    let ownerUserId = data["ownerUserId"] as? String ?? ""
                    let isPersonal = data["isPersonal"] as? Bool
                    let downloadUrl = data["downloadUrl"] as? String ?? ""
                    let project = Project(title: title, description: description, ownerUserId: ownerUserId, isPersonal: isPersonal, downloadUrl: downloadUrl, taskList: nil)
                    projectList.append(project)
                }
                completion(projectList, nil)
            }
        }
    }
    
    func logOutUser() -> Bool {
        let fireAuth = Auth.auth()
        do {
            try fireAuth.signOut()
            return true
        }
        catch let signOutError as NSError {
            print(signOutError)
            return false
        }
    }
    
    func isCurrentUserLogin() -> Bool {
        guard let _ = Auth.auth().currentUser else {
            return false
        }
        return true
    }
    
}
