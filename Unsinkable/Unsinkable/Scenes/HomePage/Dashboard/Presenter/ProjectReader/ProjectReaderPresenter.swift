//
//  ProjectReaderPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/10/2021.
//

import Foundation

protocol ProjectReaderPresenterLogic {
    func checkIfTitleIsNil() -> Bool
    func checkIfCoverPicture() -> Bool
    func checkIfDescriptionIsEmpty() -> Bool
    func checkIfTaskListIsEmpty() -> Bool
    func validateTask(_ task: Task?)
    func unvalidateTask(_ task: Task?)
    func createTaskObject(_ title: String?, _ projectID: String?, _ taskID: String?, _ priority: Bool?, _ deadLine: Date?, _ location: String?) -> Task
    func checkTaskTitle(_ taskTitle: String?) -> Bool
    func removeTaskFromLocalData(_ task: Task?)
    func addUserNewTask(_ title: String?, completion: @escaping (UnsinkableError?) -> Void)
    func deleteUserProject(completion: @escaping (UnsinkableError?) -> Void)
    func updateUserTask(_ task: Task?, completion: @escaping (UnsinkableError?) -> Void)
    func refreshCurrentUserProject(completion: @escaping (UnsinkableError?) -> Void)
}

class ProjectReaderPresenter {
    weak var delegate: ProjectManagerDelegate?
    var selectedProject: Project?
    var userData: CustomResponse?
    var updateTaskList: [Task]? = []
    let service: ProjectLogic
    
    init (session: ProjectLogic = ProjectService()) {
        self.service = session
    }
    
    
    //Rework
    func addNewTask(_ title: String?) {
        addUserNewTask(title) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.addTaskFromReaderComplete(.failure(error))
            } else {
                self.delegate?.addTaskFromReaderComplete(.success(()))
            }
        }
    }
    
    func deleteProject() {
        deleteUserProject { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteProjectComplete(.failure(error))
            } else {
                self.delegate?.deleteProjectComplete(.success(()))
            }
        }
    }
    
    //Use in PC tableView
    func updateTask(_ task: Task?) {
        updateUserTask(task) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.updateValidateStatementComplete(.failure(error))
            } else {
                self.delegate?.updateValidateStatementComplete(.success(nil))
            }
        }
    }
    
    //Rework
    func refreshCurrentProject() {
        refreshCurrentUserProject { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.fetchCurrentProjectComplete(.failure(error))
            } else {
                self.delegate?.fetchCurrentProjectComplete(.success(()))
            }
        }
    }
}
