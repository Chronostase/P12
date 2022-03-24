//
//  StackViewShadow.swift
//  Unsinkable
//
//  Created by Thomas on 24/06/2021.
//

import Foundation
import UIKit

class CustomStackViewShadow: UIStackView {
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //Set shadow to stack view 
    override func layoutSubviews() {
        super.layoutSubviews()
        let subView = UIView(frame: bounds)
        subView.backgroundColor = .white
        layer.masksToBounds = false
        subView.layer.cornerRadius = 8
        
        subView.layer.shadowColor = UIColor.darkGray.cgColor
        subView.layer.shadowRadius = 4
        subView.layer.shadowOpacity = 0.15
        subView.layer.shadowOffset = CGSize(width: 0, height: 8)
        subView.autoresizingMask = .flexibleBottomMargin
        subView.clipsToBounds = false
        insertSubview(subView, at: 0)
    }
}
