//
//  ProjectReaderPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 17/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class ProjectReaderPresenterTest: XCTestCase {
    
    var projectReaderPresenter: ProjectReaderPresenter?
    var projectReaderService: ProjectReaderServiceFake?
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
        projectReaderService = ProjectReaderServiceFake()
        projectReaderPresenter = ProjectReaderPresenter(session: projectReaderService!)
        projectReaderPresenter?.delegate = self
        projectReaderPresenter?.selectedProject = Project(title: "Test", projectID: "azerty", description: "test", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "something", taskList: [])
        projectReaderPresenter?.userData = CustomResponse(user: UserDetails(email: "thomas@gmail.com", firstName: "thomas", name: "giron", userId: "AZERTY", projects: [projectReaderPresenter?.selectedProject]))
    }
    
    private func resetData() {
        projectReaderService = nil
        projectReaderPresenter = nil
        isCorrect = nil
    }
    
    func testAddNewTaskShouldWorkIfCorrectTitle() {
        projectReaderPresenter?.addNewTask("Something")
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testAddNewTaskShouldFailIfSelectedProject() {
        projectReaderPresenter?.selectedProject = nil
        projectReaderPresenter?.addNewTask(nil)
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testDeleteProjectShouldFailedIfNoSelectedProject() {
        projectReaderPresenter?.selectedProject = nil
        projectReaderPresenter?.deleteProject()
        
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testDeleteProjectShouldWorkIfSelectedProject() {
        projectReaderPresenter?.deleteProject()
        
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testUpdateValidateStatementShouldWorkIfCorrectID() {
        projectReaderService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        let task = Task(title: "", projectID: "", taskID: "", priority: true, deadLine: nil, commentary: "", location: "", isValidate: true)
        projectReaderPresenter?.updateTask(task)
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testUpdateValudateStatementShouldFailIfWrongUser() {
        projectReaderService?.fakeUser = FakeUserDetails()
        let task = Task(title: "", projectID: "", taskID: "", priority: true, deadLine: nil, commentary: "", location: "", isValidate: true)
        projectReaderPresenter?.updateTask(task)
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testRefreshCurrentProjectShouldWorkIfCorrectUser() {
        projectReaderService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        projectReaderPresenter?.refreshCurrentProject()
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testRefreshCurrentProjectShouldFailIfIncorrectUser() {
        projectReaderService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTYUIOP", projects: [])
        projectReaderPresenter?.refreshCurrentProject()
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testCheckIfTitleIsNilShouldReturnFalseIfProjectTitle() {
        guard let value = projectReaderPresenter?.checkIfTitleIsNil() else {
            return
        }
        XCTAssertFalse(value)
    }
    
    func testCheckIfTitleIsNilShouldReturnTrueIfNoTitle() {
        projectReaderPresenter?.selectedProject?.title = nil
        guard let value = projectReaderPresenter?.checkIfTitleIsNil() else {
            return
        }
        XCTAssertTrue(value)
    }
    
    func testCheckIfCoverPictureShouldReturnFalseIfdownloadUrl() {
        guard let value = projectReaderPresenter?.checkIfCoverPicture() else {
            return
        }
        XCTAssertTrue(value)
    }
    
    func testCheckIfCoverPictureShouldReturnFalseIfNodownloadUrl() {
        projectReaderPresenter?.selectedProject?.downloadUrl = nil
        guard let value = projectReaderPresenter?.checkIfCoverPicture() else {
            return
        }
        XCTAssertFalse(value)
    }
    
    func testCheckIfDescriptionIsEmptyShouldReturnFalseIfDescription() {
        guard let value = projectReaderPresenter?.checkIfDescriptionIsEmpty() else {
            return
        }
        XCTAssertFalse(value)
    }
    
    func testCheckIfDescriptionIsEmptyShouldReturnTrueIfNoDescription() {
        projectReaderPresenter?.selectedProject?.description = nil
        guard let value = projectReaderPresenter?.checkIfDescriptionIsEmpty() else {
            return
        }
        XCTAssertTrue(value)
    }
    
    func testCheckIfTaskListIsEmptyShouldReturnFalseIfNoEmpty() {
        projectReaderPresenter?.selectedProject?.taskList = [Task(),Task()]
        guard let value = projectReaderPresenter?.checkIfTaskListIsEmpty() else {return}
        XCTAssertFalse(value)
    }
    
    func testCheckIfTaskListIsEmptyShoulReturnTrueIfEmpty() {
        projectReaderPresenter?.selectedProject?.taskList = []
        guard let value = projectReaderPresenter?.checkIfTaskListIsEmpty() else {return}
        XCTAssertTrue(value)
    }
    
    func testCheckIfTaskListIsEmptyShouldReturnTrueIfNil() {
        projectReaderPresenter?.selectedProject?.taskList = nil
        guard let value = projectReaderPresenter?.checkIfTaskListIsEmpty() else {return}
        XCTAssertTrue(value)
    }
    
    func testValidateTaskShouldChangeIsValidateToTrueIfIsValidateEqualFalse() {
        let task = Task(title: "test", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
        XCTAssertEqual(task.isValidate, false)
        projectReaderPresenter?.selectedProject?.taskList?.append(task)
        projectReaderPresenter?.validateTask(task)
        guard let value = projectReaderPresenter?.selectedProject?.taskList?[0]?.isValidate else {return}
        XCTAssertTrue(value)
    }
    
    func testValidateTaskShouldChangeIsValidateToFalseIfIsValidateEqualTrue() {
        let task = Task(title: "test", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        XCTAssertEqual(task.isValidate, true)
        projectReaderPresenter?.selectedProject?.taskList?.append(task)
        projectReaderPresenter?.validateTask(task)
        guard let value = projectReaderPresenter?.selectedProject?.taskList?[0]?.isValidate else {return}
        XCTAssertFalse(value)
    }
    
    func testValidateTaskShouldNotChangeIsValidateIfNoTaskList() {
        let task = Task(title: "test", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
        XCTAssertEqual(task.isValidate, false)
        projectReaderPresenter?.selectedProject?.taskList = nil
        projectReaderPresenter?.validateTask(task)
        projectReaderPresenter?.selectedProject?.taskList = [task]
        guard let value = projectReaderPresenter?.selectedProject?.taskList?[0]?.isValidate else {return}
        XCTAssertEqual(value, task.isValidate)
    }
    
    func testUnvalidateTaskShouldChangeFalseToTrue() {
        let task = Task(title: "test", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
        XCTAssertEqual(task.isValidate, false)
        projectReaderPresenter?.selectedProject?.taskList = [task]
        projectReaderPresenter?.unvalidateTask(task)
        guard let value = projectReaderPresenter?.selectedProject?.taskList?[0]?.isValidate else {return}
        XCTAssertTrue(value)
    }
    
    func testUnvalidateTaskShouldChangeTrueToFalse() {
        let task = Task(title: "test", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        XCTAssertEqual(task.isValidate, true)
        projectReaderPresenter?.selectedProject?.taskList = [task]
        projectReaderPresenter?.unvalidateTask(task)
        guard let value = projectReaderPresenter?.selectedProject?.taskList?[0]?.isValidate else {return}
        XCTAssertFalse(value)
    }
    
    func testUnvalidateTaskShouldFailIfNoTsk() {
        let task = Task(title: "test", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
        XCTAssertEqual(task.isValidate, false)
        projectReaderPresenter?.selectedProject?.taskList = [task]
        projectReaderPresenter?.unvalidateTask(nil)
        guard let value = projectReaderPresenter?.selectedProject?.taskList?[0]?.isValidate else {return}
        XCTAssertFalse(value)
    }
    
    func testCreatTaskObjectShouldReturnTask() {
        guard let task = projectReaderPresenter?.createTaskObject("created", nil, nil, nil, nil, nil) else {return}
        XCTAssertEqual("created", task.title)
    }
    
    func testCheckTaskTitleShouldReturnTrueIfTaskTitleIsntEmpty() {
        guard let value = projectReaderPresenter?.checkTaskTitle("Something") else {return}
        XCTAssertTrue(value)
    }
    
    func testCheckTaskTitleShouldReturnFalseIfEmpty() {
        guard let value = projectReaderPresenter?.checkTaskTitle("") else {return}
        XCTAssertFalse(value)
    }
    
    func testRemoveTaskFromLocalDataShouldWorkIfCorrectData() {
        let task1 = Task(title: "Menage", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: "Something great", location: "here", isValidate: true)
        let task2 = Task(title: "Rangement", projectID: "azerty", taskID: "Totka", priority: true, deadLine: nil, commentary: "HereRightNext", location: "here", isValidate: false)
        projectReaderPresenter?.selectedProject?.taskList = [task1, task2]
        guard let unUpdatedTaskList = projectReaderPresenter?.selectedProject?.taskList else {return}
        XCTAssertEqual(unUpdatedTaskList.count, 2)
        
        projectReaderPresenter?.removeTaskFromLocalData(task1)
        guard let updatedTaskList = projectReaderPresenter?.selectedProject?.taskList else {return}
        XCTAssertEqual(updatedTaskList.count, 1)
    }
    
    func testRemoveTaskFromLocalDataShouldRemoveNothingIfNoTask() {
        let task1 = Task(title: "Menage", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: "Something great", location: "here", isValidate: true)
        let task2 = Task(title: "Rangement", projectID: "azerty", taskID: "Totka", priority: true, deadLine: nil, commentary: "HereRightNext", location: "here", isValidate: false)
        projectReaderPresenter?.selectedProject?.taskList = [task1, task2]
        guard let unUpdatedTaskList = projectReaderPresenter?.selectedProject?.taskList else {return}
        XCTAssertEqual(unUpdatedTaskList.count, 2)
        
        projectReaderPresenter?.removeTaskFromLocalData(nil)
        guard let updatedTaskList = projectReaderPresenter?.selectedProject?.taskList else {return}
        XCTAssertEqual(updatedTaskList.count, 2)
    }
    
    func testRemoveTaskFromLocalDataShouldRemoveNothingIfNoTaskList() {
        let task1 = Task(title: "Menage", projectID: "azerty", taskID: "azertyuiop", priority: true, deadLine: nil, commentary: "Something great", location: "here", isValidate: true)
        projectReaderPresenter?.selectedProject?.taskList = nil
        projectReaderPresenter?.removeTaskFromLocalData(task1)
        let taskList = projectReaderPresenter?.selectedProject?.taskList
        XCTAssertNil(taskList)
        
    }
//
//    func removeTaskFromLocalData(_ task: Task?) {
//        var index = 0
//        guard let task = task else {return}
//        guard let taskList = self.selectedProject?.taskList else {return}
//        for taskToDelete in taskList {
//            if taskToDelete?.taskID == task.taskID {
//                self.selectedProject?.taskList?.remove(at: index)
//            }
//            index += 1
//        }
//    }
}

extension ProjectReaderPresenterTest: ProjectManagerDelegate {
    func addTaskFromReaderComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func deleteProjectComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func updateValidateStatementComplete(_ result: Result<Task?, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func fetchCurrentProjectComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(_):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
}
