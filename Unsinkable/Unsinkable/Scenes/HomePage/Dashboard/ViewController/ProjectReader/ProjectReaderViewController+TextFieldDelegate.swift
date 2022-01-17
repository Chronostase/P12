//
//  ProjectReaderViewController+TextFieldDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2022.
//

import Foundation
import UIKit

extension ProjectReaderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
