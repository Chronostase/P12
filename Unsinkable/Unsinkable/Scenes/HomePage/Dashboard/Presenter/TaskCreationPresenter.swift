//
//  TaskCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 13/10/2021.
//

import Foundation


class TaskCreationPresenter {
    weak var delegate: ProjectManagerDelegate?
    let projectService: ProjectLogic = ProjectService()
    var userData: CustomResponse?
    var project: Project?
    var task: Task?
    var isReader: Bool?
    
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
    
    func formatToDate(from date: String?) -> Date?  {
        guard let stringDate = date else {return nil}
        print("StringDate \(stringDate)")
        let isoformatter = ISO8601DateFormatter()
        isoformatter.timeZone = .current
        if let date = isoformatter.date(from: stringDate) {
            print("Success date \(date)")
            return date
        } else {
            print("Error with date")
            return nil
        }
    }
    
    func isDeleteTaskNeeded() -> Bool {
        if userData?.user.userId == project?.ownerUserId {
            return true
        } else {
            return false
        }
    }
    
    func deleteTask() {
        projectService.deleteTask(project, task) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteTaskComplete(.failure(error))
            } else {
                self.delegate?.deleteTaskComplete(.success(()))
            }
            
        }
    }
    
    func updateTask(with title: String?, location: String?, priority: Bool?, commentary: String?, deadLine: Date?) {
        let newTask = Task(title: title, projectID: task?.projectID, taskID: task?.taskID, priority: priority, deadLine: deadLine, commentary: commentary, location: location)
        projectService.updateTask(project, currentTask: task, newTask: newTask, userData) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.updateTaskComplete(.failure(error))
            } else {
                self.delegate?.updateTaskComplete(.success(nil))
            }
        }
    }
}
