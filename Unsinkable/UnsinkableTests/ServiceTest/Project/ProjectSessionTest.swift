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
        projectSessionFake?.fakeUser = FakeUserDetails(email: "thomas.giron@gmail.com", password: "azerTyui!9", firstName: "thomas", name: "giron", userId: "AZERTY", projects: [])
        projectSessionFake?.database.users = []
        projectService = ProjectService(session: projectSessionFake!)
    }
    
    private func resetData() {
        projectSessionFake = nil
        projectService = nil
    }
    
    func testRegisterProjectShouldRegisterIfCorrectProjectAndUser() {
        let project = Project(title: "Test", projectID: "AZERTY", description: "A test project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        let customResponse = CustomResponse(user: UserDetails(email: "thomas.giron@gmail.com", firstName: "thomas", name: "giron", userId: "AZERTY", projects: []))
        projectService?.registerProject(project, customResponse, nil, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                guard let fakeUser = self.projectSessionFake?.fakeUser else {return}
                XCTAssertNil(error)
                XCTAssertEqual(1, fakeUser.projects?.count)
                XCTAssertEqual(fakeUser.projects?[0]?.title, "Test")
            }
        })
    }
    
    func testRegisterProjectShouldFailedIfWrongUser() {
        let project = Project(title: "Test", projectID: "AZERTY", description: "A test project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        let customResponse = CustomResponse(user: UserDetails(email: "thomas.giron@gmail.com", firstName: "thomas", name: "giron", userId: "AZERTYPPPP", projects: []))
        projectService?.registerProject(project, customResponse, nil, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                XCTAssertNil(error)
            }
        })
    }
    
    func testRegisterTaskShouldWorkIfCorrectUserAndTask() {
        let Task1 = Task(title: "test", projectID: "AZERTY", taskID: "AZERTYY", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        let taskList = [Task1]
        let project = Project(title: "Test", projectID: "AZERTY", description: "A test project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        projectService?.registerTask(taskList, project, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                XCTAssertNil(error)
                XCTAssertEqual(1, self.projectSessionFake?.database.users?[0].user.projects?[0]?.taskList?.count)
                
            }
        })
    }
    
    func testRegisterTaskShouldFailedIfNoTask() {
        
        let project = Project(title: "Test", projectID: "AZERTY", description: "A test project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        projectService?.registerTask([], project, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testDeleteProjectShouldWorkIfCorrectUser() {
        let project = Project(title: "Test", projectID: "AZERTY", description: "A test project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        projectService?.deleteProject(project, completion: { error in
            if error != nil {
                XCTAssertNil(error)
            } else {
                XCTAssertNil(error)
                XCTAssertEqual(0, self.projectSessionFake?.fakeUser?.projects?.count)
            }
        })
    }
    
    func testDeleteProjectShouldFailIfNotGoodOwnerID() {
        let project = Project(title: "Test", projectID: "AZERTYUIOP", description: "A test project", ownerUserId: "AZERTYUIOP", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        
        projectService?.deleteProject(project, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                XCTAssertNil(error)
            }
        })
    }
    
    func testDeleteTaskShouldWorkIfCorrectUserAndProjectTask() {
        let project = Project(title: "Test", projectID: "AZERTYUIOP", description: "A test project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        let task = Task(title: "test", projectID: "AZERTYUIOP", taskID: "plop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        
        projectService?.deleteTask(project, task, completion: { error in
            if error != nil {
                XCTAssertNil(error)
            } else {
                XCTAssertNil(error)
                XCTAssertEqual(0, self.projectSessionFake?.fakeUser?.projects?[0]?.taskList?.count)
            }
        })
    }
    
    func testDeleteShouldFailIfWrongTaskID() {
        let project = Project(title: "Test", projectID: "AZERTYUIOP", description: "A test project", ownerUserId: "AZERTYUIOP", isPersonal: true, downloadUrl: "https://www.downloadUrl.com", taskList: [])
        let task = Task(title: "test", projectID: "AZERT", taskID: "plop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        
        projectService?.deleteTask(project, task, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(1, self.projectSessionFake?.fakeUser?.projects?[0]?.taskList?.count)
            } else {
                XCTAssertNotNil(error)
                XCTAssertEqual(0, self.projectSessionFake?.fakeUser?.projects?[0]?.taskList?.count)
            }
        })
    }
    
    func testDeleteUserShouldWorkIfCorrectUID() {
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let customResponse = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: fakeUser.userId, projects: []))
        projectService?.deleteAllUserRef(customResponse, completion: { error in
            if error != nil {
                XCTAssertNil(error)
            } else {
                XCTAssertNil(error)
                XCTAssertEqual(0, self.projectSessionFake?.database.users?.count)
            }
        })
    }
    
    func testDeleteUserShouldFailIfIncorrectUID() {
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let customResponse = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: "Test12345", projects: []))
        projectService?.deleteAllUserRef(customResponse, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(1, self.projectSessionFake?.database.users?.count)
            } else {
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testUpdateProjectShouldWorkIfCorrectUserID() {
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let user = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: fakeUser.userId, projects: []))
        let project = Project(title: "Updated", projectID: "123456", description: "updated project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        projectService?.updateProject(project, user, nil, completion: { error in
            if error != nil {
                XCTAssertNil(error)
            } else {
                XCTAssertNil(error)
                XCTAssertEqual(self.projectSessionFake?.database.users?[0].user.projects?[0]?.title, "Updated")
            }
        })
    }
    
    func testUpdateProjectShouldFailIfIncorrectUserID() {
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let user = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: "anotherOne", projects: []))
        let project = Project(title: "Updated", projectID: "", description: "updated project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        projectService?.updateProject(project, user, nil, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(self.projectSessionFake?.fakeUser?.projects?[0]?.title, "OldProject")
            } else {
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testUpdateTaskShouldWorkIfCorrectUser() {
        let project = Project(title: "Updated", projectID: "AZERT", description: "updated project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        let task = Task(title: "test", projectID: "AZERT", taskID: "plop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        let newTask = Task(title: "UpdatedTask", projectID: "AZERT", taskID: "plop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let user = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: fakeUser.userId, projects: []))
        projectService?.updateTask(project, currentTask: task, newTask: newTask, user, completion: { error in
            if error != nil {
                XCTAssertNil(error)
            } else {
                XCTAssertNil(error)
                XCTAssertEqual("UpdatedTask", self.projectSessionFake?.database.users?[0].user.projects?[0]?.taskList?[0]?.title)
            }
        })
    }
    
    func testUpdateTaskShouldFailIfWrongTaskID() {
        let project = Project(title: "Updated", projectID: "AZERT", description: "updated project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        let task = Task(title: "test", projectID: "AZERT", taskID: "plop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        let newTask = Task(title: "UpdatedTask", projectID: "AZERT", taskID: "plopppp", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let user = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: fakeUser.userId, projects: []))
        projectService?.updateTask(project, currentTask: task, newTask: newTask, user, completion: { error in
            if error != nil {
                XCTAssertNotNil(error)
                XCTAssertEqual("test", self.projectSessionFake?.database.users?[0].user.projects?[0]?.taskList?[0]?.title)
            } else {
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testUpdateValidateStatementShouldWorkIfCorrectTaskID() {
        let project = Project(title: "Updated", projectID: "AZERT", description: "updated project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        let task = Task(title: "test", projectID: "AZERT", taskID: "plop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let user = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: fakeUser.userId, projects: []))
        
        projectService?.updateValidateStatement(project, selectedTask: task, user, completion: { result in
            switch result {
            case .success(let void):
                XCTAssertNotNil(void)
                XCTAssertEqual(self.projectSessionFake?.database.users?[0].user.projects?[0]?.taskList?[0]?.isValidate, true)
            case .failure(let error):
                XCTAssertNil(error)
            }
        })
        
    }
    
    func testUpdateValidateStatementShouldFailIfInCorrectTaskID() {
        let project = Project(title: "Updated", projectID: "AZERT", description: "updated project", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        let task = Task(title: "test", projectID: "AZERT", taskID: "plopppp", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: true)
        
        guard let fakeUser = projectSessionFake?.fakeUser else {return}
        let user = CustomResponse(user: UserDetails(email: fakeUser.email, firstName: fakeUser.firstName, name: fakeUser.name, userId: fakeUser.userId, projects: []))
        
        projectService?.updateValidateStatement(project, selectedTask: task, user, completion: { result in
            switch result {
            case .success(let void):
                XCTAssertNil(void)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(self.projectSessionFake?.database.users?[0].user.projects?[0]?.taskList?[0]?.isValidate, false)
            }
        })
        
    }
    
    func testRefreshProjectShouldWorkIfCorrectUserID() {
        let unUpdatedProject = Project(title: "Test", projectID: "Projects", description: nil, ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        let response = CustomResponse(user: UserDetails(email: "thomas.giron@gmail.com", firstName: "Thomas", name: "Giron", userId: "AZERTY", projects: []))
        projectService?.refreshCurrentProject(unUpdatedProject, response, completion: { project, error in
            if error != nil {
                XCTAssertNil(error)
            } else {
                XCTAssertNotNil(project)
                XCTAssertEqual("refreshProject", project?.title)
            }
        })
    }
    
    func testRefreshProjectShouldFailIfinCorrectUserID() {
        let unUpdatedProject = Project(title: "Test", projectID: "Projects", description: nil, ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: [])
        let response = CustomResponse(user: UserDetails(email: "thomas.giron@gmail.com", firstName: "Thomas", name: "Giron", userId: "AZERTYUIOP", projects: []))
        projectService?.refreshCurrentProject(unUpdatedProject, response, completion: { project, error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                XCTAssertNil(project)
            }
        })
    }
}
