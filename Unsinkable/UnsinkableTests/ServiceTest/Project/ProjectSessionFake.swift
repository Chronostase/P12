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
    
    var fakeUser: FakeUserDetails?
    var database = FakeStorage(users: [])
    
    override func registerUserProject(_ project: Project?, _ userData: CustomResponse?, _ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project else {return}
        guard let fakeUser = fakeUser else {return}
        var index = 0
        
        let newUser = FakeCustomResponse(user: fakeUser)
        database.users?.append(newUser)
        let fakeProject = FakeProject(title: project.title, projectID: project.projectID, description: project.description, ownerUserId: project.ownerUserId, isPersonal: project.isPersonal, downloadUrl: project.downloadUrl, taskList: [])
        
        if userData?.user.userId == fakeUser.userId {
            guard let usersArray = database.users else {return}
            for user in usersArray {
                if user.user.userId == fakeUser.userId {
                    database.users?[index].user.projects?.append(fakeProject)
                    self.fakeUser?.projects?.append(fakeProject)
                    completion(nil)
                    return
                }
                index += 1
            }
            completion(UnsinkableError.unknowError)
        }
        completion(UnsinkableError.unknowError)
    }
    
    override func registerUserTask(_ tasks: [Task?]?, _ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project else {return}
        guard let fakeUser = fakeUser else {return}
        var index = 0
        
        let fakeProject = FakeProject(title: project.title, projectID: project.projectID, description: project.description, ownerUserId: project.ownerUserId, isPersonal: project.isPersonal, downloadUrl: project.downloadUrl, taskList: [])
        let newUser = FakeCustomResponse(user: fakeUser)
        guard let tasksArray = tasks else {return}
        database.users?.append(newUser)
        database.users?[0].user.projects?.append(fakeProject)
        for task in tasksArray {
            let fakeTask = FakeTask(title: task?.title, projectID: task?.projectID, taskID: task?.taskID, priority: task?.priority, deadLine: task?.deadLine, commentary: task?.commentary, location: task?.location, isValidate: task?.isValidate)
            guard let projectArray = database.users?[0].user.projects else {return}
            for userProject in projectArray {
                if userProject?.projectID == project.projectID {
                    database.users?[0].user.projects?[index]?.taskList?.append(fakeTask)
                    completion(nil)
                    return
                }
                index += 1
            }
        }
        completion(UnsinkableError.databaseCantStoreTask)
    }
    
    override func deleteUserProject(_ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project,
              var fakeUser = fakeUser else {return}
        let fakeProject = FakeProject(title: project.title, projectID: project.projectID, description: project.description, ownerUserId: project.ownerUserId, isPersonal: project.isPersonal, downloadUrl: project.downloadUrl, taskList: [])
        var index = 0
        
        fakeUser.projects?.append(fakeProject)
        self.fakeUser = fakeUser
        let newUser = FakeCustomResponse(user: fakeUser)
        database.users?.append(newUser)
        guard let projectArray = fakeUser.projects else {return}
        
        for project in projectArray {
            if newUser.user.userId == project?.ownerUserId {
                self.fakeUser?.projects?.remove(at: index)
                completion(nil)
                return
            }
            index += 1
        }
        completion(UnsinkableError.databaseCantDeleteProject)
        return 
    }
    
    override func deleteUserTask(_ project: Project?, _ task: Task?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project,
              let task = task else {return}
        let fakeTask = FakeTask(title: task.title, projectID: task.projectID, taskID: task.taskID, priority: task.priority, deadLine: task.deadLine, commentary: task.commentary, location: task.location, isValidate: task.isValidate)
        let fakeProject = FakeProject(title: project.title, projectID: project.projectID, description: project.description, ownerUserId: project.ownerUserId, isPersonal: project.isPersonal, downloadUrl: project.downloadUrl, taskList: [fakeTask])
        self.fakeUser?.projects?.append(fakeProject)
        
        var index = 0
        
        guard let projectList = self.fakeUser?.projects else {return}
        for project in projectList {
            guard let taskList = project?.taskList else {return}
            for task in taskList {
                if task?.projectID == project?.projectID && fakeUser?.userId == project?.ownerUserId {
                    self.fakeUser?.projects?[0]?.taskList?.remove(at: index)
                    completion(nil)
                    return
                }
                index += 1
            }
            completion(UnsinkableError.unknowError)
            return 
        }
    }
    
    override func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        let fakeCustom = FakeCustomResponse(user: FakeUserDetails(email: user?.user.email, password: "", firstName: user?.user.firstName, name: user?.user.name, userId: user?.user.userId, projects: []))
        database.users?.append(fakeCustom)
        guard let customResponse = user?.user,
              let remoteDatabase = database.users else {return}
        var index = 0
        
        
        if fakeUser?.userId == customResponse.userId {
            for registerUser in remoteDatabase {
                if registerUser.user.userId == customResponse.userId {
                    database.users?.remove(at: index)
                    completion(nil)
                    return
                }
                index += 1 
            }
            
        } else {
            completion(UnsinkableError.unknowError)
            return
        }
    }
    
    override func updateProject(_ project: Project?, _ userData: CustomResponse?, _ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project,
              let user = userData?.user else {return}
        var index = 0
        let fakeProject = FakeProject(title: "OldProject", projectID: "123456", description: "Old", ownerUserId: "AZERTY", isPersonal: true, downloadUrl: nil, taskList: nil)
        fakeUser?.projects?.append(fakeProject)
        guard let newFakeUser = fakeUser else {return}
        let newUser = FakeCustomResponse(user: newFakeUser)
        database.users?.append(newUser)
        guard let projectList = fakeUser?.projects else {return}
        if user.userId == fakeUser?.userId {
            for registredProject in projectList {
                if project.projectID == registredProject?.projectID {
                    let updatedProject = FakeProject(title: project.title, projectID: project.projectID, description: project.description, ownerUserId: project.ownerUserId, isPersonal: project.isPersonal, downloadUrl: project.downloadUrl, taskList: [])
                    database.users?[0].user.projects?.remove(at: index)
                    database.users?[0].user.projects?.insert(updatedProject, at: index)
                    completion(nil)
                    return
                }
                index += 1
            }
        } else {
            completion(UnsinkableError.unknowError)
            return 
        }
    }
    
    override func updateTask(_ project: Project?, currentTask: Task?, newTask: Task?, _ userData: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project,
              let currentTask = currentTask,
              let newTask = newTask,
              let user = userData else { return}
        let fakeProject = FakeProject(title: project.title, projectID: project.projectID, description: project.description, ownerUserId: project.ownerUserId, isPersonal: project.isPersonal, downloadUrl: project.downloadUrl, taskList: [])
        let currentFakeTask = FakeTask(title: currentTask.title, projectID: currentTask.projectID, taskID: currentTask.taskID, priority: currentTask.priority, deadLine: currentTask.deadLine, commentary: currentTask.commentary, location: currentTask.location, isValidate: currentTask.isValidate)
        fakeUser?.projects?.append(fakeProject)
        fakeUser?.projects?[0]?.taskList?.append(currentFakeTask)
        guard let fakeCustomUser = fakeUser else {return}
        let fakeCustomResponse = FakeCustomResponse(user: fakeCustomUser)
        database.users?.append(fakeCustomResponse)
        guard let taskList = fakeUser?.projects?[0]?.taskList else {return}
        var index = 0
        
        if fakeUser?.userId == project.ownerUserId && fakeUser?.userId == user.user.userId {
            for task in taskList {
                if task?.taskID == newTask.taskID {
                    let updatedFakeTask = FakeTask(title: newTask.title, projectID: newTask.projectID, taskID: newTask.taskID, priority: newTask.priority, deadLine: newTask.deadLine, commentary: newTask.commentary, location: newTask.location, isValidate: newTask.isValidate)
                    database.users?[0].user.projects?[0]?.taskList?.remove(at: index)
                    database.users?[0].user.projects?[0]?.taskList?.insert(updatedFakeTask, at: index)
                    fakeUser?.projects?[0]?.taskList?.remove(at: index)
                    fakeUser?.projects?[0]?.taskList?.insert(updatedFakeTask, at: index)
                    
                    completion(nil)
                    return
                }
                index += 1
            }
            completion(UnsinkableError.unknowError)
        } else {
            completion(UnsinkableError.unknowError)
            return
        }
    }
    
    override func updateValidateStatement(_ project: Project?, selectedTask: Task?, _ userData: CustomResponse?, completion: @escaping (Result<Void?, UnsinkableError>) -> Void) {
        guard let project = project,
              let selectedTask = selectedTask,
              let user = userData else {return}
        let fakeProject = FakeProject(title: project.title, projectID: project.projectID, description: project.description, ownerUserId: project.ownerUserId, isPersonal: project.isPersonal, downloadUrl: project.downloadUrl, taskList: [])
        let currentFakeTask = FakeTask(title: "Test", projectID: "AZERTY", taskID: "plop", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
        fakeUser?.projects?.append(fakeProject)
        fakeUser?.projects?[0]?.taskList?.append(currentFakeTask)
        guard let fakeCustomUser = fakeUser else {return}
        let fakeCustomResponse = FakeCustomResponse(user: fakeCustomUser)
        database.users?.append(fakeCustomResponse)
        guard let taskList = fakeUser?.projects?[0]?.taskList else {return}
        var index = 0
        
        if fakeUser?.userId == project.ownerUserId && fakeUser?.userId == user.user.userId {
            for fakeUserTask in taskList {
                if fakeUserTask?.taskID == selectedTask.taskID {
                    let updatedFakeTask = FakeTask(title: selectedTask.title, projectID: selectedTask.projectID, taskID: selectedTask.taskID, priority: selectedTask.priority, deadLine: selectedTask.deadLine, commentary: selectedTask.commentary, location: selectedTask.location, isValidate: selectedTask.isValidate)
                    database.users?[0].user.projects?[0]?.taskList?.remove(at: index)
                    database.users?[0].user.projects?[0]?.taskList?.insert(updatedFakeTask, at: index)
                    fakeUser?.projects?[0]?.taskList?.remove(at: index)
                    fakeUser?.projects?[0]?.taskList?.insert(updatedFakeTask, at: index)
                    
                    completion(.success(()))
                    return
                }
                index += 1
            }
            completion(.failure(UnsinkableError.unknowError))
        } else {
            completion(.failure(UnsinkableError.unknowError))
            return
        }
    }
    
    override func refreshCurrentProject(_ project: Project?, _ userData: CustomResponse?, completion: @escaping (Project?, UnsinkableError?) -> Void) {
        guard var project = project,
              let user = userData?.user else {return}
        
        if user.userId == self.fakeUser?.userId {
            project.title = "refreshProject"
            completion(project ,nil)
        } else {
            completion(nil, UnsinkableError.unknowError)
        }
        
    }
}
