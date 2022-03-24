//
//  ProjectService.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import FirebaseFirestore

protocol ProjectLogic {
    func registerProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void)
    
    func registerTask(_ tasks: [Task?]?,_ project: Project?, completion: @escaping (UnsinkableError?) -> Void)
    
    func deleteProject(_ project: Project?, completion: @escaping (UnsinkableError?) -> Void)
    
    func deleteTask(_ project: Project?, _ task: Task?, completion: @escaping (UnsinkableError?) -> Void)
    
    func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void)
    
    func updateProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void)
    
    func updateTask(_ project: Project?, currentTask: Task?, newTask: Task?, _ userData: CustomResponse?,  completion: @escaping (UnsinkableError?) -> Void)
    
    func refreshCurrentProject(_ project: Project?,_ userData: CustomResponse?, completion: @escaping (Project?, UnsinkableError?) -> Void)
    
    func updateValidateStatement(_ project: Project?, selectedTask: Task?, _ userData: CustomResponse?, completion: @escaping (Result<Void?, UnsinkableError>) -> Void)
    
    
}

class ProjectService: ProjectLogic {
    
    
    let session: ProjectSession
    
    init(session: ProjectSession = ProjectSession()) {
        self.session = session
    }
    
    //Call session to registerProject Project
    func registerProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.registerUserProject(project, userData, coverPicture) { (error) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    //Call session to registerTask Project
    func registerTask(_ tasks: [Task?]?,_ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.registerUserTask(tasks, project) { (error) in
            if error != nil {
                completion(error)
            } else {
                completion(error)
            }
        }
    }
    
    //Call session to Delete Project
    func deleteProject(_ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.deleteUserProject(project) { (error) in
            if error != nil {
                completion(error)
            } else {
                //Succeed
                completion(nil)
            }
            
        }
    }
    
    //Call session to delete task
    func deleteTask(_ project: Project?,_ task: Task?, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.deleteUserTask(project, task) { (error) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
            
        }
    }
    
    //Call session to delete all user reference
    func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.deleteAllUserRef(user) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //Call session to update project
    func updateProject(_ project: Project?, _ userData: CustomResponse?, _ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.updateProject(project, userData, coverPicture) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //Call session to update task
    func updateTask(_ project: Project?, currentTask: Task?, newTask: Task?, _ userData: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        self.session.updateTask(project, currentTask: currentTask, newTask: newTask, userData) { error in
            if error != nil {
                guard let error = error else {return}
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //Call session to update validate statement
    func updateValidateStatement(_ project: Project?, selectedTask: Task?, _ userData: CustomResponse?, completion: @escaping (Result<Void?, UnsinkableError>) -> Void) {
        self.session.updateValidateStatement(project, selectedTask: selectedTask, userData) { result in
            switch result {
            case.failure(let error):
                completion(.failure(error))
            case .success:
                completion(.success(()))
            }
        }
    }
    
    //Call session to refresh current project 
    func refreshCurrentProject(_ project: Project?,_ userData: CustomResponse?, completion: @escaping (Project?, UnsinkableError?) -> Void) {
        self.session.refreshCurrentProject(project, userData) { project, error in
            if error != nil {
                completion(nil,error)
            } else {
                completion(project,nil)
            }
        }
    }
}
