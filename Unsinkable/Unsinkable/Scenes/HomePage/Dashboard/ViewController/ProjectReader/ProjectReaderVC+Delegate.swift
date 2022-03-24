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
    
    //Switch updateStatement result to handle tableView and error
    func updateValidateStatementComplete(_ result: Result<Task?, UnsinkableError>) {
        switch result {
        case .success:
            self.taskTableView.reloadData()
        case .failure(let error):
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            guard let messageBody = error.errorDescription else {return}
            self.presentSimpleAlert(message: messageBody , title: error.localizedDescription)
        }
    }
    //MARK: - Delete methods
    //Switch deleteProject result to manage navigation in success case and handle error in failure
    func deleteProjectComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success:
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            self.navigationController?.dismiss(animated: true, completion: {
                self.presentSimpleAlert(message: messageBody, title: error.localizedDescription)
            })
        }
    }
    
    //Switch fetchProject result to handle data in success and show error in failure
    func fetchCurrentProjectComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success:
            DispatchQueue.main.async {
                self.configureViewController()
            }
            self.taskTableView.reloadData()
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            self.alertThatNeedPop(message: messageBody, title: error.localizedDescription)
        }
    }
    
    //Switch addTask result to show error or hide loader
    func addTaskFromReaderComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            navigationController?.dismiss(animated: true, completion: nil)
            print("Register task succeed ")
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            navigationController?.dismiss(animated: true, completion: {
                self.taskTableView.reloadData()
                self.presentSimpleAlert(message: messageBody, title: error.localizedDescription)
            })
        }
    }
}
