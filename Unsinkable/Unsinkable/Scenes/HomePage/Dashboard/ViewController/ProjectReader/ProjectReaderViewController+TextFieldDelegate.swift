//
//  ProjectReaderViewController+TextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2022.
//

import Foundation
import UIKit

extension ProjectReaderViewController: UITextFieldDelegate {
    //Clear last textField entry and set placeholder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.placeholder = Constants.Label.addTaskHolder
    }
    
    //Resign first respodner 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
