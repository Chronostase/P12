//
//  ProjectCreationViewController+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation

//extension ProjectCreationViewController: ProjectCreationPresenterDelegate {
//
//
//    func updateLocalTask(_ task: Task) {
//        var index = 0
//        guard var localtasksList = projectCreationPresenter.localTasksList else {return print("Their is no localtasksList")}
//
//        for olderTask in localtasksList {
//            if task.taskID == olderTask?.taskID {
//                localtasksList.remove(at: index)
//                localtasksList.insert(task, at: index)
//            }
//            index += 1
//        }
//        projectCreationPresenter.localTasksList = localtasksList
//        self.navigationController?.popViewController(animated: true)
//
//    }
//    func registerTaskFailure() {
//        print("Register task Failed")
//        self.navigationController?.popViewController(animated: true)
//
//    }
//
//    func registerTaskSucceed(_ task: Task?) {
//        print("Register task succeed")
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func fetchProjectSucceed() {
//    }
//
//    func registerProjectSucceed(_ project: Project?) {
//        projectCreationPresenter.updateLocalData(withProject: project)
//        guard let project = project else {
//            return
//        }
//
//        coordinator?.data.user.projects?.append(project)
//        if project.taskList != nil {
//            projectCreationPresenter.registerTask(taskTextField.text, project)
//        } else {
//            self.navigationController?.popViewController(animated: true)
//        }
////        self.coordinator?.start()
//        print("LeaveRegisterSucceed")
//    }
//
//    func registerProjectFailure() {
//        print("Error")
//    }
//
//    func showErrorMessage() {
//        print("Empty fields")
//    }
//
//}

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
            if project.taskList != nil {
                projectCreationPresenter.registerTask(taskTextField.text, project)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            print("LeaveRegisterSucceed")
            print("It succeed")
            self.navigationController?.popViewController(animated: true)
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

}
