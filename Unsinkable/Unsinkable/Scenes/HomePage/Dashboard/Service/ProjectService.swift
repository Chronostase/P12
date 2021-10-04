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
    
}

class ProjectService: ProjectLogic {
    
    
    let session: ProjectSession
    
    init(session: ProjectSession = ProjectSession()) {
        self.session = session
    }
    #warning("Pass data from service to Session")
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
}
