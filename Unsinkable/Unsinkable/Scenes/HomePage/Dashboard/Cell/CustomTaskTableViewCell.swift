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
    
    //user delegate methode to validate / unvalidate task
    @IBAction func checkMarkButton(_ sender: UIButton) {
        delegate?.tapCheckMarkButton(task)
    }
    
    //Use to configure taskCell 
    func configure() {
        self.priorityButton.isUserInteractionEnabled = false
        self.taskTitle.text = task?.title
        
        if let priority = task?.priority {
            if priority == true {
                self.priorityButton.tintColor = UIColor.red
            } else {
                self.priorityButton.tintColor = .blue
            }
        }
    }
}
