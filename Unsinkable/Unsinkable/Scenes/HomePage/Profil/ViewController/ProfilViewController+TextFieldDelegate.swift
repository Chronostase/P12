//
//  ProfilViewController+TextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 09/12/2021.
//

import Foundation
import UIKit

extension ProfilViewController: UITextFieldDelegate {
    
    //Resign first responder 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
