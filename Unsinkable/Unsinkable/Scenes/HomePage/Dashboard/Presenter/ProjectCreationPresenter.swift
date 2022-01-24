//
//  ProjectCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation

protocol ProjectManagerDelegate: AnyObject {
    func registerProjectComplete(_ result: Result<Project?,Error>)
    func fetchProjectComplete()
    func fetchCurrentProjectComplete(_ result: Result<Void,Error>)
    func registerTaskComplete(_ result: Result<Task?,Error>)
    func addTaskFromReaderComplete(_ result: Result<Void, Error>)
    func updateLocalTask(_ task: Task)
    func updateTaskComplete(_ result: Result<Task?,Error>)
    func updateProjectComplete(_ result: Result<Project?, Error>)
    func deleteTaskComplete(_ result: Result<Void,Error>)
    func deleteProjectComplete(_ result: Result<Void, Error>)
    func showErrorMessage(with message: String)
}

extension ProjectManagerDelegate {
    func registerProjectComplete(_ result: Result<Project?,Error>) {}
    func fetchProjectComplete() {}
    func fetchCurrentProjectComplete(_ result: Result<Void,Error>) {}
    func registerTaskComplete(_ result: Result<Task?,Error>) {}
    func addTaskFromReaderComplete(_ result: Result<Void, Error>) {}
    func updateLocalTask(_ task: Task) {}
    func updateTaskComplete(_ result: Result<Task?,Error>) {}
    func updateProjectComplete(_ result: Result<Project?, Error>) {}
    func deleteTaskComplete(_ result: Result<Void,Error>) {}
    func deleteProjectComplete(_ result: Result<Void, Error>) {}
    func showErrorMessage(with message: String) {}
}

class ProjectCreationPresenter {
    
    
    weak var delegate: ProjectManagerDelegate?
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
        let formatTitle = title?.formatCharacter()
        if isFieldFill(formatTitle) {
            guard let userId = data?.user.userId else {
                return
            }
            createProjectObject(withTitle: formatTitle, descitpion, userId, tasks: nil)
            projectCreationService.registerProject(self.project, data, coverPicture){ (response, error) in
                if error != nil {
                    guard let error = error else {return}
                    self.delegate?.registerProjectComplete(.failure(error))
                } else {
                    self.delegate?.registerProjectComplete(.success(self.project))
                    
                }
            }
        } else {
            self.delegate?.showErrorMessage(with: UnsinkableError.ProjectCreation.setTitle)
        }
    }
    
    func registerTask(_ title: String?,_ project: Project?) {
        if isFieldFill(title) {
            projectCreationService.registerTask(localTasksList, project) { (response, error) in
                if error != nil {
                    guard let error = error else {return}
                    self.delegate?.registerTaskComplete(.failure(error))
                } else {
                    self.delegate?.registerTaskComplete(.success(self.createTaskObject(title)))
                } 
            }
        } else {
            self.delegate?.showErrorMessage(with: UnsinkableError.ProjectCreation.setTitle)
        }
    }
    
    private func createProjectObject( withTitle: String?,_ description: String?,_ projectOwner: String?, tasks: [Task?]?) {
        let project = Project(title: withTitle, projectID: UUID().uuidString, description: description, ownerUserId: projectOwner, isPersonal: isPersonal, taskList: localTasksList)
        self.project = project
    }
    
    private func createTaskObject(_ title: String?, _ projectID: String? = nil, _ taskID: String? = nil, _ priority: Bool? = nil, _ deadLine: Date? = nil, _ commentary: String? = nil, _ location: String? = nil) -> Task {
        let task = Task(title: title, projectID: projectID, taskID: UUID().uuidString, priority: priority, deadLine: deadLine, commentary: commentary, location: location)
        
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
