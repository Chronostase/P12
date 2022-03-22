//
//  CustomProjectCell.swift
//  Unsinkable
//
//  Created by Thomas on 22/07/2021.
//

import Foundation
import UIKit
import Kingfisher

class CustomProjectCell: UICollectionViewCell {
    @IBOutlet var projectTitle: UILabel!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var contentLabelView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func configureWith(_ project: Project) {
        self.projectTitle.text = project.title
        if project.downloadUrl == nil {
            self.coverImage.image = UIImage(named: "cover")
        } else {
            guard let downloadURL = project.downloadUrl else {
                return
            }
            let url = URL(string: downloadURL)
            self.coverImage.kf.setImage(with: url, placeholder: UIImage(named: Constants.Image.cover), options: nil, completionHandler: nil)
        }
    }
    
    private func setupLayout() {
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.contentLabelView.layer.cornerRadius = 8.0
        self.contentLabelView.layer.borderWidth = 0.3
        self.contentLabelView.layer.borderColor = UIColor.white.cgColor
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
