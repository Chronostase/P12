//
//  DashboardPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 15/03/2022.
//

import Foundation
@testable import Unsinkable
import XCTest

class DashboardPresenterTest: XCTestCase {
    var dashBoardPresenter: DashBoardPresenter?
    var dashBoardService: DashBoardServiceFake?
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
        isCorrect = Bool()
        dashBoardService = DashBoardServiceFake()
        dashBoardPresenter = DashBoardPresenter(session: dashBoardService!)
        dashBoardService?.fakeUser = FakeUserDetails()
        dashBoardPresenter?.delegate = self
    }
    
    private func resetData() {
        dashBoardService = nil
        dashBoardPresenter = nil
        isCorrect = nil 
    }
    
    func testFetchUserDataShouldWorkIfConnected() {
        dashBoardService?.isConnected = true
        dashBoardPresenter?.fetchUser()
        XCTAssertEqual(isCorrect, true)
    }
    
    func testFetchUserDataShouldFailIfNotConnectec() {
        dashBoardService?.isConnected = false
        dashBoardPresenter?.fetchUser()
        XCTAssertEqual(isCorrect, false)
    }
    
    func testGetUserDataIfUserIsConnected() {
        dashBoardService?.isConnected = true
        dashBoardPresenter?.getUserData(completion: { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testGetUserDataShouldFailIfUserNotConnected() {
        dashBoardService?.isConnected = false
        dashBoardPresenter?.getUserData(completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(let response):
                XCTAssertNil(response)
            }
        })
    }
    
    func testFetchProjectShouldWorkIfCorrectUserId() {
        dashBoardService?.fakeUser = FakeUserDetails(email: nil, password: nil, firstName: nil, name: nil, userId: "AZERTY", projects: [])
        dashBoardPresenter?.getProjectList()
        XCTAssertEqual(isCorrect, true)
    }
    
    func testFetchProjectShouldFailIfIncorrectUserId() {
        dashBoardService?.fakeUser = FakeUserDetails(email: nil, password: nil, firstName: nil, name: nil, userId: "AZERTYUIOP", projects: [])
        dashBoardPresenter?.getProjectList()
        XCTAssertEqual(isCorrect, false)
    }
    
    func testsortProjectListShouldFailedIfProjectListNil() {
        dashBoardPresenter?.sortPersonalAndProfessionalProject(nil)
        XCTAssertNil(dashBoardPresenter?.personalProject)
        XCTAssertNil(dashBoardPresenter?.professionalProject)
    }
    
    func testSortProjectShouldWorkIfCorrectProjectList() {
        XCTAssertNil(dashBoardPresenter?.personalProject)
        XCTAssertNil(dashBoardPresenter?.professionalProject)
        let project = Project(title: "test", projectID: "azerty", description: nil, ownerUserId: nil, isPersonal: true, downloadUrl: nil, taskList: nil)
        let project1 = Project(title: "test", projectID: "azerty", description: nil, ownerUserId: nil, isPersonal: true, downloadUrl: nil, taskList: nil)
        let project2 = Project(title: "test", projectID: "azerty", description: nil, ownerUserId: nil, isPersonal: false, downloadUrl: nil, taskList: nil)
        let projectList = [project, project1, project2]
        dashBoardPresenter?.sortPersonalAndProfessionalProject(projectList)
        XCTAssertEqual(dashBoardPresenter?.personalProject?.count, 2)
        XCTAssertEqual(dashBoardPresenter?.professionalProject?.count, 1)
    }
    
    func testIsSearchBarActiveShouldFalseIfNoText() {
        guard let value = dashBoardPresenter?.isSearchBarActive(nil) else {return}
        XCTAssertFalse(value)
    }
    
    func testIsSearchBarActiveShouldBeTrueIfText() {
        guard let value = dashBoardPresenter?.isSearchBarActive("something") else {return}
        XCTAssertTrue(value)
    }
    
    func testGetCurrentDateReturnTrueIfDate() {
        dashBoardPresenter?.getCurrentDate()
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
}




extension DashboardPresenterTest: DashBoardPresenterDelegate {
    func fetchDateSucceed(_ date: String) {
        isCorrect = true
    }
    
    func fetchUserDataComplete(_ result: Result<CustomResponse?, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func fetchProjectComplete(_ result: Result<CustomResponse?, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    
}
