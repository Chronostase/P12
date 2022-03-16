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
    var fakeUser: FakeUserDetails?
    var database = FakeStorage(users: [])
    
    override func signInRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        let fakeCustomResponse = FakeCustomResponse(user: FakeUserDetails(email: fakeUser?.email, password: fakeUser?.password))
        if email == fakeCustomResponse.user.email && password == fakeCustomResponse.user.password {
            completion(CustomResponse(user: UserDetails()), nil)
        } else {
            let error = UnsinkableError.unknowError
            completion(nil, error)
        }
    }
    
    override func createUserRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        let customResponse = FakeCustomResponse(user: FakeUserDetails(email: fakeUser?.email, password: fakeUser?.password))
        if email == customResponse.user.email {
            completion(nil, UnsinkableError.unknowError)
        } else {
            completion(CustomResponse(user: UserDetails()), nil)
        }
    }
    
    
    override func addUserToDataBase(customResponse: CustomResponse?, _ firstName: String, _ name: String, completion: @escaping (UnsinkableError?) -> Void) {
        guard let usersArray = database.users else {return}
        for stored in usersArray {
            if stored.user.userId == customResponse?.user.userId {
                completion(UnsinkableError.unknowError)
            } else {
                guard let customResponse = customResponse?.user else { return }
                let fakeResponse = FakeCustomResponse(user: FakeUserDetails(email: customResponse.email, password: nil, firstName: customResponse.firstName, name: customResponse.name, userId: customResponse.userId, projects: nil))
                database.users?.append(fakeResponse)
                completion(nil)
            }
        }
    }
    
    override func fetchUserFirestoreData(completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        
        guard let usersArray = database.users else {return}
        for user in usersArray {
            if user.user.userId == fakeUser?.userId {
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
        guard let usersArray = database.users else {return}
        for user in usersArray {
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
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test1@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyui", projects: nil)))
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test2@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyuiop", projects: nil)))
        
        guard let requestedID = user?.userId else {return}
        var index = 0
        guard let usersArray = database.users else {return}
        for storedUser in usersArray {
            if index <= usersArray.count {
                if requestedID == storedUser.user.userId {
                    database.users?[index].user.email = fakeUser?.email
                    return completion(nil)
                }
                index += 1
            }
        }
        return completion(UnsinkableError.databaseCantUpdate)
    }
    
    override func deleteUser(_ user: UserDetails, completion: @escaping (UnsinkableError?) -> Void) {
        var index = 0
        
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test1@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyui", projects: nil)))
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test2@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyuiop", projects: nil)))
        
        guard let userArray = database.users else {return}
        if fakeUser?.userId == user.userId {
            for storedUser in userArray {
                if user.userId == storedUser.user.userId {
                    database.users?.remove(at: index)
                    return completion(nil)
                }
                index += 1
            }
        }
        return completion(UnsinkableError.databaseCantDeleteUser)
    }
    
    override func logOutUser() -> Bool {
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)))
        guard let usersArray = database.users else {return false}
        for storedUser in usersArray {
            if fakeUser?.userId == storedUser.user.userId {
                fakeUser?.userId = nil
            }
        }
        if fakeUser?.userId == nil {
            return true
        } else {
            return false 
        }
    }
}
