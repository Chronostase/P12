//
//  TaskCreationPresenter+TaskCreationPresenterLogic.swift
//  Unsinkable
//
//  Created by Thomas on 17/03/2022.
//

import Foundation

extension TaskCreationPresenter: TaskCreationPresenterLogic {
    
    func deleteUserTask(completion: @escaping (Result<Void, UnsinkableError>) -> Void) {
        //Done
        service.deleteTask(project, task) { error in
            if error != nil {
                guard let error = error else {return}
                completion(.failure(error))
                return
            } else {
                completion(.success(()))
                return
            }
        }
    }
    
    func updateUserTask(with title: String?, location: String?, priority: Bool?, commentary: String?, deadLine: Date?, completion: @escaping (Result<Void, UnsinkableError>) -> Void) {
        let newTask = Task(title: title, projectID: task?.projectID, taskID: task?.taskID, priority: priority, deadLine: deadLine, commentary: commentary, location: location)
        service.updateTask(project, currentTask: task, newTask: newTask, userData) { error in
            if error != nil {
                guard let error = error else {return}
                completion(.failure(error))
                return
            } else {
                completion(.success(()))
                return
            }
        }
    }
    
    func updateLocalTask(with title: String?, location: String?, priority: Bool?, commentary: String?, deadLine: Date?) {
        
        let task = Task(title: title, projectID: task?.projectID, taskID: task?.taskID, priority: priority, deadLine: deadLine, commentary: commentary, location: location)
        delegate?.updateLocalTask(task)
    }
    
    func isTaskReader() -> Bool {
        guard let boolean = isReader else {
            return false
        }
        return boolean
    }
    
    func isDeadLineViewNeeded() -> Bool {
        guard let isReader = isReader else {return false}
        if isReader {
            if task?.deadLine != nil {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func isDeleteTaskNeeded() -> Bool {
        if userData?.user.userId == project?.ownerUserId {
            return true
        } else {
            return false
        }
    }
}
