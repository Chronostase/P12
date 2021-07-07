//
//  RegisterViewControllerTextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 23/02/2021.
//

import Foundation
import UIKit

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let email = textField.text else {
            return false
        }
        print(Regex.validateEmail(candidate: email))
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
        errorLabel.isHidden = true
    }
}
