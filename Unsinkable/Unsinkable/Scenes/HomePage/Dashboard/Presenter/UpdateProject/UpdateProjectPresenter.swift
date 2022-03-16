//
//  UpdateProjectPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 28/12/2021.
//

import Foundation

class UpdateProjectPresenter {
    
    weak var delegate: ProjectManagerDelegate?
    let projectService: ProjectLogic = ProjectService()
    var userData: CustomResponse?
    var currentProject: Project?
    var coverData: Data? 
    
    
    func updateProject() {
        projectService.updateProject(currentProject, userData, coverData) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.updateProjectComplete(.failure(error))
            } else {
                self.delegate?.updateProjectComplete(.success(nil))
            }
        }
    }
    
    func updateLocalData(_ title: String?, _ description: String?) {
        if title != nil {
            self.currentProject?.title = title
        }
        if description != nil {
            self.currentProject?.description = description
        }
    }
    
}
