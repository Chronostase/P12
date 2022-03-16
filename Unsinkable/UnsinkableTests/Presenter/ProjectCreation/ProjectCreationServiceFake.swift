//
//  ProjectCreationServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 16/03/2022.
//
@testable import Unsinkable
import Foundation

class ProjectCreationServiceFake: ProjectService {
    var database = FakeStorage(users: [])
    var fakeUser:  FakeUserDetails?
    var isConnected = false
    
    override func registerProject(_ project: Project?, _ userData: CustomResponse?, _ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        let user = database.users?[0].user
        if fakeUser?.userId == user?.userId {
            completion(nil)
        } else {
            completion(UnsinkableError.unknowError)
        }
    }
    
    override func registerTask(_ tasks: [Task?]?, _ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        if project == nil {
            completion(UnsinkableError.unknowError)
        } else {
            completion(nil)
        }
    }
}
