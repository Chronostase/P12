//
//  CustomTaskTableViewCell.swift
//  Unsinkable
//
//  Created by Thomas on 15/07/2021.
//

import Foundation
import UIKit

protocol CustomTaskTableViewCellDelegate: AnyObject {
    func tapCheckMarkButton(_ task: Task?)
}

class CustomTaskTableViewCell: UITableViewCell {
    
    @IBOutlet var checkMarkButton: UIButton!
    @IBOutlet var priorityButton: UIButton!
    @IBOutlet var taskTitle: UILabel!
    @IBOutlet var memberCountLabel: UILabel!
    @IBOutlet var firstMemberImage: UIImageView!
    @IBOutlet var secondMemberImage: UIImageView!
    @IBOutlet var thirdMemberImage: UIImageView!
    
    weak var delegate: CustomTaskTableViewCellDelegate?
    var task: Task?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func checkMarkButton(_ sender: UIButton) {
        delegate?.tapCheckMarkButton(task)
    }
    @IBAction func priorityButton(_ sender: UIButton) {
    }
    
    func configure(_ task: Task?) {
        self.taskTitle.text = task?.title
    }
    
//    func configure(_ title: String, _ memberCount: String, _ firstImage: UIImage, _ secondImage: UIImage, _ thirdImage: UIImage) {
//        self.taskTitle.text = title
//        self.memberCountLabel.text = memberCount
//        self.firstMemberImage.image = firstImage
//        self.secondMemberImage.image = secondImage
//        self.thirdMemberImage.image = thirdImage
//    }
}
