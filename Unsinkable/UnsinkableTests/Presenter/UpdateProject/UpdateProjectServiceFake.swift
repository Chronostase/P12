//
//  UpdateProjectServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 18/03/2022.
//
@testable import Unsinkable
import Foundation

class UpdateProjectServiceFake: ProjectService {
    var fakeUser:  FakeUserDetails?
    
    override func updateProject(_ project: Project?, _ userData: CustomResponse?, _ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        if userData?.user.userId == fakeUser?.userId {
            completion(nil)
        } else {
            completion(UnsinkableError.unknowError)
        }
    }
}
