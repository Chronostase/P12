//
//  ProjectReaderVC+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/11/2021.
//

import Foundation
import UIKit

extension ProjectReaderViewController: ProjectReaderDelegate {
    func updateProjectSucceed() {
        print("Update Succeed")
    }
    
    func updateProjectFailed() {
        print("Update Failed")
    }
    
    
    
    func deleteProjectFailure() {
        #warning("Show error message, can't proceed to delete because: Error.code")
    }
    
    func deleteProjectSucceed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
