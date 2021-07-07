//
//  CustomAppleSignIn.swift
//  Unsinkable
//
//  Created by Thomas on 22/06/2021.
//

import Foundation
import UIKit

class CustomAppleSignIn: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitle("Sign in with Apple", for: .normal)
        guard let appleLogo = UIImage(named: "White Logo Square") else {
            return
        }
        self.setImage(appleLogo, for: .normal)
//        self.leftImage(image: appleLogo)
        imageView?.layer.cornerRadius = bounds.height/2
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 3.5, bottom: 0, right: 0)
        
        setTitleColor(.white, for: .normal)
        layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.cornerRadius = bounds.height / 2
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0,height: 2)
    }
}
