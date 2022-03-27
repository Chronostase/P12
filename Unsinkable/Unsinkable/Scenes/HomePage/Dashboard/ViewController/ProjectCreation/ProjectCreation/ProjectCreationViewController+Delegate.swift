//
//  ProjectCreationViewController+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation

extension ProjectCreationViewController: ProjectManagerDelegate {

    //MARK: - Update methods
    //Update local task and replace it in localtasklist 
    func updateLocalTask(_ task: Task) {
        var index = 0
        guard var localtasksList = projectCreationPresenter.localTasksList else {return}

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
    
    //Switch result to handle data in success case and show error in failure case
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
    
    //Switch result to show error in failure case and manage navigation in success
    func registerTaskComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
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
