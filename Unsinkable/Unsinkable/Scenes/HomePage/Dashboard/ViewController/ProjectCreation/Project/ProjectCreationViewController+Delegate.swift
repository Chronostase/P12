//
//  ProjectCreationViewController+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation

extension ProjectCreationViewController: ProjectCreationPresenterDelegate {
    func fetchProjectSucceed() {
        print("")
    }
    
    func registerSucceed(_ project: Project?) {
        projectCreationPresenter.updateLocalData(withProject: project)
        coordinator?.data.user.projects?.append(project)
        self.coordinator?.start()
    }
    
    func registerProjectFailure() {
        print("Error")
    }
    
    func showErrorMessage() {
        print("Empty fields")
    }
    
    
}
