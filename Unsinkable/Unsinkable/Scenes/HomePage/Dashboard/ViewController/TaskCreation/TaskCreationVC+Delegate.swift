//
//  TaskCreationVC+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 25/11/2021.
//

import Foundation

extension TaskCreationViewController: ProjectCreationPresenterDelegate {
    func deleteTaskSucceed() {
        print("It work")
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteTaskFailure() {
        print("It Failed")
    }
    
    
}
