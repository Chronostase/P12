//
//  ViewShadow.swift
//  Unsinkable
//
//  Created by Thomas on 24/06/2021.
//

import Foundation
import UIKit

class CustomView: UIView {
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
        
//        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 8)
    
//        layer.masksToBounds = false
//        layer.cornerRadius = 15
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowRadius = 8
//        layer.shadowOpacity = 0.15
//        layer.shadowOffset = CGSize(width: 0,height: 2)
//
    }
}
