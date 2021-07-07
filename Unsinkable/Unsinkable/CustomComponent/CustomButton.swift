//
//  RoundedButton.swift
//  Unsinkable
//
//  Created by Thomas on 18/02/2021.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
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
        setTitleColor(.white, for: .normal)
        layer.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.5647058824, blue: 1, alpha: 1)
        layer.cornerRadius = bounds.height / 2
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0,height: 2)
    }
}
