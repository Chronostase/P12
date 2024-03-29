//
//  RegisterServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 02/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class RegisterServiceFake: UserAuthenticationService {
    
    var database = FakeStorage(users: [])
    
    override func createUserWithInformations(_ firstName: String, _ name: String, _ email: String, _ password: String, callback: @escaping (Result<Void, UnsinkableError>) -> Void) {
        guard let usersArray = database.users else {return}
        for user in usersArray {
            if user.user.email == email {
                callback(.failure(UnsinkableError.registerInvalidEmail))
            } else {
                let newUser = FakeCustomResponse(user: FakeUserDetails(email: email, password: password, firstName: firstName, name: name, userId: "azertyuiop", projects: nil))
                database.users?.append(newUser)
                callback(.success(()))
            }
        }
    }
}
