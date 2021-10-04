//
//  ProjectCreationViewController+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation

extension ProjectCreationViewController: ProjectCreationPresenterDelegate {
    func registerTaskFailure() {
        self.coordinator?.start()
    }
    
    func registerTaskSucceed(_ task: Task?) {
        self.coordinator?.start()
    }
    
    func fetchProjectSucceed() {
    }
    
    func registerProjectSucceed(_ project: Project?) {
        projectCreationPresenter.updateLocalData(withProject: project)
        print("project : \(project != nil)")
        guard let project = project else {
            return
        }
        
        #warning("Downloard URL = nil")
//        guard let url = project.downloadUrl else {
//            return
//        }
        print("PrintedProject :")
        print(project)
        print("Register Succeed with this url")
//        print(url)
        coordinator?.data.user.projects?.append(project)
        if project.taskList != nil {
            projectCreationPresenter.registerTask(taskTextField.text, project)
        } else {
            self.coordinator?.start()
        }
//        self.coordinator?.start()
        print("LeaveRegisterSucceed")
    }
    
    func registerProjectFailure() {
        print("Error")
    }
    
    func showErrorMessage() {
        print("Empty fields")
    }

}
