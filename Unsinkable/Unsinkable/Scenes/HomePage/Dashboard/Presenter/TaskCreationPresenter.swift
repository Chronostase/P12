//
//  TaskCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 13/10/2021.
//

import Foundation

protocol TaskCreationDelegate: AnyObject  {
    func fetchToProjectCreation()
}

class TaskCreationPresenter {
    weak var delegate: ProjectCreationPresenterDelegate?
    var task: Task?
    var isReader: Bool?
    
    func updateTask(with title: String?, location: String?, priority: Bool?, commentary: String?, deadLine: String?) {
        
        let task = Task(title: title, projectID: task?.projectID, taskID: task?.taskID, priority: priority, deadLine: deadLine, commentary: commentary)
        
        delegate?.updateLocalTask(task)
    }
    
    func isTaskReader() -> Bool {
        guard let boolean = isReader else {
            return false
        }
        return boolean
    }
}
