//
//  ProjectReaderPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/10/2021.
//

import Foundation


class ProjectReaderPresenter {
    weak var delegate: ProjectManagerDelegate?
    
    let projectService: ProjectLogic = ProjectService()
    var selectedProject: Project?
    var userData: CustomResponse?
    var updateTaskList: [Task]? = []
    
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
    
    
    func addNewTask(_ title: String?) {
        let task = createTaskObject(title)
        self.selectedProject?.taskList?.append(task)
        self.projectService.registerTask([task], selectedProject) { error in
            if error != nil {
                self.removeTaskFromLocalData(task)
                guard let error = error else {return}
                self.delegate?.addTaskFromReaderComplete(.failure(error))
            } else {
                self.delegate?.addTaskFromReaderComplete(.success(()))
            }
        }
    }
    
    func deleteProject() {
        //Done
        projectService.deleteProject(selectedProject) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteProjectComplete(.failure(error))
            } else {
                self.delegate?.deleteProjectComplete(.success(()))
            }
        }
    }
    
    //Use in PC tableView
    func updateTask( _ task: Task?) {
        projectService.updateValidateStatement(selectedProject, selectedTask: task, userData) { result in
            switch result {
            case.failure(let error):
                self.unvalidateTask(task)
                self.delegate?.updateValidateStatementComplete(.failure(error))
            case.success:
                self.delegate?.updateValidateStatementComplete(.success(nil))
            }
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
    
    private func unvalidateTask(_ task: Task?) {
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
    
    func refreshCurrentProject() {
        //Done
        projectService.refreshCurrentProject(selectedProject, userData) { project, error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.fetchCurrentProjectComplete(.failure(error))
                print("Can't refresh project")
            } else {
                self.selectedProject = project
                self.delegate?.fetchCurrentProjectComplete(.success(()))
                print("successFully update")
            }
        }
    }
    
    private func createTaskObject(_ title: String?, _ projectID: String? = nil, _ taskID: String? = nil, _ priority: Bool? = nil, _ deadLine: Date? = nil, _ location: String? = nil) -> Task {
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
    
    
    //    private func updateProject(_ coverData: Data?) {
    //        projectService.updateProject(selectedProject, userData, coverData) { error in
    //            if error != nil {
    //                guard let error = error else {return}
    //                self.delegate?.updateProjectComplete(.failure(error))
    //            } else {
    //                self.delegate?.updateProjectComplete(.success(nil))
    //            }
    //        }
    //    }
    
    private func removeTaskFromLocalData(_ task: Task?) {
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
