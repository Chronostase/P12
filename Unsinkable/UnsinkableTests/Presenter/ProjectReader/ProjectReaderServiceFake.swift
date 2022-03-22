//
//  ProjectReaderServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 17/03/2022.
//
@testable import Unsinkable

import Foundation

class ProjectReaderServiceFake: ProjectService {
    var fakeUser:  FakeUserDetails?
    
    override func registerTask(_ tasks: [Task?]?, _ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        
        if project == nil {
            completion(UnsinkableError.unknowError)
        } else {
            completion(nil)
        }
    }
    
    override func deleteProject(_ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        if project == nil {
            completion(UnsinkableError.unknowError)
        } else {
            completion(nil)
        }
    }
    
    override func updateValidateStatement(_ project: Project?, selectedTask: Task?, _ userData: CustomResponse?, completion: @escaping (Result<Void?, UnsinkableError>) -> Void) {
        if userData?.user.userId == fakeUser?.userId {
            completion(.success(()))
        } else {
            completion(.failure(UnsinkableError.unknowError))
        }
    }
    
    override func refreshCurrentProject(_ project: Project?, _ userData: CustomResponse?, completion: @escaping (Project?, UnsinkableError?) -> Void) {
        if userData?.user.userId == fakeUser?.userId {
            completion(project, nil)
        } else {
            completion(nil, UnsinkableError.unknowError)
        }
    }
}
