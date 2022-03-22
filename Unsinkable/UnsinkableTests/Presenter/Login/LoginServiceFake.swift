//
//  LoginServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 24/02/2022.
//
@testable import Unsinkable
import Foundation

class LoginServiceFake: UserAuthenticationService {
    
    var database = FakeStorage(users: [])
    
    override func loginUser(_ email: String, _ password: String, callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void) {
        database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test@gmail.fr", password: "12345678", firstName: "Jean", name: "Duj", userId: "azerty", projects: nil)))
        
        guard let usersArray = database.users else {return}
        for user in usersArray {
            if email == user.user.email && password == user.user.password {
                let response = CustomResponse(user: UserDetails())
                callback(.success(response))
            } else {
                callback(.failure(UnsinkableError.loginOperationNotAllowed))
            }
        }
    }
}
