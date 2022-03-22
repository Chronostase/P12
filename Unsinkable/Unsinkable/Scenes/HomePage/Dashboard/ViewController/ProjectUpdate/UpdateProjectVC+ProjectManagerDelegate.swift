//
//  UpdateProjectVC+ProjectManagerDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 28/12/2021.
//

import Foundation
import UIKit

extension UpdateProjectViewController: ProjectManagerDelegate {
    
    
    func updateProjectComplete(_ result: Result<Project?, UnsinkableError>) {
        switch result {
        case .success(_):
            self.dismiss(animated: true, completion: nil)
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            print("Update Succeed")
        case .failure(let error):
            self.dismiss(animated: true) {
                guard let messageBody = error.errorDescription else {return}
                self.showUpdateAlert(error.localizedDescription, messageBody)
            }
        }
    }
}
