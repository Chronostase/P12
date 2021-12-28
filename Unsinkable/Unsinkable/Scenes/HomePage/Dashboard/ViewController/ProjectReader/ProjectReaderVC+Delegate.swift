//
//  ProjectReaderVC+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/11/2021.
//

import Foundation
import UIKit

extension ProjectReaderViewController: ProjectManagerDelegate {
    //MARK: - Update methods
    func updateProjectComplete(_ result: Result<Project?, Error>) {
        switch result {
        case .success(_):
            self.navigationController?.dismiss(animated: true, completion: nil)
            print("Update Succeed")
        case .failure(let error):
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func updateTaskComplete(_ result: Result<Task?, Error>) {
        switch result {
        case .success:
            print("Update taskSucceed")
        case . failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    //MARK: - Delete methods
    func deleteProjectComplete(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            print("Success to delete project")
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchCurrentProjectComplete(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            DispatchQueue.main.async {
                self.configureViewController()
            }
//            self.navigationController?.dismiss(animated: true, completion: nil)
            self.taskTableView.reloadData()
        case .failure(let error):
//            self.navigationController?.dismiss(animated: true, completion: nil)
            print("Error: \(error.localizedDescription)")
        }
    }
}
