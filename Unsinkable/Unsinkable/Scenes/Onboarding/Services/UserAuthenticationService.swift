//
//  UserAuthentication.swift
//  Unsinkable
//
//  Created by Thomas on 21/01/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationLogic {
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String, callback: @escaping (Result<Void, UnsinkableError>) -> Void)
    
    func storeUser(_ customResponse: CustomResponse, firstName: String,_ name: String, callback: @escaping (Result<Void, UnsinkableError>) -> Void)
    
    func loginUser(_ email: String,_ password: String, callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void )
    
    func getUserData(completion: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void)
    
    func logOut() -> Bool
    
    func isUserLogin() -> Bool
    
    func fetchProjects(_ userData: CustomResponse?, completion: @escaping (Result<[Project?]?, UnsinkableError>) -> Void)
    
    func deleteUser(_ user: UserDetails, completion: @escaping (UnsinkableError?) -> Void)
    
    func updateUser(_ user: UserDetails?, _ firstName: String,_ name: String,_ email: String, completion: @escaping (UnsinkableError?) -> Void)
    
    
}

class UserAuthenticationService: AuthenticationLogic {
    
    let session: FirebaseAuthenticationSession
    
    init(session: FirebaseAuthenticationSession = FirebaseAuthenticationSession()) {
        self.session = session
    }
    
    //Call session to login user
    func loginUser(_ email: String, _ password: String, callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void ) {
        
        session.signInRequest(email, password) { (result, error) in
            if error != nil {
                guard let error = error else { return }
                callback(.failure(error))
            } else {
                callback(.success(result))
            }
        }
    }
    
    //Call session to create user and then store it
    func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String, callback: @escaping (Result<Void, UnsinkableError>) -> Void) {
        
        session.createUserRequest(email, password) { (result, error) in
            if error != nil {
                guard let error = error else { return }
                callback(.failure(error))
            } else {
                guard let customResponse = result else { return }
                self.storeUser(customResponse, firstName: firstName, name, callback: callback)
            }
        }
    }
    
    //Call session to store user
    func storeUser(_ customResponse: CustomResponse, firstName: String,_ name: String, callback: @escaping (Result<Void, UnsinkableError>) -> Void) {
        self.session.addUserToDataBase(customResponse: customResponse, firstName, name) { (error) in
            if error != nil {
                guard let error = error else { return }
                callback(.failure(error))
            } else {
                callback(.success(()))
            }
        }
    }
    
    //Call session to fetch user projects
    func fetchProjects(_ userData: CustomResponse?, completion: @escaping (Result<[Project?]?, UnsinkableError>) -> Void) {
        self.session.fetchProjects(userData) { (projectList, error) in
            if error != nil {
                guard let error = error else { return }
                completion(.failure(error))
            } else {
                completion(.success(projectList))
            }
        }
    }
    
    //Call session to fetchUser data
    func getUserData(completion: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void) {
        self.session.fetchUserFirestoreData { (customResponse, error) in
            if error != nil {
                guard let error = error else { return }
                completion(.failure(error))
            } else {
                completion(.success(customResponse))
            }
        }
    }

    //Call session to update User
    func updateUser(_ user: UserDetails?, _ firstName: String,_ name: String,_ email: String, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.updateUser(user, firstName, name, email) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //Call session to delete user
    func deleteUser(_ user: UserDetails, completion: @escaping (UnsinkableError?) -> Void) {
        session.deleteUser(user) { error in
            if error != nil {
                guard let error = error else {return}
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func logOut() -> Bool {
        return session.logOutUser()
    }
        
    func isUserLogin() -> Bool {
        return session.isCurrentUserLogin()
    }
}
