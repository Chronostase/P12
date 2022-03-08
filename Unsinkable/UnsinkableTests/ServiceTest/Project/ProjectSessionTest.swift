//
//  ProjectSessionTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 02/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class ProjectSessionTest: XCTestCase {
    
    var projectSessionFake: ProjectSessionFake?
    var projectService: ProjectService?
    
    override func setUp() {
        super.setUp()
        setupData()
    }
    
    override func tearDown() {
        super.tearDown()
        resetData()
    }
    
    private func setupData() {
        projectSessionFake = ProjectSessionFake()
        projectSessionFake?.database.users = []
        projectService = ProjectService(session: projectSessionFake!)
    }
    
    private func resetData() {
        projectSessionFake = nil
        projectService = nil
    }
    
    func test() {
        guard let session = projectSessionFake, let projectService = projectService else {return}
        print("begin \(session.database.users?.count)")
        projectSessionFake?.database.users?.append(FakeCustomResponse(user: FakeUserDetails()))
        projectService.refreshCurrentProject(nil, nil) { Project, error in
            print("Final update \(session.database.users?.count)")
            XCTAssertEqual(self.projectSessionFake?.database.users?.count, 2)
        }
    }
}
