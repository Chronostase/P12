//
//  CustomProjectCell.swift
//  Unsinkable
//
//  Created by Thomas on 22/07/2021.
//

import Foundation
import UIKit

class CustomProjectCell: UICollectionViewCell {
    @IBOutlet var projectTitle: UILabel!
    @IBOutlet var coverImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureWith(_ project: Project) {
        self.projectTitle.text = project.title
        self.coverImage.image = UIImage(named: "cover")
    }
}
