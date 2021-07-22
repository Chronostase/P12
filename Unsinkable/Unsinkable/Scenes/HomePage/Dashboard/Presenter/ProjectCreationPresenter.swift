//
//  ProjectCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation

protocol ProjectCreationPresenterDelegate: AnyObject {
    func fetchProjectSucceed()
    func registerSucceed(_ project: Project?)
    func registerProjectFailure()
    func showErrorMessage()
}

class ProjectCreationPresenter {
    
    weak var delegate: ProjectCreationPresenterDelegate?
    var data: CustomResponse?
    var project: Project?
    let projectCreationService: ProjectLogic = ProjectService()
    
    func checkTextFieldsAvailable(_ title: String?, _ description: String?) -> Bool {
        if title != "" && description != "" {
            return true
        } else {
            return false
        }
    }
    
    func registerProject(_ title: String?,_ descitpion: String?) {
        if isFieldFill(title) {
            guard let userId = data?.user.userId else {
                return
            }
            createProjectObject(withTitle: title, descitpion, userId, tasks: nil)
            
//            self.data?.user.projects.append(self.project)
//            assigneProjectToUser(title, descitpion)
//            projectCreationService.registerProject(data)
            projectCreationService.registerProject(self.project, data){ (response, error) in
                if error != nil {
                    self.delegate?.registerProjectFailure()
                } else {
                    self.delegate?.registerSucceed(self.project)
                }
            }
        } else {
            //Field aren't fills 
            self.delegate?.showErrorMessage()
        }
    }
    
    func fetchtaskList() {
//        projectCreationService.fetchTaskList(self.data) { documents, error in
//            if error != nil {
//                guard let error = error else {
//                    return
//                }
////                self.delegate.fetchTaskFailed()
//            } else {
//                let taskList = documents.map { (queryDocumentsSnapshot) -> TaskList in
////                    let data = queryDocumentsSnapshot.data
//                }
//            }
//        }
    }
    
    private func createProjectObject( withTitle: String?,_ description: String?,_ projectOwner: String?, tasks: [Task?]?) {
        let project = Project(title: withTitle, description: description, ownerUserId: projectOwner, taskList: tasks)
        self.project = project
    }
    
    private func isFieldFill(_ field: String?) -> Bool {
        guard let field = field else {
            return false
        }
        if field.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func updateLocalData(withProject: Project?) {
        guard let project = withProject else {
            return
        }
        self.data?.user.projects?.append(project)
    }
}
