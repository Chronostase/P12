//
//  ProjectReaderVC+TableViewDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 30/09/2021.
//

import Foundation
import UIKit

extension ProjectReaderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let taskList = projectReaderPresenter.selectedProject?.taskList else {
            return 0
        }
        if taskList.count < 1 {
            return 1
        }
        let validateTasks = taskList.filter{$0?.isValidate == true}
        let unValidateTasks = taskList.filter{$0?.isValidate == false}
        
        if unValidateTasks.count > 0 && validateTasks.count < 1 {
            return 1
        } else if unValidateTasks.count < 1 && validateTasks.count > 0 {
            return 1
        } else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let taskList = projectReaderPresenter.selectedProject?.taskList else {return 0.0}
        let unValidateTaskCount = taskList.filter{$0?.isValidate != true}.count
        let validateTaskCount = taskList.filter{$0?.isValidate == true}.count
        
        
        if unValidateTaskCount > 0 && validateTaskCount < 1 {
            return 0.0
        } else if unValidateTaskCount < 1 && validateTaskCount > 0 {
            return 20.0
        } else {
            if section == 0 {
                return 0.0
            } else {
                return 20.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else {return}
        view.textLabel?.text = Constants.Label.finishedTask
        view.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taskList = projectReaderPresenter.selectedProject?.taskList else {
            return 0
        }
        let unValidateTaskCount = taskList.filter{$0?.isValidate != true}.count
        let validateTaskCount = taskList.filter{$0?.isValidate == true}.count
        
        if unValidateTaskCount > 0 && validateTaskCount < 1 {
            return unValidateTaskCount
        } else if unValidateTaskCount < 1 && validateTaskCount > 0 {
            return validateTaskCount
        } else if unValidateTaskCount > 0 && validateTaskCount > 0 {
            if section == 0 {
                return unValidateTaskCount
            } else {
                return validateTaskCount
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.taskCell, for: indexPath) as? CustomTaskTableViewCell else {
            return UITableViewCell()
        }
        
        guard let taskList = self.projectReaderPresenter.selectedProject?.taskList else {
            return UITableViewCell()
        }
        
        let validateTasks = taskList.filter{$0?.isValidate == true}
        let unValidateTasks = taskList.filter{$0?.isValidate == false}
        
        if unValidateTasks.count > 0 && validateTasks.count < 1 {
            guard let task = unValidateTasks[indexPath.row] else {return UITableViewCell()}
            cell.backgroundColor = .white
            cell.delegate = self
            cell.task = task
            cell.configure()
            return cell
        } else if unValidateTasks.count < 1 && validateTasks.count > 0 {
            guard let task = validateTasks[indexPath.row] else {return UITableViewCell()}
            cell.backgroundColor = .green
            cell.delegate = self
            cell.task = task
            cell.configure()
            return cell
        } else if unValidateTasks.count > 0 && validateTasks.count > 0 {
            if indexPath.section == 0 {
                guard let task = unValidateTasks[indexPath.row] else {return UITableViewCell()}
                cell.backgroundColor = .white
                cell.delegate = self
                cell.task = task
                cell.configure()
                return cell
            } else if indexPath.section == 1 {
                guard let task = validateTasks[indexPath.row] else {return UITableViewCell()}
                cell.backgroundColor = .green
                cell.delegate = self
                cell.task = task
                cell.configure()
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ProjectReaderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let project = self.projectReaderPresenter.selectedProject, let userData = self.projectReaderPresenter.userData else {return}
        guard let taskList = self.projectReaderPresenter.selectedProject?.taskList else {
            return
        }
        
        guard let selectedTask = taskList[indexPath.row] else {
            return
        }
        self.coordinator?.taskEditor(task: selectedTask,project, true, userData)
    }
}

extension ProjectReaderViewController: CustomTaskTableViewCellDelegate {
    func tapCheckMarkButton(_ task: Task?) {
        //Suppose to validate task after reload TBV if .validate == true then green
        //If it failed should keep taskID who failed and change it in LocalDataSource
        self.projectReaderPresenter.validateTask(task)
        
//        self.projectReaderPresenter.updateTaskList?.append(task!)
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
        guard let currentTaskList = self.projectReaderPresenter.selectedProject?.taskList else {return}
        for currentTask in currentTaskList {
            if task?.taskID == currentTask?.taskID {
                self.projectReaderPresenter.updateTask(currentTask)
            }
        }
//        debouncer.renewInterval()
        print("Renew interval")
        
//        debouncer.handler = {
//            print("Enter in debouncer handler")
//            guard let currentTaskList = self.projectReaderPresenter.selectedProject?.taskList else {return}
//            #warning("Problem here if user try to save all task in short time, only save the last cause of debouncer")
////            for currentTask in currentTaskList {
////                if task?.taskID == currentTask?.taskID {
////                    self.projectReaderPresenter.updateTask(currentTask)
////                }
////            }
////            for task in self.projectReaderPresenter.updateTaskList! {
////                var newTask = task
////                if newTask.isValidate == true {
////                    newTask.isValidate = false
////                    self.projectReaderPresenter.updateTask(newTask)
////                } else {
////                    newTask.isValidate = true
////                    self.projectReaderPresenter.updateTask(newTask)
////                }
////            }
//        }
    }
    
    
}
