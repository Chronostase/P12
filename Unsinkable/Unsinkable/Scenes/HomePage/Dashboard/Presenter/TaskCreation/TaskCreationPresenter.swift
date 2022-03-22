//
//  TaskCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 13/10/2021.
//

import Foundation

protocol TaskCreationPresenterLogic {
    func updateLocalTask(with title: String?, location: String?, priority: Bool?, commentary: String?, deadLine: Date?)
    func isTaskReader() -> Bool
    func isDeadLineViewNeeded() -> Bool
    func isDeleteTaskNeeded() -> Bool
    func deleteUserTask(completion: @escaping (Result<Void, UnsinkableError>) -> Void)
    func updateUserTask(with title: String?, location: String?, priority: Bool?, commentary: String?, deadLine: Date?, completion: @escaping (Result<Void, UnsinkableError>) -> Void)
}


class TaskCreationPresenter {
    weak var delegate: ProjectManagerDelegate?
    var userData: CustomResponse?
    var project: Project?
    var task: Task?
    var isReader: Bool?
    let service: ProjectLogic
    
    init (session: ProjectLogic = ProjectService()) {
        self.service = session
    }
    
    func deleteTask() {
        //Done
        deleteUserTask { result in
            switch result {
            case .success(_):
                self.delegate?.deleteTaskComplete(.success(()))
            case .failure(let error):
                self.delegate?.deleteTaskComplete(.failure(error))
            }
        }
    }
    
    func updateTask(with title: String?, location: String?, priority: Bool?, commentary: String?, deadLine: Date?) {
        updateUserTask(with: title, location: location, priority: priority, commentary: commentary, deadLine: deadLine) { result in
            switch result {
            case .success(_):
                self.delegate?.updateTaskComplete(.success(nil))
            case .failure(let error):
                self.delegate?.updateTaskComplete(.failure(error))
            }
        }
    }
}
