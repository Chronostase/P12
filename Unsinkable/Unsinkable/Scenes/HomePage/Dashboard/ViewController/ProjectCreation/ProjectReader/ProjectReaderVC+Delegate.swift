//
//  ProjectReaderVC+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/11/2021.
//

import Foundation
import UIKit

extension ProjectReaderViewController: ProjectReaderDelegate {
    
    
    func deleteProjectFailure() {
        #warning("Show error message, can't proceed to delete because: Error.code")
    }
    
    func deleteProjectSucceed() {
        #warning("Don't Forget to delete project in local datasource + Reload collection")
        print("delete project succeed")
        self.navigationController?.popViewController(animated: true)
    }
    
}
