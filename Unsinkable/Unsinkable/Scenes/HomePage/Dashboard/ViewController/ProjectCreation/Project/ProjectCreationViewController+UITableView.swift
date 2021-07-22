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
        guard let taskArrayCount = self.projectCreationPresenter.data?.user.projects?.count else {
            return 0
        }
        return taskArrayCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? CustomTaskTableViewCell else {
            return UITableViewCell()
//        }
//        guard let userTask = self.projectCreationPresenter.data?.user.project?[indexPath.row]?.task?[indexPath.row] else {
//            return UITableViewCell()
//        }
//
//        guard let title = userTask.title else {
//            return UITableViewCell()
//        }
        
//        cell.firstConfigure(title)
        
//        cell.configure(userTask.title, <#T##memberCount: String##String#>, <#T##firstImage: UIImage##UIImage#>, <#T##secondImage: UIImage##UIImage#>, <#T##thirdImage: UIImage##UIImage#>)
    }
    
    
}
