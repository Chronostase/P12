////
////  AuthenticationSessionFake.swift
////  UnsinkableTests
////
////  Created by Thomas on 28/04/2021.
////
//@testable import Unsinkable
//import Firebase
//import Foundation
//
//class ServiceError: Error {
//    
//}
//
//class AuthenticationSessionFake: AuthenticationSession {
//    let fakeUser: FakeUserDetails
//    var fakeStorage: [FakeCustomResponse]
//    
//    init(fakeUser: FakeUserDetails, fakeStorage: [FakeCustomResponse] ) {
//        self.fakeUser = fakeUser
//        self.fakeStorage = fakeStorage
//    }
//    override func signInRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
//        let customResponse = FakeCustomResponse(user: FakeUserDetails(email: fakeUser.email, password: fakeUser.password))
//        if email == customResponse.user.email && password == customResponse.user.password {
//            completion(customResponse, nil)
//        } else {
//            let error = ServiceError()
//            completion(nil, error)
//        }
//    }
//    
//    override func createUserRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
//        let customResponse = CustomResponse(user: UserDetails(email: fakeUser.email, password: fakeUser.password))
//        if email == customResponse.user.email {
//            let error = ServiceError()
//            completion(nil, error)
//        } else {
//            completion(customResponse, nil)
//        }
//    }
//    
//    override func addUserToDataBase(customResponse: CustomResponse?, _ firstName: String, _ name: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
//        for stored in fakeStorage {
//            if stored.user.userId == customResponse?.user.userId {
//                let error = ServiceError()
//                completion(nil,error)
//            } else {
//                guard let customResponse = customResponse else { return }
//                fakeStorage.append(customResponse)
//                completion(customResponse, nil)
//            }
//        }
//    }
//}
