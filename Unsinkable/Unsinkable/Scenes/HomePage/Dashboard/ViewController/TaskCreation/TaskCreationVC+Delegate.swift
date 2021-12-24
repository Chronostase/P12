//
//  TaskCreationVC+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 25/11/2021.
//

import Foundation

//extension TaskCreationViewController: ProjectCreationPresenterDelegate {
//    
//    func updateTaskSucceed() {
//        print("Successfully update")
//        
//        #warning("See to update localTaskList, or fetch new TaskProject")
//    }
//    
//    func updateTaskFailed() {
//        print("An error happend while updating task")
//    }
//    
//    func deleteTaskSucceed() {
//        print("It work")
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func deleteTaskFailure() {
//        print("It Failed")
//    }
//}

extension TaskCreationViewController: ProjectManagerDelegate {
    //MARK: - Update methods
    func updateTaskComplete(_ result: Result<Task?, Error>) {
        switch result {
        case .success( _):
        print("Update task succeed, need to fetch with local task list to reload Main project reader, or fetch data in viewWillAppear")
        case .failure(let error):
        print("Error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete methods
    
    func deleteTaskComplete(_ result: Result<Void, Error>) {
        switch result {
        case .success(_):
            print("Task delete")
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
        print("Error: \(error.localizedDescription)")
        
        }
    }
    
}
