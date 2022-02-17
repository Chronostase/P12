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
    
    //Probably don't need anymore
    func updateProjectComplete(_ result: Result<Project?, UnsinkableError>) {
        switch result {
        case .success(_):
            self.navigationController?.dismiss(animated: true, completion: nil)
            print("Update Succeed")
        case .failure(let error):

            self.navigationController?.dismiss(animated: true, completion: nil)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func updateValidateStatementComplete(_ result: Result<Task?, UnsinkableError>) {
        switch result {
        case .success:
            self.taskTableView.reloadData()
            print("Update taskSucceed")
        case .failure(let error):
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            guard let messageBody = error.errorDescription else {return}
            self.presentSimpleAlert(message: messageBody , title: error.localizedDescription)
        }
    }
    //MARK: - Delete methods
    func deleteProjectComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success:
            print("Success to delete project")
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            guard let messageBody = error.errorDescription else {return}
            self.navigationController?.dismiss(animated: true, completion: {
                self.presentSimpleAlert(message: messageBody, title: error.localizedDescription)
            })
        }
    }
    
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
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func addTaskFromReaderComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            //Hide loader
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
