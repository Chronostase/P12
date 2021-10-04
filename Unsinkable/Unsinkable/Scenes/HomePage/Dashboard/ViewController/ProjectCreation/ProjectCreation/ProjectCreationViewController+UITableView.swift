//
//  ProjectCreationViewController+UITableView.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation
import UIKit

extension ProjectCreationViewController: UITableViewDelegate {
    
}

extension ProjectCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasksList = self.projectCreationPresenter.localTasksList?.count else {
            return 0
        }
        return tasksList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? CustomTaskTableViewCell else {
            return UITableViewCell()
        }
        
        guard let task = self.projectCreationPresenter.localTasksList?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(task)
        return cell
    }
}
