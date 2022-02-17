//
//  ProjectCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation

protocol ProjectManagerDelegate: AnyObject {
    func registerProjectComplete(_ result: Result<Project?,UnsinkableError>)
    func registerTaskComplete(_ result: Result<Void,UnsinkableError>)
    func fetchCurrentProjectComplete(_ result: Result<Void,UnsinkableError>)
    func fetchProjectComplete()
    
    func addTaskFromReaderComplete(_ result: Result<Void, UnsinkableError>)
    
    func updateLocalTask(_ task: Task)
    func updateTaskComplete(_ result: Result<Task?,UnsinkableError>)
    func updateValidateStatementComplete(_ result: Result<Task?, UnsinkableError>)
    func updateProjectComplete(_ result: Result<Project?, UnsinkableError>)
    
    func deleteTaskComplete(_ result: Result<Void,UnsinkableError>)
    func deleteProjectComplete(_ result: Result<Void, UnsinkableError>)
    
    func showErrorMessage(with message: String)
}

extension ProjectManagerDelegate {
    func registerProjectComplete(_ result: Result<Project?,UnsinkableError>) {}
    func registerTaskComplete(_ result: Result<Void,UnsinkableError>) {}
    func fetchProjectComplete() {}
    func fetchCurrentProjectComplete(_ result: Result<Void,UnsinkableError>) {}
    
    func addTaskFromReaderComplete(_ result: Result<Void, UnsinkableError>) {}
    
    func updateLocalTask(_ task: Task) {}
    func updateTaskComplete(_ result: Result<Task?,UnsinkableError>) {}
    func updateValidateStatementComplete(_ result: Result<Task?, UnsinkableError>) {}
    func updateProjectComplete(_ result: Result<Project?, UnsinkableError>) {}
    
    func deleteTaskComplete(_ result: Result<Void,UnsinkableError>) {}
    
    func deleteProjectComplete(_ result: Result<Void, UnsinkableError>) {}
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
    
    
    
    func registerProject(_ title: String?,_ descitpion: String?,_ coverPicture: Data?) {
        let formatTitle = title?.formatCharacter()
        if isFieldFill(formatTitle) {
            guard let userId = data?.user.userId else {
                return
            }
            createProjectObject(withTitle: formatTitle, descitpion, userId, tasks: nil)
            projectCreationService.registerProject(self.project, data, coverPicture){ (error) in
                if error != nil {
                    guard let error = error else {
                        self.delegate?.registerProjectComplete(.failure(UnsinkableError.unknowError))
                        return
                    }
                    self.delegate?.registerProjectComplete(.failure(error))
                } else {
                    self.delegate?.registerProjectComplete(.success(self.project))
                    
                }
            }
        } else {
            self.delegate?.registerProjectComplete(.failure(UnsinkableError.setTitle))
        }
    }
    
    func registerTask(_ project: Project?) {
        projectCreationService.registerTask(localTasksList, project) { (error) in
            if error != nil {
                guard let error = error else {
                    self.delegate?.registerProjectComplete(.failure(UnsinkableError.unknowError))
                    return
                }
                self.delegate?.registerTaskComplete(.failure(error))
            } else {
                self.delegate?.registerTaskComplete(.success(()))
            }
        }
    }
    
    private func createProjectObject( withTitle: String?,_ description: String?,_ projectOwner: String?, tasks: [Task?]?) {
        let project = Project(title: withTitle, projectID: UUID().uuidString, description: description, ownerUserId: projectOwner, isPersonal: isPersonal, taskList: localTasksList)
        self.project = project
    }
    
    func checkTextFieldsAvailable(_ title: String?, _ description: String?) -> Bool {
        if title != "" && description != "" {
            return true
        } else {
            return false
        }
    }
    
    func checkTaskTitle(_ taskTitle: String?) -> Bool {
        if taskTitle?.formatCharacter() != "" {
            return true
        } else {
            return false
        }
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
