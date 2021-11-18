//
//  ProjectReaderVC+TableViewDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 30/09/2021.
//

import Foundation
import UIKit

extension ProjectReaderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taskListCount = projectReaderPresenter.selectedProject?.taskList?.count else {
            return 0
        }
        return taskListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? CustomTaskTableViewCell else {
            return UITableViewCell()
        }
        
        guard let taskList = self.projectReaderPresenter.selectedProject?.taskList else {
            return UITableViewCell()
        }
        
        guard let task = taskList[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(task)
        return cell
    }
    
    
}

extension ProjectReaderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskList = self.projectReaderPresenter.selectedProject?.taskList else {
            return
        }
        
        guard let selectedTask = taskList[indexPath.row] else {
            return
        }
        
        self.coordinator?.taskEditor(task: selectedTask, true)
    }
}
