//
//  ProjectCreationViewController+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation

extension ProjectCreationViewController: ProjectManagerDelegate {

    //MARK: - Update methods
    func updateLocalTask(_ task: Task) {
        var index = 0
        guard var localtasksList = projectCreationPresenter.localTasksList else {return print("Their is no localtasksList")}

        for olderTask in localtasksList {
            if task.taskID == olderTask?.taskID {
                localtasksList.remove(at: index)
                localtasksList.insert(task, at: index)
            }
            index += 1
        }
        projectCreationPresenter.localTasksList = localtasksList
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - RegisterMethods
    func registerProjectComplete(_ result: Result<Project?, Error>) {
        switch result {
        case .success(let project):
            projectCreationPresenter.updateLocalData(withProject: project)
            guard let project = project else {
                return
            }

            coordinator?.data.user.projects?.append(project)
            if project.taskList?.isEmpty != true {
                projectCreationPresenter.registerTask(project)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        case .failure(let error):
            print("error: \(error.localizedDescription)")
            self.navigationController?.popViewController(animated: true)
        }
    }

    func registerTaskComplete(_ result: Result<Task?, Error>) {
        switch result {
        case .success(_):
            print("It succeed")
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            print("error: \(error.localizedDescription)")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showErrorMessage(with message: String) {
        self.navigationController?.dismiss(animated: true, completion: {
            self.presentSimpleAlert(message: message)
        })
    }

}
