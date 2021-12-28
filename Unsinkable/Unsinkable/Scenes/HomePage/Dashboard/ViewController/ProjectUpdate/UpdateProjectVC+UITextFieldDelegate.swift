//
//  UpdateProjectVC+UITextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 28/12/2021.
//

import Foundation
import UIKit

extension UpdateProjectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
