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
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String, callback: @escaping (Result<CustomResponse?, Error>) -> Void)
    
    func loginUser(_ email: String,_ password: String, callback: @escaping (Result<CustomResponse?, Error>) -> Void )
    
    func getUserData(completion: @escaping (Result<CustomResponse?, Error>) -> Void)
    
    func logOut() -> Bool
    
    func isUserLogin() -> Bool
    
    func fetchProjects(_ userData: CustomResponse?, completion: @escaping (Result<[Project?]?, Error>) -> Void)
    
    func deleteUser(_ user: UserDetails, completion: @escaping (Error?) -> Void)
    
    func updateUser(_ user: UserDetails?, _ firstName: String,_ name: String,_ email: String, completion: @escaping (Error?) -> Void)
    
}

class UserAuthentificationService: AuthentificationLogic {
    
    let session: AuthenticationSession
    
    init(session: AuthenticationSession = AuthenticationSession()) {
        self.session = session
    }
    
    func updateUser(_ user: UserDetails?, _ firstName: String,_ name: String,_ email: String, completion: @escaping (Error?) -> Void) {
        self.session.updateUser(user, firstName, name, email) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func loginUser(_ email: String, _ password: String, callback: @escaping (Result<CustomResponse?, Error>) -> Void ) {
        
        session.signInRequest(email, password) { (result, error) in
            if error != nil {
                guard let error = error else { return }
                callback(.failure(error))
                print("An Error append")
            } else {
                callback(.success(result))
                print("successfully log")
            }
        }
    }
    
    func logOut() -> Bool {
        return session.logOutUser()
    }
    
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String, callback: @escaping (Result<CustomResponse?, Error>) -> Void) {
        
        session.createUserRequest(email, password) { (result, error) in
            if error != nil {
                guard let error = error else { return }
                callback(.failure(error))
            } else {
                guard let customResponse = result else { return }
                self.storeUser(customResponse, firstName: firstName, name) { (response,error) in
                    callback(.success(result))
                }
            }
        }
    }
    
    //Store user in Firebase Storage
    func storeUser(_ customResponse: CustomResponse, firstName: String,_ name: String, callback: @escaping (CustomResponse?, Error?) -> Void) {
        self.session.addUserToDataBase(customResponse: customResponse, firstName, name) { (result, error) in
            
            if error != nil {
                guard let error = error else { return }
                callback(nil,error)
            } else {
                callback(customResponse,nil)
            }
        }
    }
    
    
    func deleteUser(_ user: UserDetails, completion: @escaping (Error?) -> Void) {
        session.deleteUser(user) { error in
            if error != nil {
                guard let error = error else {return}
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    func getUserData(completion: @escaping (Result<CustomResponse?, Error>) -> Void) {
        self.session.fetchUserFirestoreData { (customResponse, error) in
            if error != nil {
                guard let error = error else { return }
                completion(.failure(error))
            } else {
                completion(.success(customResponse))
            }
        }
    }
    
    func fetchProjects(_ userData: CustomResponse?, completion: @escaping (Result<[Project?]?, Error>) -> Void) {
        self.session.fetchProjects(userData) { (projectList, error) in
            if error != nil {
                guard let error = error else { return }
                completion(.failure(error))
            } else {
                completion(.success(projectList))
            }
        }
    }
    
    func isUserLogin() -> Bool {
        return session.isCurrentUserLogin()
    }
}
