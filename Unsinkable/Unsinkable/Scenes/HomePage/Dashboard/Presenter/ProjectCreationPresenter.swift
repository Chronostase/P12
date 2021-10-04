//
//  ProjectCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation

protocol ProjectCreationPresenterDelegate: AnyObject {
    func fetchProjectSucceed()
    func registerProjectSucceed(_ project: Project?)
    func registerProjectFailure()
    func showErrorMessage()
    func registerTaskFailure()
    func registerTaskSucceed(_ task: Task?)
}

class ProjectCreationPresenter {
    
    weak var delegate: ProjectCreationPresenterDelegate?
    var data: CustomResponse?
    var project: Project?
    var localTasksList: [Task?]? = []
    var task: Task?
    let projectCreationService: ProjectLogic = ProjectService()
    var isPersonal: Bool?
    
    
    func checkTextFieldsAvailable(_ title: String?, _ description: String?) -> Bool {
        if title != "" && description != "" {
            return true
        } else {
            return false
        }
    }
    
    func checkTastTitle(_ taskTitle: String?) -> Bool {
        if taskTitle != "" {
            return true
        } else {
            return false
        }
    }
    #warning("Create Project Here and pass image data to service")
    func registerProject(_ title: String?,_ descitpion: String?,_ coverPicture: Data?) {
        if isFieldFill(title) {
            guard let userId = data?.user.userId else {
                return
            }
            createProjectObject(withTitle: title, descitpion, userId, tasks: nil)
            projectCreationService.registerProject(self.project, data, coverPicture){ (response, error) in
                if error != nil {
                    self.delegate?.registerProjectFailure()
                } else {
                    self.delegate?.registerProjectSucceed(self.project)
                    
                }
            }
        } else {
            //Field aren't fills 
            self.delegate?.showErrorMessage()
        }
    }
    
    func registerTask(_ title: String?,_ project: Project?) {
        if isFieldFill(title) {
            createTaskObject(title)
            projectCreationService.registerTask(localTasksList, project) { (response, error) in
                if error != nil {
                    self.delegate?.registerTaskFailure()
                } else {
                    self.delegate?.registerTaskSucceed(self.task)
                } 
            }
        } else {
            self.delegate?.registerTaskFailure()
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
        let project = Project(title: withTitle, projectID: UUID().uuidString, description: description, ownerUserId: projectOwner, isPersonal: isPersonal, taskList: localTasksList)
        self.project = project
    }
    
    private func createTaskObject(_ title: String?) {
        let task = Task(title: title, description: "Some description")
        self.task = task
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
    
    func updateProject(_ title: String?) {
        guard let title = title else {return}
        createTaskObject(title)
        self.localTasksList?.append(task)
    }
    
    func updateLocalData(withProject: Project?) {
        guard let project = withProject else {
            return
        }
        self.data?.user.projects?.append(project)
    }
    
    func updateLocalTaskData(withTask: Task?) {
        guard let task = withTask else {
            return
        }
        self.localTasksList?.append(task)
    }
}
