//
//  TextFieldExtension.swift
//  Unsinkable
//
//  Created by Thomas on 23/02/2021.
//

import Foundation
import UIKit

extension UITextField {
    
    func setPlaceholder(_ placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.link.withAlphaComponent(0.5)])
    }
}
