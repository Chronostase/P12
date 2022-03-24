//
//  ProjectReaderPresenter+ProjectReaderPresenterLogic.swift
//  Unsinkable
//
//  Created by Thomas on 17/03/2022.
//

import Foundation

extension ProjectReaderPresenter: ProjectReaderPresenterLogic {
    
    //Call service to registerNewTask if failure remove task from localTaskList
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
    
    //Call service to delete user project
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
    
    //Call service to update taskStatement if failure unvalidateTask
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
    
    //Call service to refreshCurrentProject
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
    
    //Check if projectTitle isn't nil
    func checkIfTitleIsNil() -> Bool {
        guard let _ = selectedProject?.title else {
            return true
        }
        return false
    }
    
    //Check if current project have coverPicture to download
    func checkIfCoverPicture() -> Bool {
        guard let _ = selectedProject?.downloadUrl else {
            return false
        }
        return true
    }
    
    //Check if selectedProject description isn't nil
    func checkIfDescriptionIsEmpty() -> Bool {
        guard let _ = selectedProject?.description else {
            return true
        }
        return false
    }
    
    //Check if selected taskList isn't empty
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
    
    //Allow to switch task statement
    func validateTask(_ task: Task?) {
        var index = 0
        guard let validateTask = task, let localTaskList = selectedProject?.taskList else {return}
        for task in localTaskList {
            print("Index = \(index)")
            if validateTask.taskID == task?.taskID && validateTask.isValidate == false {
                self.selectedProject?.taskList?[index]?.isValidate = true
            } else if validateTask.taskID == task?.taskID && validateTask.isValidate == true {
                self.selectedProject?.taskList?[index]?.isValidate = false
            }
            index += 1
            
        }
    }
    
    //In case of failure while saving task statement it reverse task statement
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
    
    //Create task object
    func createTaskObject(_ title: String?, _ projectID: String?, _ taskID: String?, _ priority: Bool?, _ deadLine: Date?, _ location: String?) -> Task {
        let task = Task(title: title, projectID: projectID, taskID: UUID().uuidString, priority: priority, deadLine: deadLine, commentary: Constants.Label.commentaryPlaceHolder, location: location, isValidate: false)
        
        return task
    }
    
    //Check if task have not empty title
    func checkTaskTitle(_ taskTitle: String?) -> Bool {
        if taskTitle != "" {
            return true
        } else {
            return false
        }
    }
    
    //Remove task from local taskList 
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
