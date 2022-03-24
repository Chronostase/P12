//
//  UIView.swift
//  Unsinkable
//
//  Created by Thomas on 01/02/2022.
//

import Foundation
import UIKit

extension UIView {
    
    enum ViewSide {
            case left, right, top, bottom
        }
    //Add border to view 
        func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

            let border = CALayer()
            border.backgroundColor = color

            switch side {
            case .left: border.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: thickness, height: self.frame.size.height)
            case .right: border.frame = CGRect(x: self.frame.size.width - thickness, y: self.frame.origin.y, width: thickness, height: self.frame.size.height)
            case .top: border.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: thickness)
            case .bottom: border.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height - thickness, width: self.frame.size.width, height: thickness)
            }
            self.layer.addSublayer(border)
        }
}
