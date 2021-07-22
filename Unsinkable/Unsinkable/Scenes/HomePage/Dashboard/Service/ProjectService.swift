//
//  ProjectService.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import FirebaseFirestore

protocol ProjectLogic {
    func registerProject(_ project: Project?,_ userData: CustomResponse?,completion: @escaping (CustomResponse?, Error?) -> Void)
    
    func fetchTaskList(_ data: CustomResponse?, completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void)
}

class ProjectService: ProjectLogic {
    
    
    let session: ProjectSession
    
    init(session: ProjectSession = ProjectSession()) {
        self.session = session
    }
    
    func fetchTaskList(_ data: CustomResponse?, completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        self.session.fetchTask(data) { queryDocumentSnapshot, error in
            if error != nil {
                guard let error = error else {
                    return
                }
                completion(nil, error)
            } else {
                completion(queryDocumentSnapshot, nil)
            }
        }
    }
    
    func registerProject(_ project: Project?,_ userData: CustomResponse?, completion: @escaping (CustomResponse?, Error?) -> Void) {
        self.session.registerUserProject(project, userData) { (response, error) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(nil, error)
            }
        }
    }
}
