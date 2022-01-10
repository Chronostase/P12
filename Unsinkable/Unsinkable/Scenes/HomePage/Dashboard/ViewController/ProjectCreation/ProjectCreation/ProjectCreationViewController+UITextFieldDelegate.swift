//
//  ProjectCreationViewController+UITextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 23/06/2021.
//

import Foundation
import UIKit

extension ProjectCreationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activatedObject = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activatedObject = nil
        return textField.resignFirstResponder()
    }
}


