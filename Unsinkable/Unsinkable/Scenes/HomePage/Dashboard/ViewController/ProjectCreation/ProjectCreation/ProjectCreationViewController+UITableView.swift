//
//  ProjectCreationViewController+UITableView.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation
import UIKit


extension ProjectCreationViewController: UITableViewDataSource {
    
    //Set the number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasksList = projectCreationPresenter.localTasksList?.count else {
            return 0
        }
        return tasksList
    }
    
    //Configure cell with task Data 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.taskCell, for: indexPath) as? CustomTaskTableViewCell else {
            return UITableViewCell()
        }
        
        guard let task = projectCreationPresenter.localTasksList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.task = task
        cell.configure()
        return cell
    }
    
}


extension ProjectCreationViewController: UITableViewDelegate {
    
    //Call coordinator to push taskCreation ViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let task = projectCreationPresenter.localTasksList?[indexPath.row] else {
            return
        }

        coordinator?.taskEditor(task: task, parentCreationVC: self)
    }
}

