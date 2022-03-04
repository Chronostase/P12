//
//  LoginServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 24/02/2022.
//
@testable import Unsinkable
import Foundation

class LoginServiceFake: UserAuthenticationService {
    
//    override func loginUser(_ email: String, _ password: String, callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void) {
//        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test@gmail.fr", password: "12345678", firstName: "Jean", name: "Duj", userId: "azerty", projects: nil)))
//        for user in UserAuthenticationServiceTest.fakeStorage {
//            if email == user.user.email && password == user.user.password {
//                let response = CustomResponse(user: UserDetails())
//                callback(.success(response))
//            } else {
//                callback(.failure(UnsinkableError.loginOperationNotAllowed))
//            }
//        }
//    }
    
//    override func loginUser(_ email: String, _ password: String, callback: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void) {
//        <#code#>
//    }
}
