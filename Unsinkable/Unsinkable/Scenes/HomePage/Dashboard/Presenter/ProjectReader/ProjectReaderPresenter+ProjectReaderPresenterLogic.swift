//
//  ProjectReaderPresenter+ProjectReaderPresenterLogic.swift
//  Unsinkable
//
//  Created by Thomas on 17/03/2022.
//

import Foundation

extension ProjectReaderPresenter: ProjectReaderPresenterLogic {
    
    func addUserNewTask(_ title: String?, completion: @escaping (UnsinkableError?) -> Void) {
        let task = createTaskObject(title, nil, nil, nil, nil, nil)
        self.selectedProject?.taskList?.append(task)
        self.service.registerTask([task], selectedProject) { error in
            if error != nil {
                self.removeTaskFromLocalData(task)
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteUserProject(completion: @escaping (UnsinkableError?) -> Void) {
        //Done
        service.deleteProject(selectedProject) { error in
            if error != nil {
                guard let error = error else {return}
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateUserTask( _ task: Task?, completion: @escaping (UnsinkableError?) -> Void) {
        service.updateValidateStatement(selectedProject, selectedTask: task, userData) { result in
            switch result {
            case.failure(let error):
                self.unvalidateTask(task)
                completion(error)
            case.success:
                completion(nil)
            }
        }
    }
    
    func refreshCurrentUserProject(completion: @escaping (UnsinkableError?) -> Void) {
        service.refreshCurrentProject(selectedProject, userData) { project, error in
            if error != nil {
                guard let error = error else {return}
                completion(error)
            } else {
                self.selectedProject = project
                completion(nil)
            }
        }
    }
    
    func checkIfTitleIsNil() -> Bool {
        guard let _ = selectedProject?.title else {
            return true
        }
        return false
    }
    func checkIfCoverPicture() -> Bool {
        guard let _ = selectedProject?.downloadUrl else {
            return false
        }
        return true
    }
    
    func checkIfDescriptionIsEmpty() -> Bool {
        guard let _ = selectedProject?.description else {
            return true
        }
        return false
    }
    
    func checkIfTaskListIsEmpty() -> Bool {
        guard let taskList = selectedProject?.taskList else {
            return true
        }
        if taskList.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func validateTask(_ task: Task?) {
        var index = 0
        guard let validateTask = task, let localTaskList = selectedProject?.taskList else {return}
        for task in localTaskList {
            print("Index = \(index)")
            if validateTask.taskID == task?.taskID && validateTask.isValidate == false {
                self.selectedProject?.taskList?[index]?.isValidate = true
                //                index += 1
            } else if validateTask.taskID == task?.taskID && validateTask.isValidate == true {
                self.selectedProject?.taskList?[index]?.isValidate = false
                //                index += 1
            }
            index += 1
            
        }
    }
    
    func unvalidateTask(_ task: Task?) {
        var index = 0
        guard let task = task, let taskList = selectedProject?.taskList else {return}
        for projectTask in taskList {
            print("Index = \(index)")
            if projectTask?.taskID == task.taskID {
                if self.selectedProject?.taskList?[index]?.isValidate == false {
                    self.selectedProject?.taskList?[index]?.isValidate = true
                } else {
                    self.selectedProject?.taskList?[index]?.isValidate = false
                }
            }
            index += 1
        }
    }
    
    func createTaskObject(_ title: String?, _ projectID: String?, _ taskID: String?, _ priority: Bool?, _ deadLine: Date?, _ location: String?) -> Task {
        let task = Task(title: title, projectID: projectID, taskID: UUID().uuidString, priority: priority, deadLine: deadLine, commentary: Constants.Label.commentaryPlaceHolder, location: location, isValidate: false)
        
        return task
    }
    
    
    func checkTaskTitle(_ taskTitle: String?) -> Bool {
        if taskTitle != "" {
            return true
        } else {
            return false
        }
    }
    
    func removeTaskFromLocalData(_ task: Task?) {
        var index = 0
        guard let task = task else {return}
        guard let taskList = self.selectedProject?.taskList else {return}
        for taskToDelete in taskList {
            if taskToDelete?.taskID == task.taskID {
                self.selectedProject?.taskList?.remove(at: index)
            }
            index += 1
        }
    }
}
