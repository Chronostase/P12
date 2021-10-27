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
    func taskEdited(_ task: Task?)
    func updateLocalTask(_ task: Task)
}

extension ProjectCreationPresenterDelegate {
    func fetchProjectSucceed() {}
    func registerProjectSucceed(_ project: Project?) {}
    func registerProjectFailure() {}
    func showErrorMessage() {}
    func registerTaskFailure() {}
    func registerTaskSucceed(_ task: Task?) {}
    func taskEdited(_ task: Task?) {}
    func updateLocalTask(_ task: Task) {}
}

class ProjectCreationPresenter {
    
    
    weak var delegate: ProjectCreationPresenterDelegate?
    var data: CustomResponse?
    var project: Project?
    var localTasksList: [Task?]? = []
    var editedTask: Task?
    let projectCreationService: ProjectLogic = ProjectService()
    var isPersonal: Bool?
    
    func checkTextFieldsAvailable(_ title: String?, _ description: String?) -> Bool {
        if title != "" && description != "" {
            return true
        } else {
            return false
        }
    }
    
    func checkTaskTitle(_ taskTitle: String?) -> Bool {
        if taskTitle != "" {
            return true
        } else {
            return false
        }
    }
    
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
        #warning("may cause crash here ")
        if isFieldFill(title) {
            projectCreationService.registerTask(localTasksList, project) { (response, error) in
                if error != nil {
                    self.delegate?.registerTaskFailure()
                } else {
                    self.delegate?.registerTaskSucceed(self.createTaskObject(title))
                } 
            }
        } else {
            self.delegate?.registerTaskFailure()
            self.delegate?.showErrorMessage()
        }
    }
    
   
    private func createProjectObject( withTitle: String?,_ description: String?,_ projectOwner: String?, tasks: [Task?]?) {
        let project = Project(title: withTitle, projectID: UUID().uuidString, description: description, ownerUserId: projectOwner, isPersonal: isPersonal, taskList: localTasksList)
        self.project = project
    }
    
    #warning("Save firstTask with title projectPresenter.Task = task")
    private func createTaskObject(_ title: String?, _ projectID: String? = nil, _ taskID: String? = nil, _ priority: Bool? = nil, _ deadLine: String? = nil, _ commentary: String? = nil) -> Task {
        let task = Task(title: title, projectID: projectID, taskID: UUID().uuidString, priority: priority, deadLine: deadLine, commentary: commentary)
        
        #warning("May cause task creation bug")
//        self.task = task
        return task
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
//        createTaskObject(title)
//        self.localTasksList?.append(task)
        localTasksList?.append(createTaskObject(title))
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
        localTasksList?.append(task)
    }

}
