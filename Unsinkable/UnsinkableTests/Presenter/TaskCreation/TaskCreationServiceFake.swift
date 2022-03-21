//
//  TaskCreationServiceFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 17/03/2022.
//

@testable import Unsinkable
import Foundation

class TaskCreationServiceFake: ProjectService {
    var fakeUser:  FakeUserDetails?
    
    override func deleteTask(_ project: Project?, _ task: Task?, completion: @escaping (UnsinkableError?) -> Void) {
        if task != nil {
            completion(nil)
        } else {
            completion(UnsinkableError.unknowError)
        }
    }
    
    override func updateTask(_ project: Project?, currentTask: Task?, newTask: Task?, _ userData: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        if userData?.user.userId == fakeUser?.userId {
            completion(nil)
        } else {
            completion(UnsinkableError.unknowError)
        }
    }
}
