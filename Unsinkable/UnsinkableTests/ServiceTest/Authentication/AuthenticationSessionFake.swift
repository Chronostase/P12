//
//  AuthenticationSessionFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 28/04/2021.
//
@testable import Unsinkable
import Firebase
import Foundation

class AuthenticationSessionFake: FirebaseAuthenticationSession {
    var fakeUser: FakeUserDetails
    
    init(fakeUser: FakeUserDetails) {
        self.fakeUser = fakeUser
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
        for stored in UserAuthenticationServiceTest.fakeStorage {
            if stored.user.userId == customResponse?.user.userId {
                completion(UnsinkableError.unknowError)
            } else {
                guard let customResponse = customResponse?.user else { return }
                let fakeResponse = FakeCustomResponse(user: FakeUserDetails(email: customResponse.email, password: nil, firstName: customResponse.firstName, name: customResponse.name, userId: customResponse.userId, projects: nil))
                UserAuthenticationServiceTest.fakeStorage.append(fakeResponse)
                completion(nil)
            }
        }
    }
    
    override func fetchUserFirestoreData(completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        
        for user in UserAuthenticationServiceTest.fakeStorage {
            if user.user.userId == fakeUser.userId {
                let fetchedUser = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: nil))
                completion(fetchedUser, nil)
            } else {
                completion(nil,UnsinkableError.unknowError)
            }
        }
    }
    
    override func fetchProjects(_ userData: CustomResponse?, completion: @escaping ([Project?]?, UnsinkableError?) -> Void) {
        
        let requestedID = userData?.user.userId
        var newStorage = [FakeProject]()
        for user in UserAuthenticationServiceTest.fakeStorage {
            guard let fakedUserID = user.user.userId else {return}
            if fakedUserID == requestedID {
                guard let fakedProjectList = user.user.projects else {return}
                for project in fakedProjectList {
                    guard let fakeProject = project else {return}
                    newStorage.append(fakeProject)
                }
            }
        }
        if newStorage.count > 0 {
            guard let projectList = userData?.user.projects else {return}
            completion(projectList, nil)
        } else {
            completion(nil, UnsinkableError.databaseCantFetchData)
        }
    }
    
    override func updateUser(_ user: UserDetails?, _ firstName: String, _ name: String, _ email: String, completion: @escaping (UnsinkableError?) -> Void) {
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test1@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyui", projects: nil)))
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test2@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyuiop", projects: nil)))
        
        guard let requestedID = user?.userId else {return}
        var index = 0
        for storedUser in UserAuthenticationServiceTest.fakeStorage {
            if index <= UserAuthenticationServiceTest.fakeStorage.count {
                if requestedID == storedUser.user.userId {
                    UserAuthenticationServiceTest.fakeStorage[index].user.email = fakeUser.email
                    return completion(nil)
                }
                index += 1
            }
        }
        return completion(UnsinkableError.databaseCantUpdate)
    }
    
    override func deleteUser(_ user: UserDetails, completion: @escaping (UnsinkableError?) -> Void) {
        var index = 0
        
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test1@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyui", projects: nil)))
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test2@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyuiop", projects: nil)))
        
        if fakeUser.userId == user.userId {
            for storedUser in UserAuthenticationServiceTest.fakeStorage {
                if user.userId == storedUser.user.userId {
                    UserAuthenticationServiceTest.fakeStorage.remove(at: index)
                    return completion(nil)
                }
                index += 1
            }
        }
        return completion(UnsinkableError.databaseCantDeleteUser)
    }
    
    override func logOutUser() -> Bool {
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        for storedUser in UserAuthenticationServiceTest.fakeStorage {
            if fakeUser.userId == storedUser.user.userId {
                fakeUser.userId = nil
            }
        }
        if fakeUser.userId == nil {
            return true
        } else {
            return false 
        }
    }
}
