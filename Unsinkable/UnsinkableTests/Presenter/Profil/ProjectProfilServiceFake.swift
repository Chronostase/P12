//
//  ProjectProfilServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 21/03/2022.
//
@testable import Unsinkable
import Foundation

class ProjectProfilServiceFake: ProjectService {
    
    var fakeUser:  FakeUserDetails?
    
    override func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        if fakeUser?.userId == user?.user.userId {
            completion(nil)
        } else {
            completion(UnsinkableError.unknowError)
        }
    }
}
