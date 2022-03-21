//
//  UpdateProjectPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 18/03/2022.
//
@testable import Unsinkable
import Foundation
import XCTest

class UpdateProjectPresenterTest: XCTestCase {
    var updateProjectPresenter: UpdateProjectPresenter?
    var updateProjectService: UpdateProjectServiceFake?
    var isCorrect: Bool?
    
    override func setUp() {
        super.setUp()
        initData()
    }
    
    override func tearDown() {
        super.tearDown()
        resetData()
    }
    
    private func initData() {
        updateProjectService = UpdateProjectServiceFake()
        updateProjectPresenter = UpdateProjectPresenter(session: updateProjectService!)
        isCorrect = Bool()
        updateProjectService?.fakeUser = FakeUserDetails(email: "thomas@gmail.com", password: nil, firstName: "thomas", name: "giron", userId: "AZERTY", projects: [])
        updateProjectPresenter?.userData = CustomResponse(user: UserDetails(email: "thomas@gmail.com", firstName: "thomas", name: "giron", userId: "AZERTY", projects: []))
        updateProjectPresenter?.delegate = self 
        updateProjectPresenter?.coverData = Data()
        updateProjectPresenter?.currentProject = Project(title: "Test", projectID: "azerty", description: "Basic test", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
    }
    
    private func resetData() {
        updateProjectService = nil
        updateProjectPresenter = nil
        isCorrect = nil
    }
    
    func testUpdateProjectShouldWorkIfCorrectID() {
        updateProjectPresenter?.updateProject()
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testUpdateProjectShouldFailedIfIncorrectID() {
        updateProjectService?.fakeUser?.userId = "wxcvbn"
        updateProjectPresenter?.updateProject()
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testUpdateLocalDataShouldFailedIfNoString() {
        guard let startProject = updateProjectPresenter?.currentProject else {return}
        XCTAssertEqual(startProject.title, "Test")
        updateProjectPresenter?.updateLocalData(nil, nil)
        guard let project = updateProjectPresenter?.currentProject else {return}
        XCTAssertEqual(project.title, "Test")
    }
    
    func testUpdateLocalDataShouldWorkIfData() {
        
        guard let startProject = updateProjectPresenter?.currentProject else {return}
        XCTAssertEqual(startProject.title, "Test")
        updateProjectPresenter?.updateLocalData("Another", "Interesting thing")
        guard let project = updateProjectPresenter?.currentProject else {return}
        XCTAssertEqual(project.title, "Another")
        XCTAssertEqual(project.description, "Interesting thing")
    }
}

extension UpdateProjectPresenterTest: ProjectManagerDelegate {
    func updateProjectComplete(_ result: Result<Project?, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
}
