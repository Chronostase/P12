//
//  ProjectCreationPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 16/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class ProjectCreationPresenterTest: XCTestCase {
    var projectCreationPresenter: ProjectCreationPresenter?
    var projectCreationService: ProjectCreationServiceFake?
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
        projectCreationService = ProjectCreationServiceFake()
        projectCreationPresenter = ProjectCreationPresenter(session: projectCreationService!)
        projectCreationService?.fakeUser = FakeUserDetails()
        projectCreationPresenter?.delegate = self
        projectCreationPresenter?.data = CustomResponse(user: UserDetails(email: "thomas.giron@gmail.com", firstName: "thomas", name: "giron", userId: "AZERTY", projects: []))
        isCorrect = Bool()
        
    }
    
    private func resetData() {
        projectCreationPresenter = nil
        projectCreationService = nil
        isCorrect = nil 
    }
    
    func testSaveProjectWorkIfCorrectUserID() {
        let fakeUserData = FakeCustomResponse(user: FakeUserDetails(email: nil, password: nil, firstName: nil, name: nil, userId: "AZERTY", projects: []))
        projectCreationService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        projectCreationService?.database.users?.append(fakeUserData)
        projectCreationPresenter?.saveProject("test", "something", nil)
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
        
    }
    
    func testSaveProjectFailIfIncorrectUserID() {
        let fakeUserData = FakeCustomResponse(user: FakeUserDetails(email: nil, password: nil, firstName: nil, name: nil, userId: "AZERTYUIII", projects: []))
        projectCreationService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        projectCreationService?.database.users?.append(fakeUserData)
        projectCreationPresenter?.saveProject("test", "something", nil)
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testRegisterShouldSucceedIfCorrectData() {
        let fakeUserData = FakeCustomResponse(user: FakeUserDetails(email: nil, password: nil, firstName: nil, name: nil, userId: "AZERTY", projects: []))
        projectCreationService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        projectCreationService?.database.users?.append(fakeUserData)
        projectCreationPresenter?.registerProject("TestSomething", "probably", nil, completion: { result in
            switch result {
            case .success(let project):
                XCTAssertNotNil(project)
            case .failure(let error):
                XCTAssertNil(error)
            }
        })
    }
    
    func testRegisterShouldFailedIfIncorrectTitle() {
        let fakeUserData = FakeCustomResponse(user: FakeUserDetails(email: nil, password: nil, firstName: nil, name: nil, userId: "AZERTY", projects: []))
        projectCreationService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        projectCreationService?.database.users?.append(fakeUserData)
        projectCreationPresenter?.registerProject("", "", nil, completion: { result in
            switch result {
            case .success(let project):
                XCTAssertNil(project)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testRegisterProjectFailIfNoData() {
        let fakeUserData = FakeCustomResponse(user: FakeUserDetails(email: nil, password: nil, firstName: nil, name: nil, userId: "AZERTYUIII", projects: []))
        projectCreationPresenter?.data = nil 
        projectCreationService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        projectCreationService?.database.users?.append(fakeUserData)
        projectCreationPresenter?.registerProject("test", "", nil, completion: { result in
            switch result {
            case .success(let project):
                XCTAssertNotNil(project)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testRegisterTaskShouldWorkIfCorrectData() {
        let project = Project(title: "Test", projectID: "zrgqer", description: "", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "", taskList: [])
        projectCreationPresenter?.registerTask(project)
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testRegisterTaskShouldFailIfNoProject() {
        projectCreationPresenter?.registerTask(nil)
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testCheckTextFieldAvailableShouldReturnTrueIfCorrectFields() {
        guard let value = projectCreationPresenter?.checkTextFieldsAvailable("Something", "good") else {return}
        XCTAssertEqual(true, value)
    }
    
    func testCheckTextFieldAvailableShouldReturnFalseIfIncorrectFields() {
        guard let value = projectCreationPresenter?.checkTextFieldsAvailable("", "") else {return}
        XCTAssertEqual(false, value)
    }
    
    func testCheckTaskTitleShouldReturnFalseIfBadTitle() {
        guard let value = projectCreationPresenter?.checkTaskTitle("") else {return}
        XCTAssertEqual(value, false)
    }
    
    func testCheckTaskTitleShouldReturnTrueIfCorrectTitle() {
        guard let value = projectCreationPresenter?.checkTaskTitle("clearing") else {return}
        XCTAssertEqual(value, true)
    }
    
    func testIsFieldFillShouldReturnFalseIfIncorrectField() {
        guard let value = projectCreationPresenter?.isFieldFill("") else {return}
        XCTAssertEqual(false , value)
    }
    
    func testIsFieldFillShouldReturnFalseIfNilField() {
        guard let value = projectCreationPresenter?.isFieldFill(nil) else {return}
        XCTAssertEqual(false , value)
    }
    
    func testIsFieldFillShouldReturnTrueIfCorrectField() {
        guard let value = projectCreationPresenter?.isFieldFill("something") else {return}
        XCTAssertEqual(true , value)
    }
    
    func testUpdateProjectShouldWorkIfCorrectTitle() {
        guard let taskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertTrue(taskList.isEmpty)
        projectCreationPresenter?.updateProject("something")
        guard let updatedTaskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertEqual(1, updatedTaskList.count)
    }
    
    func testUpdateProjectShouldFailedIfIncorrectTitle() {
        guard let taskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertTrue(taskList.isEmpty)
        projectCreationPresenter?.updateProject(nil)
        guard let updatedTaskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertEqual(0, updatedTaskList.count)
    }
    
    func testUpdateLocalDataShouldWorkIfCorrectData() {
        guard let userProjects = projectCreationPresenter?.data?.user.projects else {return}
        XCTAssertTrue(userProjects.isEmpty)
        let project = Project(title: "Test", projectID: "zrgqer", description: "", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "", taskList: [])
        projectCreationPresenter?.updateLocalData(withProject: project)
        //Data.project.append project
        guard let updatedUserProjects = projectCreationPresenter?.data?.user.projects else {return}
        XCTAssertEqual(1, updatedUserProjects.count)
        
    }
    
    func testUpdateLocalDataShouldFailIfIncorrectData() {
        guard let userProjects = projectCreationPresenter?.data?.user.projects else {return}
        XCTAssertTrue(userProjects.isEmpty)
        projectCreationPresenter?.updateLocalData(withProject: nil)
        //Data.project.append project
        guard let updatedUserProjects = projectCreationPresenter?.data?.user.projects else {return}
        XCTAssertEqual(0, updatedUserProjects.count)
    }
    
    func testUpdateLocalTaskListShouldWorkIfCorrectData() {
        guard let localTaskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertTrue(localTaskList.isEmpty)
        let task = Task(title: "", projectID: "", taskID: "", priority: true, deadLine: nil, commentary: "", location: "", isValidate: false )
        projectCreationPresenter?.updateLocalTaskData(withTask: task)
        
        guard let updatedTaskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertEqual(1, updatedTaskList.count)
    }
    
    func testUpdateLocalTaskListShouldFailIfIncorrectData() {
        guard let localTaskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertTrue(localTaskList.isEmpty)
        projectCreationPresenter?.updateLocalTaskData(withTask: nil)
        
        guard let updatedTaskList = projectCreationPresenter?.localTasksList else {return}
        XCTAssertEqual(0, updatedTaskList.count)
    }

}

extension ProjectCreationPresenterTest: ProjectManagerDelegate {
    func registerProjectComplete(_ result: Result<Project?, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func registerTaskComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
}
