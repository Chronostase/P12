//
//  ProjectReaderViewController+TextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2022.
//

import Foundation
import UIKit

extension ProjectReaderViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.placeholder = Constants.Label.addTaskHolder
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
