//
//  RegisterViewControllerTextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 23/02/2021.
//

import Foundation
import UIKit

extension RegisterViewController: UITextFieldDelegate {
    //Resign first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Clear last entry and hide error message
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
        errorLabel.isHidden = true
    }
}
