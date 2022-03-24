//
//  LoginViewControllerTextFieldDelegat.swift
//  Unsinkable
//
//  Created by Thomas on 23/02/2021.
//

import Foundation
import UIKit

extension LogInViewController: UITextFieldDelegate {
    
    //Resign first Responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Remove last entry from textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil 
    }
}
