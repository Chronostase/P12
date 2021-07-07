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
    
    func removeLeftAndRightBorder() {
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 1)
        topBorder.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.5647058824, blue: 1, alpha: 1)
        borderStyle = .none
        layer.addSublayer(topBorder)

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: bounds.size.height-1, width: bounds.size.width, height: 1)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.5647058824, blue: 1, alpha: 1)
        borderStyle = .none
        layer.addSublayer(bottomBorder)
    }
}
