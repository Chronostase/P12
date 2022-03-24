//
//  ProjectCreationPresenter+ProjectCreationLogic.swift
//  Unsinkable
//
//  Created by Thomas on 16/03/2022.
//

import Foundation

extension ProjectCreationPresenter: ProjectCreationLogic {
    
    //Proceed to check before calling service to register project
    func registerProject(_ title: String?,_ descitpion: String?,_ coverPicture: Data?, completion: @escaping (Result<Project?, UnsinkableError>) -> Void) {
        let formatTitle = title?.formatCharacter()
        if isFieldFill(formatTitle) {
            guard let userId = data?.user.userId else {
                completion(.failure(UnsinkableError.userMisMatch))
                return
            }
            createProjectObject(withTitle: formatTitle, descitpion, userId, tasks: nil)
            service.registerProject(self.project, data, coverPicture){ (error) in
                if error != nil {
                    guard let error = error else {return}
                    completion(.failure(error))
                } else {
                    completion(.success(self.project))
                }
            }
        } else {
            completion(.failure(UnsinkableError.setTitle))
        }
    }
    
    //Call service to register task, call delegate methode to handle result
    func registerTask(_ project: Project?) {
        service.registerTask(localTasksList, project) { (error) in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.registerTaskComplete(.failure(error))
            } else {
                self.delegate?.registerTaskComplete(.success(()))
            }
        }
    }
    
    //Create Project with field content
    func createProjectObject( withTitle: String?,_ description: String?,_ projectOwner: String?, tasks: [Task?]?) {
        let project = Project(title: withTitle, projectID: UUID().uuidString, description: description, ownerUserId: projectOwner, isPersonal: isPersonal, taskList: localTasksList)
        self.project = project
    }
    
    //Check if textField arn't empty
    func checkTextFieldsAvailable(_ title: String?, _ description: String?) -> Bool {
        if title != "" && description != "" {
            return true
        } else {
            return false
        }
    }
    
    //Check if taskTitle isn't empty
    func checkTaskTitle(_ taskTitle: String?) -> Bool {
        if taskTitle?.formatCharacter() != "" {
            return true
        } else {
            return false
        }
    }
    
    //Create task object with field content
    func createTaskObject(_ title: String?, _ projectID: String?, _ taskID: String?, _ priority: Bool?, _ deadLine: Date?, _ commentary: String?, _ location: String?) -> Task {
        let task = Task(title: title, projectID: projectID, taskID: UUID().uuidString, priority: priority, deadLine: deadLine, commentary: commentary, location: location)
        
        return task
    }
    
    //Check if field are not nil and not empty
    func isFieldFill(_ field: String?) -> Bool {
        guard let field = field else {
            return false
        }
        if field.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    //Add task with only title in localTaskList
    func updateProject(_ title: String?) {
        guard let title = title else {return}
        localTasksList?.append(createTaskObject(title, nil, nil, nil, nil, nil, nil))
    }
    
    //Add project to local User projects
    func updateLocalData(withProject: Project?) {
        guard let project = withProject else {
            return
        }
        self.data?.user.projects?.append(project)
    }
    
    //Add task to localTaskList
    func updateLocalTaskData(withTask: Task?) {
        guard let task = withTask else {
            return
        }
        localTasksList?.append(task)
    }
}
