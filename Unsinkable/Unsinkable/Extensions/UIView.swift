//
//  UIView.swift
//  Unsinkable
//
//  Created by Thomas on 01/02/2022.
//

import Foundation
import UIKit

extension UIView {
    
//    enum ViewSide {
//            case Left, Right, Top, Bottom
//        }

//        func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
//
//            let border = CALayer()
//            border.backgroundColor = color
//
//            switch side {
//            case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
//            case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
//            case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
//            case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
//            }
//
//            layer.addSublayer(border)
//        }
    enum ViewSide {
            case left, right, top, bottom
        }

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
