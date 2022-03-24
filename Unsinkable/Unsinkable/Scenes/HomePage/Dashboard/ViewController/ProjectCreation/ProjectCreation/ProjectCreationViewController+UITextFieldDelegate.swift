//
//  ProjectCreationViewController+UITextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 23/06/2021.
//

import Foundation
import UIKit

extension ProjectCreationViewController: UITextFieldDelegate {
    //Resign first responder 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


