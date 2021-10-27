//
//  ProjectCreationViewController+UITableView.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation
import UIKit


extension ProjectCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasksList = projectCreationPresenter.localTasksList?.count else {
            return 0
        }
        return tasksList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? CustomTaskTableViewCell else {
            return UITableViewCell()
        }
        
        guard let task = projectCreationPresenter.localTasksList?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(task)
        return cell
    }
    
}


extension ProjectCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("before push taskEditor")
        guard let task = projectCreationPresenter.localTasksList?[indexPath.row] else {
            return
        }

        coordinator?.taskEditor(task: task, parentVC: self)
    }
}

