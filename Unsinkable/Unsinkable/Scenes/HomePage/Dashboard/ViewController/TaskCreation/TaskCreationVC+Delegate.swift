//
//  TaskCreationVC+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 25/11/2021.
//

import Foundation

extension TaskCreationViewController: ProjectManagerDelegate {
    
    //MARK: - Update methods
    func updateTaskComplete(_ result: Result<Task?, UnsinkableError>) {
        switch result {
        case .success( _):
            self.navigationController?.dismiss(animated: true, completion: nil)
        case .failure(let error):
            self.navigationController?.dismiss(animated: true, completion: {
                guard let messageBody = error.errorDescription else {return}
                self.presentSimpleAlert(message: messageBody, title: error.localizedDescription)
            })
        }
    }
    
    //MARK: - Delete methods
    
    func deleteTaskComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(_):
            print("Task delete")
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            self.navigationController?.dismiss(animated: true, completion: {
                guard let messageBody = error.errorDescription else {return}
                self.presentSimpleAlert(message: messageBody, title: error.localizedDescription)
            })
        
        }
    }
    
}
