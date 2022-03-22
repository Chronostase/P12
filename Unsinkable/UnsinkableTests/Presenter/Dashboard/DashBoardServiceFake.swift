//
//  DashBoardServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 15/03/2022.
//

import Foundation
import XCTest
@testable import Unsinkable

class DashBoardServiceFake: UserAuthenticationService {
    var database = FakeStorage(users: [])
    var fakeUser:  FakeUserDetails? 
    var isConnected = false
    
    override func getUserData(completion: @escaping (Result<CustomResponse?, UnsinkableError>) -> Void) {
        
        if isConnected == true {
            let response = CustomResponse(user: UserDetails())
            completion(.success(response))
        } else {
            completion(.failure(UnsinkableError.unknowError))
        }
    }
    
    override func fetchProjects(_ userData: CustomResponse?, completion: @escaping (Result<[Project?]?, UnsinkableError>) -> Void) {
        let user = FakeUserDetails(email: "", password: "", firstName: "test", name: nil, userId: "AZERTY", projects: [])
        let response = FakeCustomResponse(user: user)
        database.users?.append(response)
        if fakeUser?.userId == database.users?[0].user.userId {
            completion(.success([]))
        } else {
            completion(.failure(UnsinkableError.unknowError))
        }
    }
}
