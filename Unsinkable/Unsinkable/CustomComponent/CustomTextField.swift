//
//  CustomTextField.swift
//  Unsinkable
//
//  Created by Thomas on 23/02/2021.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //Set aspect of UIElement
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0,height: 3)
//        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}
