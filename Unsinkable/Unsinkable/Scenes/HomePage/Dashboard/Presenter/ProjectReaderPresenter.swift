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
        //Maybe in success part with loader / reload tbV
        self.selectedProject?.taskList?.append(task)
        self.projectService.registerTask([task], selectedProject) { reponse, error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.addTaskFromReaderComplete(.failure(error))
            } else {
                self.delegate?.addTaskFromReaderComplete(.success(()))
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
    
    func deleteProject() {
        projectService.deleteProject(selectedProject) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.deleteProjectComplete(.failure(error))
            } else {
                self.delegate?.deleteProjectComplete(.success(()))
            }
        }
    }
    
    func updateProject(_ coverData: Data?) {
        projectService.updateProject(selectedProject, userData, coverData) { error in
            if error != nil {
                guard let error = error else {return}
                self.delegate?.updateProjectComplete(.failure(error))
            } else {
                self.delegate?.updateProjectComplete(.success(nil))
            }
        }
    }
    
    func updateTask( _ task: Task?) {
        projectService.updateValidateStatement(selectedProject, selectedTask: task, userData) { result in
            switch result {
            case.failure(let error):
                self.delegate?.updateTaskComplete(.failure(error))
            case.success:
                self.delegate?.updateTaskComplete(.success(nil))
            }
        }
    }
    
    func refreshCurrentProject() {
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
    
    func validateTask(_ task: Task?) {
        var index = 0
        guard let validateTask = task, let localTaskList = selectedProject?.taskList else {return}
        for task in localTaskList {
            if validateTask.taskID == task?.taskID && validateTask.isValidate == false {
                self.selectedProject?.taskList?[index]?.isValidate = true
                index += 1
            } else if validateTask.taskID == task?.taskID && validateTask.isValidate == true {
                self.selectedProject?.taskList?[index]?.isValidate = false
                index += 1
            }
            index += 1
        }
        
    }
}
