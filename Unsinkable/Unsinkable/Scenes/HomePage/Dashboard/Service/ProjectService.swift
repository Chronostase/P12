//
//  ProjectService.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import FirebaseFirestore

protocol ProjectLogic {
    func registerProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (CustomResponse?, Error?) -> Void)
    
    func registerTask(_ tasks: [Task?]?,_ project: Project?, completion: @escaping (CustomResponse?, Error?) -> Void)
    
    func deleteProject(_ project: Project?, completion: @escaping (Error?) -> Void)
    
    func deleteTask(_ project: Project?, _ task: Task?, completion: @escaping (Error?) -> Void)
    
    func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (Error?) -> Void)
}

class ProjectService: ProjectLogic {
    
    
    let session: ProjectSession
    
    init(session: ProjectSession = ProjectSession()) {
        self.session = session
    }
    
    func registerProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (CustomResponse?, Error?) -> Void) {
        self.session.registerUserProject(project, userData, coverPicture) { (response, error) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func registerTask(_ tasks: [Task?]?,_ project: Project?, completion: @escaping (CustomResponse?, Error?) -> Void) {
        self.session.registerUserTask(tasks, project) { (response, error) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func deleteProject(_ project: Project?, completion: @escaping (Error?) -> Void) {
        self.session.deleteUserProject(project) { (error) in
            if error != nil {
                completion(error)
            } else {
                //Succeed
                completion(nil)
            }
            
        }
    }
    
    func deleteTask(_ project: Project?,_ task: Task?, completion: @escaping (Error?) -> Void) {
        self.session.deleteUserTask(project, task) { (error) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
            
        }
    }
    
    func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (Error?) -> Void) {
        self.session.deleteAllUserRef(user) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
