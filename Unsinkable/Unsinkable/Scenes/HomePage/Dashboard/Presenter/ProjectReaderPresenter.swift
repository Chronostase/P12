//
//  ProjectReaderPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/10/2021.
//

import Foundation

protocol ProjectReaderDelegate: AnyObject {
    func deleteProjectSucceed()
    func deleteProjectFailure()
}

class ProjectReaderPresenter {
    weak var delegate: ProjectReaderDelegate?
    
    let projectService: ProjectLogic = ProjectService()
    var selectedProject: Project?
    var userData: CustomResponse?
    
    func checkIfTitleIsNil() -> Bool {
        guard let _ = selectedProject?.title else {
            return true
        }
        return false 
    }
    func checkIfCoverPicture() -> Bool {
        guard let _ = selectedProject?.downloadUrl else {
            return false
        }
        return true
    }
    
    func checkIfDescriptionIsEmpty() -> Bool {
        guard let _ = selectedProject?.description else {
            return true
        }
        return false
    }
    
    func checkIfTaskListIsEmpty() -> Bool {
        guard let taskList = selectedProject?.taskList else {
            return true
        }
        if taskList.isEmpty {
            return true
        } else {
            return false 
        }
    }
    
    func deleteProject() {
        projectService.deleteProject(selectedProject) { error in
            if error != nil {
                self.delegate?.deleteProjectFailure()
            } else {
                self.delegate?.deleteProjectSucceed()
            }
        }
    }
    
}
