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
    func registerProjectComplete(_ result: Result<Project?, UnsinkableError>) {
        switch result {
        case .success(let project):
            
            //Save in local Data
            projectCreationPresenter.updateLocalData(withProject: project)
            guard let project = project else {
                return
            }
            coordinator?.data.user.projects?.append(project)
            
            //Register task only if their is existing task
            if project.taskList?.isEmpty != true {
                projectCreationPresenter.registerTask(project)
            } else {
                self.dismiss(animated: true) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            self.navigationController?.dismiss(animated: true, completion: {
                self.presentSimpleAlert(message: messageBody, title: error.localizedDescription)
            })
        }
    }

    func registerTaskComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            print("It succeed")
            DispatchQueue.main.async {
                self.navigationController?.dismiss(animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        case .failure(let error):
            self.navigationController?.dismiss(animated: true, completion: {
                guard let messageBody = error.errorDescription else {return}
                self.alertThatNeedPop(message: messageBody, title: error.localizedDescription)
            })
        }
    }

}
