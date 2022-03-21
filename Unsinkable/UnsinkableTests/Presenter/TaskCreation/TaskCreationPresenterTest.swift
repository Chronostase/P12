//
//  TaskCreationPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 17/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class TaskCreationPresenterTest: XCTestCase {
    
    var taskCreationPresenter: TaskCreationPresenter?
    var taskCreationService: TaskCreationServiceFake?
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
        taskCreationService = TaskCreationServiceFake()
        taskCreationPresenter = TaskCreationPresenter(session: taskCreationService!)
        taskCreationPresenter?.delegate = self
        taskCreationPresenter?.task = Task(title: "CurrentTask", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: "something", location: "here", isValidate: false)
        taskCreationService?.fakeUser = FakeUserDetails()
        taskCreationPresenter?.project = Project(title: "Test", projectID: "azerty", description: "test", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "something", taskList: [taskCreationPresenter?.task])
        taskCreationPresenter?.userData = CustomResponse(user: UserDetails(email: "thomas@gmail.com", firstName: "thomas", name: "giron", userId: "AZERTY", projects: [taskCreationPresenter?.project]))
    }
    
    private func resetData() {
        isCorrect = nil
        taskCreationPresenter = nil
        taskCreationService = nil 
    }
    
    func testDeleteTaskShouldWorkIfCorrectData() {
        taskCreationPresenter?.deleteTask()
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testDeleteTaskShouldFailedIfNoData() {
        taskCreationPresenter?.task = nil
        taskCreationPresenter?.deleteTask()
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testUpdateTaskShouldWorkIfCorrectData() {
        taskCreationService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: nil)
        taskCreationPresenter?.updateTask(with: "", location: "", priority: true, commentary: "", deadLine: nil)
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testUpdateTaskShouldFailIfWrongUserID() {
        taskCreationService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTYUIOP", projects: nil)
        taskCreationPresenter?.updateTask(with: "", location: "", priority: true, commentary: "", deadLine: nil)
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testUpdateLocalTaskShouldWorkIfData() {
        taskCreationPresenter?.updateLocalTask(with: "", location: "", priority: true, commentary: "", deadLine: nil)
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testIsReaderShouldReturnFalseIfNotReader() {
        taskCreationPresenter?.isReader = false
        guard let value = taskCreationPresenter?.isTaskReader() else {return}
        XCTAssertFalse(value)
    }
    
    func testIsReaderShouldReturnTrueIfReader() {
        taskCreationPresenter?.isReader = true
        guard let value = taskCreationPresenter?.isTaskReader() else {return}
        XCTAssertTrue(value)
    }
    
    func testIsTaskReaderShouldReturnFalseIfIsReaderNil() {
        taskCreationPresenter?.isReader = nil
        guard let value = taskCreationPresenter?.isTaskReader() else {return}
        XCTAssertFalse(value)
    }
    func testIsDeadLineViewNeededShouldReturFalseIfIsNotReader() {
        taskCreationPresenter?.isReader = false
        guard let value = taskCreationPresenter?.isDeadLineViewNeeded() else {return}
        XCTAssertFalse(value)
    }
    func testIsDeadLineViewNeededShouldReturFalseIfNoDeadLine() {
        taskCreationPresenter?.isReader = true
        taskCreationPresenter?.task?.deadLine = nil
        guard let value = taskCreationPresenter?.isDeadLineViewNeeded() else {return}
        XCTAssertFalse(value)
    }
    func testIsDeadLineViewNeededShouldReturnTrueIfReader() {
        taskCreationPresenter?.isReader = true
        taskCreationPresenter?.task?.deadLine = Date()
        guard let value = taskCreationPresenter?.isDeadLineViewNeeded() else {return}
        XCTAssertTrue(value)
    }
    
    func testIsDeleteTaskNeededShouldReturnFalseIfWrongUser() {
        taskCreationPresenter?.project?.ownerUserId = "something"
        guard let value = taskCreationPresenter?.isDeleteTaskNeeded() else {return}
        XCTAssertFalse(value)
    }
    
    func testIsDeleteTaskNeededShouldReturnTrueIfGoodUser() {
        guard let value = taskCreationPresenter?.isDeleteTaskNeeded() else {return}
        XCTAssertTrue(value)
    }
}

extension TaskCreationPresenterTest: ProjectManagerDelegate {
    func deleteTaskComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func updateTaskComplete(_ result: Result<Task?, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false 
        }
    }
    
    func updateLocalTask(_ task: Task) {
        isCorrect = true
    }
}
