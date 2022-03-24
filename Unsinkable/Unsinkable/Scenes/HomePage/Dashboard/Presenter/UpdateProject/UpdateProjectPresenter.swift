//
//  UpdateProjectPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 28/12/2021.
//

import Foundation

class UpdateProjectPresenter {
    
    weak var delegate: ProjectManagerDelegate?
    var userData: CustomResponse?
    var currentProject: Project?
    var coverData: Data?
    
    let service: ProjectLogic
    
    init (session: ProjectLogic = ProjectService()) {
        self.service = session
    }
    
    //Call service to updateProject and call delegate to handle result
    func updateProject() {
        service.updateProject(currentProject, userData, coverData) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.updateProjectComplete(.failure(error))
            } else {
                self.delegate?.updateProjectComplete(.success(nil))
            }
        }
    }
    
    //update local project data 
    func updateLocalData(_ title: String?, _ description: String?) {
        if title != nil {
            self.currentProject?.title = title
        }
        if description != nil {
            self.currentProject?.description = description
        }
    }
    
}
