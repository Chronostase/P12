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
    func updateProjectSucceed()
    func updateProjectFailed()
}

class ProjectReaderPresenter {
    weak var delegate: ProjectManagerDelegate?
    
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
                guard let error = error else {return}
                self.delegate?.deleteProjectComplete(.failure(error))
            } else {
                self.delegate?.deleteProjectComplete(.success(()))
            }
        }
    }
    
    func updateProject(_ coverData: Data?) {
        projectService.updateProject(selectedProject, userData, coverData) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.updateProjectComplete(.failure(error))
            } else {
                self.delegate?.updateProjectComplete(.success(nil))
            }
        }
    }
    
    #warning("See to use this only when project/task are updated not on read only")
    func refreshCurrentProject() {
        projectService.refreshCurrentProject(selectedProject, userData) { project, error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.fetchCurrentProjectComplete(.failure(error))
                print("Can't refresh project")
            } else {
                self.selectedProject = project
                self.delegate?.fetchCurrentProjectComplete(.success(()))
                print("successFully update")
            }
        }
    }
    
}
