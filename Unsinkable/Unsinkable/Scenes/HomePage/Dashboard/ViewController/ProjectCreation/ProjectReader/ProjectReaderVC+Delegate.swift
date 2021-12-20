//
//  ProjectReaderVC+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/11/2021.
//

import Foundation
import UIKit

//extension ProjectReaderViewController: ProjectReaderDelegate {
//    func updateProjectSucceed() {
//        print("Update Succeed")
//    }
//
//    func updateProjectFailed() {
//        print("Update Failed")
//    }
//
//
//
//    func deleteProjectFailure() {
//        #warning("Show error message, can't proceed to delete because: Error.code")
//    }
//
//    func deleteProjectSucceed() {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//}

extension ProjectReaderViewController: ProjectManagerDelegate {
    //MARK: - Update methods
    func updateProjectComplete(_ result: Result<Project?, Error>) {
        switch result {
        case .success(_):
            print("Update Succeed")
        case .failure(let error):
        print("Error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete methods
    func deleteProjectComplete(_ result: Result<Void, Error>) {
        switch result {
        case .success(_):
            print("Success to delete project")
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchCurrentProjectComplete(_ result: Result<Void, Error>) {
        switch result {
        case .success(()):
            self.taskTableView.reloadData()
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}
