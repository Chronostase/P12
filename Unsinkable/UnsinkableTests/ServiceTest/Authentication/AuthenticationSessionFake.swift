//
//  AuthenticationSessionFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 28/04/2021.
//
@testable import Unsinkable
import Firebase
import Foundation

class AuthenticationSessionFake: AuthenticationSession {
    let fakeUser: FakeUserDetails
    var fakeStorage: [FakeCustomResponse]
    
    init(fakeUser: FakeUserDetails, fakeStorage: [FakeCustomResponse] ) {
        self.fakeUser = fakeUser
        self.fakeStorage = fakeStorage
    }
    
    override func signInRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        let fakeCustomResponse = FakeCustomResponse(user: FakeUserDetails(email: fakeUser.email, password: fakeUser.password))
        if email == fakeCustomResponse.user.email && password == fakeCustomResponse.user.password {
            completion(CustomResponse(user: UserDetails()), nil)
        } else {
            let error = UnsinkableError.unknowError
            completion(nil, error)
        }
    }
    
    override func createUserRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        let customResponse = FakeCustomResponse(user: FakeUserDetails(email: fakeUser.email, password: fakeUser.password))
        if email == customResponse.user.email {
            completion(nil, UnsinkableError.unknowError)
        } else {
            completion(CustomResponse(user: UserDetails()), nil)
        }
    }
    
    
    override func addUserToDataBase(customResponse: CustomResponse?, _ firstName: String, _ name: String, completion: @escaping (UnsinkableError?) -> Void) {
        for stored in fakeStorage {
            if stored.user.userId == customResponse?.user.userId {
                completion(UnsinkableError.unknowError)
            } else {
                guard let customResponse = customResponse?.user else { return }
                let fakeResponse = FakeCustomResponse(user: FakeUserDetails(email: customResponse.email, password: nil, firstName: customResponse.firstName, name: customResponse.name, userId: customResponse.userId, projects: nil))
                fakeStorage.append(fakeResponse)
                completion(nil)
            }
        }
    }
    
    override func fetchUserFirestoreData(completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        
        for user in fakeStorage {
            if user.user.userId == fakeUser.userId {
                let fetchedUser = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: nil))
                completion(fetchedUser, nil)
            } else {
                completion(nil,UnsinkableError.unknowError)
            }
        }
    }
    
    override func fetchProjects(_ userData: CustomResponse?, completion: @escaping ([Project?]?, UnsinkableError?) -> Void) {
        
        if let fakeProjectsList = fakeUser.projects {
            if fakeProjectsList.count > 0 {
                guard let projectList = userData?.user.projects else {return}
                completion(projectList,nil)
            } else {
                completion(nil, UnsinkableError.databaseCantFetchData)
            }
        } else {
            completion(nil,UnsinkableError.databaseCantFetchData)
        }
    }
    
}
