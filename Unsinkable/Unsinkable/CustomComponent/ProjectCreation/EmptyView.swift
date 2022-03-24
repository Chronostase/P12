//
//  EmptyView.swift
//  Unsinkable
//
//  Created by Thomas on 09/02/2022.
//

import Foundation
import UIKit

class EmptyView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        loadXib()
        setupLayout()
    }
    
    //Load emptyView Xib
    private func loadXib() {
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    //Setup UI of emptyView with shadow 
    private func setupLayout() {
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true

        // cell shadow section
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 5.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.15
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
