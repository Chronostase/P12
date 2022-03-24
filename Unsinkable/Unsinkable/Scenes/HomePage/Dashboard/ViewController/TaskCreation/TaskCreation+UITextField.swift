//
//  TaskCreation+UITextField.swift
//  Unsinkable
//
//  Created by Thomas on 13/10/2021.
//

import Foundation
import UIKit

extension TaskCreationViewController: UITextFieldDelegate {
    
    //Resigne first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
