//
//  AuthProfilServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 21/03/2022.
//
@testable import Unsinkable
import Foundation

class AuthProfilServiceFake: UserAuthenticationService {
    var fakeUser:  FakeUserDetails?
    
    override func logOut() -> Bool {
        if fakeUser != nil {
            return true
        } else {
            return false
        }
    }
    override func deleteUser(_ user: UserDetails, completion: @escaping (UnsinkableError?) -> Void) {
        if fakeUser?.userId == user.userId {
            completion(nil)
        } else {
            completion(UnsinkableError.unknowError)
        }
    }

    override func updateUser(_ user: UserDetails?, _ firstName: String, _ name: String, _ email: String, completion: @escaping (UnsinkableError?) -> Void) {
        if fakeUser?.userId == user?.userId {
            completion(nil)
        } else {
            completion(UnsinkableError.unknowError)
        }
    }
}
