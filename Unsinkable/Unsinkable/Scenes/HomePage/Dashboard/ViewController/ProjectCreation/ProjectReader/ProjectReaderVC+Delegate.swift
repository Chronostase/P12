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
        print("Delete project Failed")
    }
    
    
    
    func deleteProjectSucceed() {
        print("delete project succeed")
        self.navigationController?.popViewController(animated: true)
    }
    
}
