//
//  ProjectSessionFake.swift
//  UnsinkableTests
//
//  Created by Thomas on 02/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class ProjectSessionFake: ProjectSession {
    
//    lazy var projectSession = {
//        return ProjectSessionTest()
//    }()
    var fakeUser: FakeUserDetails!
    var database = FakeStorage(users: [])
    
    override func refreshCurrentProject(_ project: Project?, _ userData: CustomResponse?, completion: @escaping (Project?, UnsinkableError?) -> Void) {
        
        print("Enter In Session fake: \(database.users?.count)")
        database.users?.append(FakeCustomResponse(user: FakeUserDetails()))
        print("After update in session fake: \(database.users?.count)")
        completion(Project(title: "", projectID: "", description: "", ownerUserId: "", isPersonal: true, downloadUrl: "", taskList: nil), nil)
        
            print("Leave : \(database.users?.count)")
    }
}
